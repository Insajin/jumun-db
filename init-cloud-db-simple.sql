-- ============================================================================
-- Jumun - Supabase Cloud Database (Simplified Version)
-- ============================================================================
-- This version avoids auth schema permissions issues
-- Suitable for Supabase Cloud SQL Editor
-- ============================================================================

-- ============================================================================
-- STEP 1: Enable Extensions
-- ============================================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================================
-- STEP 2: Create Enums
-- ============================================================================

DO $$ BEGIN
    CREATE TYPE subscription_plan AS ENUM ('trial', 'basic', 'professional', 'enterprise');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE subscription_status AS ENUM ('active', 'expired', 'cancelled', 'grace_period');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE store_status AS ENUM ('active', 'paused', 'offline', 'inactive');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE staff_role AS ENUM ('store_staff', 'store_manager', 'brand_admin', 'super_admin');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE build_platform AS ENUM ('ios', 'android');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE build_status AS ENUM ('in_progress', 'completed', 'failed');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- ============================================================================
-- STEP 3: Create Tables
-- ============================================================================

-- Brands Table
CREATE TABLE IF NOT EXISTS brands (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    logo_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Subscriptions Table
CREATE TABLE IF NOT EXISTS subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
    plan subscription_plan NOT NULL DEFAULT 'trial',
    status subscription_status NOT NULL DEFAULT 'active',
    trial_ends_at TIMESTAMPTZ,
    expires_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(brand_id)
);

-- Stores Table
CREATE TABLE IF NOT EXISTS stores (
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
    UNIQUE(brand_id, slug)
);

-- App Configurations Table (White-Label)
CREATE TABLE IF NOT EXISTS app_configs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
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
    UNIQUE(brand_id)
);

-- App Builds Table
CREATE TABLE IF NOT EXISTS app_builds (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    app_config_id UUID NOT NULL REFERENCES app_configs(id) ON DELETE CASCADE,
    platform build_platform NOT NULL,
    status build_status NOT NULL DEFAULT 'in_progress',
    build_number TEXT,
    download_url TEXT,
    error_message TEXT,
    started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMPTZ
);

-- ============================================================================
-- STEP 4: Create Indexes
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_brands_slug ON brands(slug);
CREATE INDEX IF NOT EXISTS idx_subscriptions_brand_id ON subscriptions(brand_id);
CREATE INDEX IF NOT EXISTS idx_stores_brand_id ON stores(brand_id);
CREATE INDEX IF NOT EXISTS idx_stores_status ON stores(status);
CREATE INDEX IF NOT EXISTS idx_app_configs_brand_id ON app_configs(brand_id);
CREATE INDEX IF NOT EXISTS idx_app_builds_app_config_id ON app_builds(app_config_id);

-- ============================================================================
-- STEP 5: Enable RLS (with public read access)
-- ============================================================================

ALTER TABLE brands ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE app_configs ENABLE ROW LEVEL SECURITY;
ALTER TABLE app_builds ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if any
DROP POLICY IF EXISTS "Public read access for brands" ON brands;
DROP POLICY IF EXISTS "Public read access for app_configs" ON app_configs;
DROP POLICY IF EXISTS "Public read access for stores" ON stores;

-- Allow public read access (needed for mobile apps)
CREATE POLICY "Public read access for brands"
ON brands FOR SELECT
TO public
USING (true);

CREATE POLICY "Public read access for app_configs"
ON app_configs FOR SELECT
TO public
USING (true);

CREATE POLICY "Public read access for stores"
ON stores FOR SELECT
TO public
USING (status = 'active');

-- ============================================================================
-- STEP 6: Insert Seed Data
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
ON CONFLICT (slug) DO UPDATE
SET name = EXCLUDED.name, updated_at = NOW();

-- Default subscription
INSERT INTO subscriptions (brand_id, plan, status, expires_at)
VALUES (
    '00000000-0000-0000-0000-000000000001',
    'enterprise',
    'active',
    NOW() + INTERVAL '1 year'
)
ON CONFLICT (brand_id) DO UPDATE
SET plan = EXCLUDED.plan, status = EXCLUDED.status, expires_at = EXCLUDED.expires_at;

-- Default app config
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
ON CONFLICT (brand_id) DO UPDATE
SET
    app_name = EXCLUDED.app_name,
    primary_color = EXCLUDED.primary_color,
    feature_toggles = EXCLUDED.feature_toggles,
    updated_at = NOW();

-- Test brands
INSERT INTO brands (name, slug) VALUES
    ('스타벅스', 'starbucks'),
    ('투썸플레이스', 'twosome'),
    ('메가커피', 'mega-coffee')
ON CONFLICT (slug) DO NOTHING;

-- App configs for test brands
INSERT INTO app_configs (brand_id, app_name, primary_color, feature_toggles)
SELECT
    b.id,
    b.name,
    CASE b.slug
        WHEN 'starbucks' THEN '#00704A'
        WHEN 'twosome' THEN '#E94B3C'
        WHEN 'mega-coffee' THEN '#FFB81C'
    END,
    '{"loyalty": true, "promotions": true, "qr_ordering": true}'::jsonb
FROM brands b
WHERE b.slug IN ('starbucks', 'twosome', 'mega-coffee')
ON CONFLICT (brand_id) DO NOTHING;

-- ============================================================================
-- STEP 7: Verification Query
-- ============================================================================

SELECT
    'Brands' as table_name,
    count(*) as row_count
FROM brands
UNION ALL
SELECT 'App Configs', count(*) FROM app_configs
UNION ALL
SELECT 'Subscriptions', count(*) FROM subscriptions
ORDER BY table_name;

-- Success message
SELECT
    '✅ Database setup complete!' as status,
    (SELECT count(*) FROM brands) as brands_count,
    (SELECT count(*) FROM app_configs) as app_configs_count;
