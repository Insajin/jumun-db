-- ============================================================================
-- Jumun - Cloud Supabase Database Initialization
-- ============================================================================
-- Run this script in Supabase SQL Editor to set up the database schema
-- Project: vbwwglhplxmcquiqrqak
-- Date: 2025-10-01
-- ============================================================================

-- ============================================================================
-- STEP 1: Enable Extensions
-- ============================================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- ============================================================================
-- STEP 2: Create Enums
-- ============================================================================

CREATE TYPE subscription_plan AS ENUM ('trial', 'basic', 'professional', 'enterprise');
CREATE TYPE subscription_status AS ENUM ('active', 'expired', 'cancelled', 'grace_period');
CREATE TYPE store_status AS ENUM ('active', 'paused', 'offline', 'inactive');
CREATE TYPE staff_role AS ENUM ('store_staff', 'store_manager', 'brand_admin', 'super_admin');
CREATE TYPE build_platform AS ENUM ('ios', 'android');
CREATE TYPE build_status AS ENUM ('in_progress', 'completed', 'failed');

-- ============================================================================
-- STEP 3: Create Core Tables
-- ============================================================================

-- Brands (Tenants)
CREATE TABLE brands (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    logo_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT brands_name_not_empty CHECK (length(trim(name)) > 0),
    CONSTRAINT brands_slug_format CHECK (slug ~ '^[a-z0-9-]+$')
);

CREATE INDEX idx_brands_slug ON brands(slug);

-- Subscriptions
CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
    plan subscription_plan NOT NULL DEFAULT 'trial',
    status subscription_status NOT NULL DEFAULT 'active',
    trial_ends_at TIMESTAMPTZ,
    expires_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT subscriptions_unique_brand UNIQUE(brand_id)
);

CREATE INDEX idx_subscriptions_brand_id ON subscriptions(brand_id);

-- Stores
CREATE TABLE stores (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    slug TEXT NOT NULL,
    address TEXT,
    lat DOUBLE PRECISION,
    lng DOUBLE PRECISION,
    timezone TEXT NOT NULL DEFAULT 'Asia/Seoul',
    phone TEXT,
    status store_status NOT NULL DEFAULT 'active',
    accepting_orders BOOLEAN NOT NULL DEFAULT TRUE,
    operating_hours JSONB NOT NULL DEFAULT '{}',
    special_hours JSONB NOT NULL DEFAULT '[]',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT stores_name_not_empty CHECK (length(trim(name)) > 0),
    CONSTRAINT stores_unique_brand_slug UNIQUE(brand_id, slug)
);

CREATE INDEX idx_stores_brand_id ON stores(brand_id);
CREATE INDEX idx_stores_status ON stores(status);

-- Staff
CREATE TABLE staff (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    role staff_role NOT NULL DEFAULT 'store_staff',
    permissions JSONB NOT NULL DEFAULT '{}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT staff_unique_user_store UNIQUE(user_id, store_id)
);

CREATE INDEX idx_staff_store_id ON staff(store_id);
CREATE INDEX idx_staff_user_id ON staff(user_id);

-- Customers
CREATE TABLE customers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE,
    phone TEXT,
    phone_verified_at TIMESTAMPTZ,
    loyalty_points INTEGER NOT NULL DEFAULT 0,
    preferences JSONB NOT NULL DEFAULT '{}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT customers_loyalty_points_non_negative CHECK (loyalty_points >= 0)
);

CREATE INDEX idx_customers_user_id ON customers(user_id);

-- ============================================================================
-- STEP 4: Create App Configuration Tables
-- ============================================================================

-- App Configurations (White-Label)
CREATE TABLE app_configs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE UNIQUE,
    app_name TEXT NOT NULL,
    logo_url TEXT,
    splash_screen_url TEXT,
    app_icon_url TEXT,
    primary_color TEXT NOT NULL DEFAULT '#6366F1',
    feature_toggles JSONB NOT NULL DEFAULT '{}',
    build_version TEXT,
    published_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT app_configs_app_name_not_empty CHECK (length(trim(app_name)) > 0),
    CONSTRAINT app_configs_primary_color_valid CHECK (primary_color ~ '^#[0-9A-Fa-f]{6}$')
);

CREATE INDEX idx_app_configs_brand_id ON app_configs(brand_id);

-- App Builds
CREATE TABLE app_builds (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    app_config_id UUID NOT NULL REFERENCES app_configs(id) ON DELETE CASCADE,
    platform build_platform NOT NULL,
    status build_status NOT NULL DEFAULT 'in_progress',
    build_number TEXT,
    download_url TEXT,
    error_message TEXT,
    started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMPTZ,

    CONSTRAINT app_builds_completed_has_download CHECK (
        status != 'completed' OR download_url IS NOT NULL
    )
);

CREATE INDEX idx_app_builds_app_config_id ON app_builds(app_config_id);
CREATE INDEX idx_app_builds_platform ON app_builds(platform);
CREATE INDEX idx_app_builds_status ON app_builds(status);

-- ============================================================================
-- STEP 5: Enable Row Level Security
-- ============================================================================

ALTER TABLE brands ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE staff ENABLE ROW LEVEL SECURITY;
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE app_configs ENABLE ROW LEVEL SECURITY;
ALTER TABLE app_builds ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- STEP 6: Create RLS Helper Functions (in public schema)
-- ============================================================================

CREATE OR REPLACE FUNCTION public.get_user_role()
RETURNS TEXT AS $$
  SELECT COALESCE(
    (current_setting('request.jwt.claims', true)::jsonb ->> 'role')::TEXT,
    'customer'
  );
$$ LANGUAGE SQL STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION public.get_user_brand_id()
RETURNS UUID AS $$
  SELECT COALESCE(
    (current_setting('request.jwt.claims', true)::jsonb ->> 'brand_id')::UUID,
    NULL
  );
