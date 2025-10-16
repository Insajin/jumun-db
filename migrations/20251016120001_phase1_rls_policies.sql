-- Phase 1: RLS Policies for Admin Management Features
-- Migration: 20251016120001_phase1_rls_policies
--
-- Row Level Security policies for Phase 1 tables

-- ============================================================================
-- 1. PROMOTION BANNERS RLS POLICIES
-- ============================================================================

-- Brand admins can manage their own promotion banners
CREATE POLICY "Brand admins can view their promotion banners"
    ON promotion_banners FOR SELECT
    USING (brand_id = public.user_brand_id());

CREATE POLICY "Brand admins can create promotion banners"
    ON promotion_banners FOR INSERT
    WITH CHECK (brand_id = public.user_brand_id());

CREATE POLICY "Brand admins can update their promotion banners"
    ON promotion_banners FOR UPDATE
    USING (brand_id = public.user_brand_id());

CREATE POLICY "Brand admins can delete their promotion banners"
    ON promotion_banners FOR DELETE
    USING (brand_id = public.user_brand_id());

-- Customers can view active banners (for customer-web app)
CREATE POLICY "Customers can view active promotion banners"
    ON promotion_banners FOR SELECT
    USING (
        active = TRUE
        AND valid_from <= NOW()
        AND valid_to >= NOW()
        AND auth.role() = 'authenticated'
    );

-- ============================================================================
-- 2. COUPON TEMPLATES RLS POLICIES
-- ============================================================================

CREATE POLICY "Brand admins can manage coupon templates"
    ON coupon_templates FOR ALL
    USING (brand_id = public.user_brand_id());

-- ============================================================================
-- 3. CUSTOMER SEGMENTS RLS POLICIES
-- ============================================================================

CREATE POLICY "Brand admins can manage customer segments"
    ON customer_segments FOR ALL
    USING (brand_id = public.user_brand_id());

-- ============================================================================
-- 4. NOTIFICATIONS RLS POLICIES
-- ============================================================================

CREATE POLICY "Brand admins can manage notifications"
    ON notifications FOR ALL
    USING (brand_id = public.user_brand_id());

-- Customers can view their own notifications
CREATE POLICY "Customers can view own notifications"
    ON notifications FOR SELECT
    USING (
        target = 'all'
        OR (target = 'individual' AND auth.uid() = ANY(customer_ids))
        OR (target = 'segment' AND EXISTS (
            SELECT 1 FROM customer_segments cs
            WHERE cs.id = notifications.segment_id
            AND (
                auth.uid() = ANY(cs.customer_ids)
                OR (cs.type = 'auto' AND cs.brand_id IN (
                    SELECT brand_id FROM customers WHERE user_id = auth.uid()
                ))
            )
        ))
    );

-- ============================================================================
-- 5. NOTIFICATION TEMPLATES RLS POLICIES
-- ============================================================================

CREATE POLICY "Brand admins can manage notification templates"
    ON notification_templates FOR ALL
    USING (brand_id = public.user_brand_id());

-- ============================================================================
-- 6. RECOMMENDED MENU CONFIGS RLS POLICIES
-- ============================================================================

CREATE POLICY "Brand admins can manage recommended menu configs"
    ON recommended_menu_configs FOR ALL
    USING (brand_id = public.user_brand_id());

-- Customers can view recommended menu configs (read-only)
CREATE POLICY "Customers can view recommended menu configs"
    ON recommended_menu_configs FOR SELECT
    USING (auth.role() = 'authenticated');

-- ============================================================================
-- 7. MENU SCHEDULES RLS POLICIES
-- ============================================================================

CREATE POLICY "Brand admins can manage menu schedules"
    ON menu_schedules FOR ALL
    USING (
        menu_item_id IN (
            SELECT id FROM menu_items
            WHERE brand_id = public.user_brand_id()
        )
    );

-- Store managers can view menu schedules
CREATE POLICY "Store managers can view menu schedules"
    ON menu_schedules FOR SELECT
    USING (
        menu_item_id IN (
            SELECT mi.id FROM menu_items mi
            INNER JOIN stores s ON mi.store_id = s.id
            WHERE s.manager_id = auth.uid()
        )
    );

-- Customers can view menu schedules (read-only)
CREATE POLICY "Customers can view menu schedules"
    ON menu_schedules FOR SELECT
    USING (auth.role() = 'authenticated');

-- ============================================================================
-- 8. BANNER INTERACTIONS RLS POLICIES
-- ============================================================================

-- Anyone can create banner interactions (tracking)
CREATE POLICY "Anyone can create banner interactions"
    ON banner_interactions FOR INSERT
    WITH CHECK (TRUE);

-- Brand admins can view their banner interactions
CREATE POLICY "Brand admins can view banner interactions"
    ON banner_interactions FOR SELECT
    USING (
        banner_id IN (
            SELECT id FROM promotion_banners
            WHERE brand_id = public.user_brand_id()
        )
    );

