-- Loyalty System Configuration
-- Migration: 20251015000001_loyalty_system_configuration
--
-- This migration adds:
-- 1. Loyalty program settings to app_configs.feature_toggles (admin-configurable)
-- 2. Auto-point earning trigger on order completion
-- 3. Default loyalty settings for existing brands

-- ============================================================================
-- ADD DEFAULT LOYALTY SETTINGS TO EXISTING APP_CONFIGS
-- ============================================================================

-- Update existing app_configs with default loyalty settings
UPDATE app_configs
SET feature_toggles = jsonb_set(
    feature_toggles,
    '{loyalty}',
    '{
        "enabled": true,
        "points_earn_rate": 5,
        "points_redemption_enabled": true,
        "points_to_currency_ratio": 100,
        "stamps_enabled": true,
        "stamps_per_order": 1,
        "stamps_for_reward": 10,
        "reward_coupon_type": "free_item",
        "reward_coupon_value": 5000
    }'::jsonb
)
WHERE NOT (feature_toggles ? 'loyalty');

COMMENT ON COLUMN app_configs.feature_toggles IS 'Enabled/disabled features (JSONB)
Example loyalty settings:
{
  "loyalty": {
    "enabled": true,
    "points_earn_rate": 5,                    -- Earn 5% of order total as points
    "points_redemption_enabled": true,         -- Allow using points at checkout
    "points_to_currency_ratio": 100,           -- 100 points = ₩1 currency
    "stamps_enabled": true,                    -- Enable stamp card feature
    "stamps_per_order": 1,                     -- Stamps earned per completed order
    "stamps_for_reward": 10,                   -- Stamps needed for reward coupon
    "reward_coupon_type": "free_item",         -- Type of reward coupon
    "reward_coupon_value": 5000                -- Value of reward coupon (₩5,000)
  }
}';

-- ============================================================================
-- CREATE STAMP_CARDS TABLE
-- ============================================================================

CREATE TABLE stamp_cards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
    stamps_earned INTEGER NOT NULL DEFAULT 0,
    stamps_used INTEGER NOT NULL DEFAULT 0,
    current_stamps INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT stamp_cards_stamps_non_negative CHECK (current_stamps >= 0),
    CONSTRAINT stamp_cards_unique_customer_brand UNIQUE (customer_id, brand_id)
);

CREATE INDEX idx_stamp_cards_customer_id ON stamp_cards(customer_id);
CREATE INDEX idx_stamp_cards_brand_id ON stamp_cards(brand_id);

COMMENT ON TABLE stamp_cards IS 'Customer stamp card tracking per brand';
COMMENT ON COLUMN stamp_cards.stamps_earned IS 'Total stamps ever earned';
COMMENT ON COLUMN stamp_cards.stamps_used IS 'Total stamps used for rewards';
COMMENT ON COLUMN stamp_cards.current_stamps IS 'Current available stamps (earned - used)';

ALTER TABLE stamp_cards ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- FUNCTION: AUTO-AWARD POINTS ON ORDER COMPLETION
-- ============================================================================

CREATE OR REPLACE FUNCTION award_loyalty_points()
RETURNS TRIGGER AS $$
DECLARE
    v_brand_id UUID;
    v_loyalty_config JSONB;
    v_points_rate DECIMAL;
    v_points_earned INTEGER;
    v_current_balance INTEGER;
BEGIN
    -- Only trigger when order status changes to 'completed'
    IF (TG_OP = 'UPDATE' AND NEW.status = 'completed' AND OLD.status != 'completed') THEN

        -- Get brand_id from store
        SELECT brand_id INTO v_brand_id
        FROM stores
        WHERE id = NEW.store_id;

        -- Get loyalty configuration for this brand
        SELECT feature_toggles->'loyalty' INTO v_loyalty_config
        FROM app_configs
        WHERE brand_id = v_brand_id;

        -- Check if loyalty is enabled
        IF v_loyalty_config IS NOT NULL AND (v_loyalty_config->>'enabled')::boolean = true THEN

            -- Calculate points: order_total * points_earn_rate / 100
            v_points_rate := (v_loyalty_config->>'points_earn_rate')::decimal;
            v_points_earned := FLOOR(NEW.total_amount * v_points_rate / 100);

            -- Get customer's current balance (0 if no transactions yet)
            SELECT COALESCE(MAX(balance), 0) INTO v_current_balance
            FROM loyalty_transactions
            WHERE customer_id = NEW.customer_id;

            -- Insert loyalty transaction
            INSERT INTO loyalty_transactions (
                customer_id,
                order_id,
                points_earned,
                points_spent,
                balance
            ) VALUES (
                NEW.customer_id,
                NEW.id,
                v_points_earned,
                0,
                v_current_balance + v_points_earned
            );

            -- Update customer's loyalty_points
            UPDATE customers
            SET loyalty_points = v_current_balance + v_points_earned,
                updated_at = NOW()
            WHERE id = NEW.customer_id;

        END IF;

    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION award_loyalty_points IS 'Auto-award points when order is completed based on brand loyalty config';

