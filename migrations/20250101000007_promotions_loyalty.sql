-- Promotions & Loyalty: promotions, coupons, loyalty_transactions
-- Migration: 20250101000007_promotions_loyalty

-- ============================================================================
-- ENUMS
-- ============================================================================

-- Promotion type
CREATE TYPE promotion_type AS ENUM (
    'percentage_discount',  -- e.g., 20% off
    'fixed_discount',       -- e.g., $5 off
    'buy_x_get_y',          -- e.g., Buy 2 get 1 free
    'min_order_discount'    -- e.g., $10 off orders > $50
);

-- Coupon type
CREATE TYPE coupon_type AS ENUM (
    'percentage',
    'fixed_amount',
    'free_item'
);

-- ============================================================================
-- PROMOTIONS TABLE
-- ============================================================================

CREATE TABLE promotions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,

    -- Targeting
    store_ids UUID[] DEFAULT '{}',  -- Empty array = all stores

    -- Promotion details
    name TEXT NOT NULL,
    description TEXT,
    type promotion_type NOT NULL,
    discount_value DECIMAL(10,2),  -- Percentage or fixed amount

    -- Conditions (JSONB)
    -- Example: {"min_order_value": 50, "applicable_items": ["uuid1", "uuid2"]}
    conditions JSONB NOT NULL DEFAULT '{}',

    -- Validity
    valid_from TIMESTAMPTZ NOT NULL,
    valid_to TIMESTAMPTZ NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT promotions_name_not_empty CHECK (length(trim(name)) > 0),
    CONSTRAINT promotions_valid_dates CHECK (valid_from < valid_to)
);

CREATE INDEX idx_promotions_brand_id ON promotions(brand_id);
CREATE INDEX idx_promotions_active ON promotions(active, valid_from, valid_to);
CREATE INDEX idx_promotions_store_ids ON promotions USING GIN(store_ids);

COMMENT ON TABLE promotions IS 'Brand promotions and campaigns';
COMMENT ON COLUMN promotions.store_ids IS 'Empty array = apply to all stores';
COMMENT ON COLUMN promotions.conditions IS 'Promotion conditions (JSONB)';

-- ============================================================================
-- COUPONS TABLE
-- ============================================================================

CREATE TABLE coupons (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
    customer_id UUID REFERENCES customers(id) ON DELETE CASCADE,  -- NULL = public coupon
    code TEXT NOT NULL,
    type coupon_type NOT NULL,
    value DECIMAL(10,2) NOT NULL,
    min_order_value DECIMAL(10,2),
    expires_at TIMESTAMPTZ NOT NULL,
    used_at TIMESTAMPTZ,
    order_id UUID REFERENCES orders(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT coupons_code_not_empty CHECK (length(trim(code)) > 0),
    CONSTRAINT coupons_value_positive CHECK (value > 0),
    CONSTRAINT coupons_min_order_non_negative CHECK (min_order_value IS NULL OR min_order_value >= 0),
    CONSTRAINT coupons_used_has_order CHECK (used_at IS NULL OR order_id IS NOT NULL)
);

CREATE INDEX idx_coupons_brand_id ON coupons(brand_id);
CREATE INDEX idx_coupons_customer_id ON coupons(customer_id);
CREATE INDEX idx_coupons_code ON coupons(code);
CREATE INDEX idx_coupons_expires_at ON coupons(expires_at) WHERE used_at IS NULL;

COMMENT ON TABLE coupons IS 'Discount coupons';
COMMENT ON COLUMN coupons.customer_id IS 'NULL for public coupons, UUID for customer-specific';

-- ============================================================================
-- LOYALTY_TRANSACTIONS TABLE
-- ============================================================================

CREATE TABLE loyalty_transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    order_id UUID REFERENCES orders(id) ON DELETE SET NULL,
    points_earned INTEGER NOT NULL DEFAULT 0,
    points_spent INTEGER NOT NULL DEFAULT 0,
    balance INTEGER NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT loyalty_transactions_balance_non_negative CHECK (balance >= 0)
);

CREATE INDEX idx_loyalty_transactions_customer_id ON loyalty_transactions(customer_id, created_at DESC);
CREATE INDEX idx_loyalty_transactions_order_id ON loyalty_transactions(order_id);

COMMENT ON TABLE loyalty_transactions IS 'Loyalty points transaction history';
COMMENT ON COLUMN loyalty_transactions.balance IS 'Balance after this transaction';

-- ============================================================================
-- ENABLE ROW LEVEL SECURITY
-- ============================================================================

ALTER TABLE promotions ENABLE ROW LEVEL SECURITY;
ALTER TABLE coupons ENABLE ROW LEVEL SECURITY;
ALTER TABLE loyalty_transactions ENABLE ROW LEVEL SECURITY;