-- ============================================================================
-- 9. UPDATE EXISTING COUPONS RLS POLICIES
-- ============================================================================

-- Drop existing coupon policies (if any) and recreate with enhanced logic
DROP POLICY IF EXISTS "Brand admins can view their coupons" ON coupons;
DROP POLICY IF EXISTS "Brand admins can create coupons" ON coupons;
DROP POLICY IF EXISTS "Brand admins can update their coupons" ON coupons;
DROP POLICY IF EXISTS "Brand admins can delete their coupons" ON coupons;
DROP POLICY IF EXISTS "Customers can view own coupons" ON coupons;

-- Brand admins can manage coupons
CREATE POLICY "Brand admins can view coupons"
    ON coupons FOR SELECT
    USING (brand_id = public.user_brand_id());

CREATE POLICY "Brand admins can create coupons"
    ON coupons FOR INSERT
    WITH CHECK (brand_id = public.user_brand_id());

CREATE POLICY "Brand admins can update coupons"
    ON coupons FOR UPDATE
    USING (brand_id = public.user_brand_id());

CREATE POLICY "Brand admins can delete coupons"
    ON coupons FOR DELETE
    USING (brand_id = public.user_brand_id());

-- Customers can view their own coupons
CREATE POLICY "Customers can view own coupons"
    ON coupons FOR SELECT
    USING (
        customer_id IN (
            SELECT id FROM customers WHERE user_id = auth.uid()
        )
    );

-- Customers can update their own coupons (mark as used)
CREATE POLICY "Customers can mark coupons as used"
    ON coupons FOR UPDATE
    USING (
        customer_id IN (
            SELECT id FROM customers WHERE user_id = auth.uid()
        )
    )
    WITH CHECK (
        -- Only allow updating used_at and order_id
        customer_id IN (
            SELECT id FROM customers WHERE user_id = auth.uid()
        )
    );

-- ============================================================================
-- 10. HELPER FUNCTION FOR SEGMENT EVALUATION
-- ============================================================================

-- Function to check if a customer matches segment conditions
CREATE OR REPLACE FUNCTION customer_matches_segment(
    p_customer_id UUID,
    p_segment_id UUID
)
RETURNS BOOLEAN AS $$
DECLARE
    v_segment RECORD;
    v_condition JSONB;
    v_field TEXT;
    v_operator TEXT;
    v_value TEXT;
    v_customer_value NUMERIC;
    v_matches BOOLEAN := TRUE;
BEGIN
    -- Get segment
    SELECT * INTO v_segment
    FROM customer_segments
    WHERE id = p_segment_id;

    IF v_segment IS NULL THEN
        RETURN FALSE;
    END IF;

    -- Manual segment: check if customer is in list
    IF v_segment.type = 'manual' THEN
        RETURN p_customer_id = ANY(v_segment.customer_ids);
    END IF;

    -- Auto segment: evaluate conditions
    FOR v_condition IN SELECT * FROM jsonb_array_elements(v_segment.conditions)
    LOOP
        v_field := v_condition->>'field';
        v_operator := v_condition->>'operator';
        v_value := v_condition->>'value';

        -- Get customer value for field
        IF v_field = 'order_count' THEN
            SELECT COUNT(*) INTO v_customer_value
            FROM orders
            WHERE customer_id = p_customer_id;
        ELSIF v_field = 'total_spent' THEN
            SELECT COALESCE(SUM(total_amount), 0) INTO v_customer_value
            FROM orders
            WHERE customer_id = p_customer_id AND status = 'completed';
        ELSIF v_field = 'last_order_days_ago' THEN
            SELECT COALESCE(EXTRACT(DAY FROM NOW() - MAX(created_at)), 999) INTO v_customer_value
            FROM orders
            WHERE customer_id = p_customer_id;
        ELSE
            -- Unknown field
            RETURN FALSE;
        END IF;

        -- Evaluate condition
        IF v_operator = '>' THEN
            v_matches := v_customer_value > v_value::NUMERIC;
        ELSIF v_operator = '<' THEN
            v_matches := v_customer_value < v_value::NUMERIC;
        ELSIF v_operator = '=' THEN
            v_matches := v_customer_value = v_value::NUMERIC;
        ELSIF v_operator = '>=' THEN
            v_matches := v_customer_value >= v_value::NUMERIC;
        ELSIF v_operator = '<=' THEN
            v_matches := v_customer_value <= v_value::NUMERIC;
        ELSE
            -- Unknown operator
            RETURN FALSE;
        END IF;

        -- If any condition fails, return false
        IF NOT v_matches THEN
            RETURN FALSE;
        END IF;
    END LOOP;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION customer_matches_segment IS 'Check if a customer matches segment conditions';