-- ============================================================================
-- FUNCTION: AUTO-AWARD STAMPS ON ORDER COMPLETION
-- ============================================================================

CREATE OR REPLACE FUNCTION award_stamps()
RETURNS TRIGGER AS $$
DECLARE
    v_brand_id UUID;
    v_loyalty_config JSONB;
    v_stamps_per_order INTEGER;
    v_stamps_for_reward INTEGER;
    v_current_stamps INTEGER;
    v_reward_coupon_type TEXT;
    v_reward_coupon_value DECIMAL;
    v_coupon_code TEXT;
BEGIN
    -- Only trigger when order status changes to 'completed'
    IF (TG_OP = 'UPDATE' AND NEW.status = 'completed' AND OLD.status != 'completed') THEN

        -- Get brand_id from store
        SELECT brand_id INTO v_brand_id
        FROM stores
        WHERE id = NEW.store_id;

        -- Get loyalty configuration for this brand
        SELECT feature_toggles->'loyalty' INTO v_loyalty_config
        FROM app_configs
        WHERE brand_id = v_brand_id;

        -- Check if stamps are enabled
        IF v_loyalty_config IS NOT NULL
           AND (v_loyalty_config->>'enabled')::boolean = true
           AND (v_loyalty_config->>'stamps_enabled')::boolean = true THEN

            v_stamps_per_order := (v_loyalty_config->>'stamps_per_order')::integer;
            v_stamps_for_reward := (v_loyalty_config->>'stamps_for_reward')::integer;

            -- Get or create stamp card
            INSERT INTO stamp_cards (customer_id, brand_id, stamps_earned, stamps_used, current_stamps)
            VALUES (NEW.customer_id, v_brand_id, 0, 0, 0)
            ON CONFLICT (customer_id, brand_id) DO NOTHING;

            -- Update stamp card
            UPDATE stamp_cards
            SET stamps_earned = stamps_earned + v_stamps_per_order,
                current_stamps = current_stamps + v_stamps_per_order,
                updated_at = NOW()
            WHERE customer_id = NEW.customer_id AND brand_id = v_brand_id
            RETURNING current_stamps INTO v_current_stamps;

            -- Check if customer earned a reward
            IF v_current_stamps >= v_stamps_for_reward THEN

                v_reward_coupon_type := v_loyalty_config->>'reward_coupon_type';
                v_reward_coupon_value := (v_loyalty_config->>'reward_coupon_value')::decimal;

                -- Generate unique coupon code
                v_coupon_code := 'STAMP-' || substring(gen_random_uuid()::text, 1, 8);

                -- Create reward coupon
                INSERT INTO coupons (
                    brand_id,
                    customer_id,
                    code,
                    type,
                    value,
                    min_order_value,
                    expires_at
                ) VALUES (
                    v_brand_id,
                    NEW.customer_id,
                    v_coupon_code,
                    v_reward_coupon_type::coupon_type,
                    v_reward_coupon_value,
                    NULL,
                    NOW() + INTERVAL '90 days'
                );

                -- Deduct used stamps
                UPDATE stamp_cards
                SET stamps_used = stamps_used + v_stamps_for_reward,
                    current_stamps = current_stamps - v_stamps_for_reward,
                    updated_at = NOW()
                WHERE customer_id = NEW.customer_id AND brand_id = v_brand_id;

            END IF;

        END IF;

    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION award_stamps IS 'Auto-award stamps and issue reward coupon when threshold reached';

-- ============================================================================
-- CREATE TRIGGERS
-- ============================================================================

-- Drop existing trigger first (from earlier migration)
DROP TRIGGER IF EXISTS trigger_award_loyalty_points ON orders;

-- Recreate trigger for auto-awarding points (now with admin-configurable rates)
CREATE TRIGGER trigger_award_loyalty_points
    AFTER UPDATE ON orders
    FOR EACH ROW
    EXECUTE FUNCTION award_loyalty_points();

-- Trigger for auto-awarding stamps
CREATE TRIGGER trigger_award_stamps
    AFTER UPDATE ON orders
    FOR EACH ROW
    EXECUTE FUNCTION award_stamps();

COMMENT ON TRIGGER trigger_award_loyalty_points ON orders IS 'Auto-award loyalty points on order completion (admin-configurable rates)';
COMMENT ON TRIGGER trigger_award_stamps ON orders IS 'Auto-award stamps and issue reward coupons';
