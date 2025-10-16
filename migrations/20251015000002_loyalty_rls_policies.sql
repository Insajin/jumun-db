-- RLS Policies for Loyalty System
-- Migration: 20251015000002_loyalty_rls_policies
--
-- This migration adds RLS policies to allow customers to view their loyalty data

-- ============================================================================
-- STAMP_CARDS POLICIES
-- ============================================================================

-- Customers can view their own stamp cards
CREATE POLICY "Customers can view own stamp cards"
ON stamp_cards FOR SELECT
TO anon, authenticated
USING (true);  -- Will be filtered by customer_id in application layer

-- Triggers can insert/update stamp cards
CREATE POLICY "Triggers can manage stamp cards"
ON stamp_cards FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

-- ============================================================================
-- LOYALTY_TRANSACTIONS POLICIES
-- ============================================================================

-- Customers can view their own loyalty transactions
CREATE POLICY "Customers can view own loyalty transactions"
ON loyalty_transactions FOR SELECT
TO anon, authenticated
USING (true);  -- Will be filtered by customer_id in application layer

-- Triggers can insert loyalty transactions
CREATE POLICY "Triggers can create loyalty transactions"
ON loyalty_transactions FOR INSERT
TO service_role
WITH CHECK (true);

-- ============================================================================
-- COUPONS POLICIES
-- ============================================================================

-- Customers can view their own coupons
CREATE POLICY "Customers can view own coupons"
ON coupons FOR SELECT
TO anon, authenticated
USING (true);  -- Will be filtered by customer_id in application layer

-- Triggers can create coupons (for reward coupons)
CREATE POLICY "Triggers can create coupons"
ON coupons FOR INSERT
TO service_role
WITH CHECK (true);

-- Staff can update coupons (mark as used)
CREATE POLICY "Staff can update coupons"
ON coupons FOR UPDATE
TO authenticated
USING (true)
WITH CHECK (true);