$$ LANGUAGE SQL STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION public.is_super_admin()
RETURNS BOOLEAN AS $$
  SELECT public.get_user_role() = 'super_admin';
$$ LANGUAGE SQL STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION public.is_brand_admin()
RETURNS BOOLEAN AS $$
  SELECT public.get_user_role() IN ('brand_admin', 'super_admin');
$$ LANGUAGE SQL STABLE SECURITY DEFINER;

-- ============================================================================
-- STEP 7: Create RLS Policies
-- ============================================================================

-- Brands: Anyone can view brands (for brand selector)
CREATE POLICY "Anyone can view brands"
ON brands FOR SELECT
TO authenticated
USING (TRUE);

-- App Configs: Anyone can read app configs (for white-label apps)
CREATE POLICY "Anyone can view app configs"
ON app_configs FOR SELECT
TO authenticated
USING (TRUE);

-- Also allow anonymous access for mobile apps
CREATE POLICY "Anon can view app configs"
ON app_configs FOR SELECT
TO anon
USING (TRUE);

-- Brand admins can manage their app config
CREATE POLICY "Brand admins can manage their app config"
ON app_configs FOR ALL
TO authenticated
USING (brand_id = public.get_user_brand_id());

-- Brand admins can view their app builds
CREATE POLICY "Brand admins can view their app builds"
ON app_builds FOR SELECT
TO authenticated
USING (
  app_config_id IN (
    SELECT id FROM app_configs WHERE brand_id = public.get_user_brand_id()
  )
);

-- Stores: Customers can view active stores
CREATE POLICY "Customers can view active stores"
ON stores FOR SELECT
TO authenticated
USING (status = 'active' AND accepting_orders = TRUE);

-- Also allow anonymous access for browsing
CREATE POLICY "Anon can view active stores"
ON stores FOR SELECT
TO anon
USING (status = 'active' AND accepting_orders = TRUE);

-- ============================================================================
-- STEP 8: Create App Builder Functions
-- ============================================================================

CREATE OR REPLACE FUNCTION get_app_config(config_id UUID)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    result JSON;
BEGIN
    SELECT json_build_object(
        'id', ac.id,
        'brand_id', ac.brand_id,
        'app_name', ac.app_name,
        'logo_url', ac.logo_url,
        'primary_color', ac.primary_color,
        'feature_toggles', ac.feature_toggles,
        'build_version', ac.build_version
    )
    INTO result
    FROM app_configs ac
    WHERE ac.id = config_id;

    RETURN result;
END;
$$;

CREATE OR REPLACE FUNCTION trigger_app_build(
    p_app_config_id UUID,
    p_github_token TEXT DEFAULT NULL
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_brand_id UUID;
    v_app_name TEXT;
    result JSON;
BEGIN
    SELECT brand_id, app_name
    INTO v_brand_id, v_app_name
    FROM app_configs
    WHERE id = p_app_config_id;

    IF v_brand_id IS NULL THEN
        RAISE EXCEPTION 'App configuration not found';
    END IF;

    result := json_build_object(
        'event_type', 'build_brand_app',
        'client_payload', json_build_object(
            'brand_id', v_brand_id,
            'app_config_id', p_app_config_id,
            'app_name', v_app_name
        )
    );

    RETURN result;
END;
$$;

CREATE OR REPLACE FUNCTION get_build_status(p_app_config_id UUID)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    result JSON;
BEGIN
    SELECT json_agg(
        json_build_object(
            'id', ab.id,
            'platform', ab.platform,
            'status', ab.status,
            'build_number', ab.build_number,
            'download_url', ab.download_url,
            'error_message', ab.error_message,
            'started_at', ab.started_at,
            'completed_at', ab.completed_at
        )
        ORDER BY ab.started_at DESC
    )
    INTO result
    FROM app_builds ab
    WHERE ab.app_config_id = p_app_config_id;

    RETURN COALESCE(result, '[]'::json);
END;
$$;

-- ============================================================================
-- STEP 9: Insert Seed Data
-- ============================================================================

-- Default brand: Jumun
INSERT INTO brands (id, name, slug, created_at, updated_at)
VALUES (
    '00000000-0000-0000-0000-000000000001',
    'Jumun',
    'jumun',
    NOW(),
    NOW()
)
ON CONFLICT (slug) DO NOTHING;

-- Default subscription for Jumun
INSERT INTO subscriptions (brand_id, plan, status, expires_at)
VALUES (
    '00000000-0000-0000-0000-000000000001',
    'enterprise',
    'active',
    NOW() + INTERVAL '1 year'
)
ON CONFLICT (brand_id) DO NOTHING;

-- Default app config for Jumun
INSERT INTO app_configs (
    brand_id,
    app_name,
    primary_color,
    feature_toggles,
    created_at,
    updated_at
)
VALUES (
    '00000000-0000-0000-0000-000000000001',
    'Jumun',
    '#6366F1',
    '{"loyalty": true, "promotions": true, "qr_ordering": true}'::jsonb,
    NOW(),
    NOW()
)
ON CONFLICT (brand_id) DO NOTHING;

-- Sample brands for testing
INSERT INTO brands (name, slug)
VALUES
    ('스타벅스', 'starbucks'),
    ('투썸플레이스', 'twosome'),
    ('메가커피', 'mega-coffee')
ON CONFLICT (slug) DO NOTHING;

-- ============================================================================
-- DONE! Database schema is ready
-- ============================================================================

-- Verify setup
SELECT
    'Brands' as table_name,
    count(*) as row_count
FROM brands
UNION ALL
SELECT 'App Configs', count(*) FROM app_configs
UNION ALL
SELECT 'Subscriptions', count(*) FROM subscriptions;
