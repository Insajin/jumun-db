-- Core tables: brands, subscriptions, stores, staff, customers
-- Migration: 20250101000002_core_tables

-- ============================================================================
-- ENUMS
-- ============================================================================

-- Subscription plans
CREATE TYPE subscription_plan AS ENUM ('trial', 'basic', 'professional', 'enterprise');

-- Subscription status
CREATE TYPE subscription_status AS ENUM ('active', 'expired', 'cancelled', 'grace_period');

-- Store status
CREATE TYPE store_status AS ENUM ('active', 'paused', 'offline', 'inactive');

-- Staff roles
CREATE TYPE staff_role AS ENUM ('store_staff', 'store_manager', 'brand_admin', 'super_admin');

-- ============================================================================
-- BRANDS TABLE
-- ============================================================================

CREATE TABLE brands (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT brands_name_not_empty CHECK (length(trim(name)) > 0),
    CONSTRAINT brands_slug_format CHECK (slug ~ '^[a-z0-9-]+$')
);

CREATE INDEX idx_brands_slug ON brands(slug);

COMMENT ON TABLE brands IS 'Franchise brands (tenants)';
COMMENT ON COLUMN brands.slug IS 'URL-safe brand identifier';

-- ============================================================================
-- SUBSCRIPTIONS TABLE
-- ============================================================================

CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
    plan subscription_plan NOT NULL DEFAULT 'trial',
    status subscription_status NOT NULL DEFAULT 'active',
    trial_ends_at TIMESTAMPTZ,
    expires_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT subscriptions_unique_brand UNIQUE(brand_id),
    CONSTRAINT subscriptions_trial_before_expiry CHECK (trial_ends_at IS NULL OR trial_ends_at < expires_at)
);

CREATE INDEX idx_subscriptions_brand_id ON subscriptions(brand_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);
CREATE INDEX idx_subscriptions_expires_at ON subscriptions(expires_at) WHERE status = 'active';

COMMENT ON TABLE subscriptions IS 'SaaS subscription plans per brand';
COMMENT ON COLUMN subscriptions.trial_ends_at IS 'End of trial period';
COMMENT ON COLUMN subscriptions.expires_at IS 'Subscription expiration date';

-- ============================================================================
-- STORES TABLE
-- ============================================================================

CREATE TABLE stores (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    slug TEXT NOT NULL,
    address TEXT,
    lat DOUBLE PRECISION,
    lng DOUBLE PRECISION,
    timezone TEXT NOT NULL DEFAULT 'Asia/Seoul',
    phone TEXT,

    -- Store status and connectivity
    status store_status NOT NULL DEFAULT 'active',
    accepting_orders BOOLEAN NOT NULL DEFAULT TRUE,
    last_heartbeat_at TIMESTAMPTZ,

    -- Operating hours (JSONB)
    -- Example: {"monday": {"open": "09:00", "close": "21:00"}, "tuesday": {...}}
    operating_hours JSONB NOT NULL DEFAULT '{}',

    -- Special hours (holidays, events)
    -- Example: [{"date": "2025-01-01", "open": "10:00", "close": "18:00", "note": "New Year"}]
    special_hours JSONB NOT NULL DEFAULT '[]',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT stores_name_not_empty CHECK (length(trim(name)) > 0),
    CONSTRAINT stores_unique_brand_slug UNIQUE(brand_id, slug),
    CONSTRAINT stores_lat_range CHECK (lat IS NULL OR (lat >= -90 AND lat <= 90)),
    CONSTRAINT stores_lng_range CHECK (lng IS NULL OR (lng >= -180 AND lng <= 180))
);

CREATE INDEX idx_stores_brand_id ON stores(brand_id);
CREATE INDEX idx_stores_status ON stores(status);
CREATE INDEX idx_stores_location ON stores USING GIST(extensions.ST_MakePoint(lng, lat)) WHERE lat IS NOT NULL AND lng IS NOT NULL;
CREATE INDEX idx_stores_last_heartbeat ON stores(last_heartbeat_at) WHERE status != 'offline';

COMMENT ON TABLE stores IS 'Individual store locations';
COMMENT ON COLUMN stores.operating_hours IS 'Weekly operating hours (JSONB)';
COMMENT ON COLUMN stores.special_hours IS 'Holiday/event hours (JSONB array)';
COMMENT ON COLUMN stores.last_heartbeat_at IS 'Last ping from store dashboard (for connectivity monitoring)';

-- ============================================================================
-- STAFF TABLE
-- ============================================================================

CREATE TABLE staff (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    role staff_role NOT NULL DEFAULT 'store_staff',

    -- Additional permissions (JSONB)
    -- Example: {"can_manage_inventory": true, "can_refund": false}
    permissions JSONB NOT NULL DEFAULT '{}',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT staff_unique_user_store UNIQUE(user_id, store_id)
);

CREATE INDEX idx_staff_store_id ON staff(store_id);
CREATE INDEX idx_staff_user_id ON staff(user_id);
CREATE INDEX idx_staff_role ON staff(role);

COMMENT ON TABLE staff IS 'Store employees with roles and permissions';
COMMENT ON COLUMN staff.user_id IS 'Reference to auth.users (Supabase Auth)';
COMMENT ON COLUMN staff.permissions IS 'Fine-grained permissions (JSONB)';

-- ============================================================================
-- CUSTOMERS TABLE (extends auth.users)
-- ============================================================================

CREATE TABLE customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE,
    phone TEXT,
    phone_verified_at TIMESTAMPTZ,

    -- Loyalty points
    loyalty_points INTEGER NOT NULL DEFAULT 0,

    -- Preferences (JSONB)
    -- Example: {"notifications": {"push": true, "sms": true}, "language": "ko"}
    preferences JSONB NOT NULL DEFAULT '{}',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT customers_loyalty_points_non_negative CHECK (loyalty_points >= 0)
);

CREATE INDEX idx_customers_user_id ON customers(user_id);
CREATE INDEX idx_customers_phone ON customers(phone) WHERE phone IS NOT NULL;

COMMENT ON TABLE customers IS 'Customer profiles (extends Supabase Auth users)';
COMMENT ON COLUMN customers.user_id IS 'Reference to auth.users (Supabase Auth)';
COMMENT ON COLUMN customers.preferences IS 'Notification preferences, language, etc. (JSONB)';

-- ============================================================================
-- ENABLE ROW LEVEL SECURITY
-- ============================================================================

ALTER TABLE brands ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE staff ENABLE ROW LEVEL SECURITY;
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;

-- Note: RLS policies will be defined in a separate migration (00009_rls_policies.sql)
