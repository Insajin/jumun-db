-- Temporary RLS policies for E2E testing with service_role (2025-10-16)
-- These policies allow service_role to manage brands, stores, and other resources for testing
-- ⚠️ REMOVE THESE POLICIES BEFORE PRODUCTION DEPLOYMENT

-- Allow service_role to manage brands (for test data setup)
CREATE POLICY "Service role can manage all brands"
ON brands
FOR ALL
TO service_role
USING (TRUE)
WITH CHECK (TRUE);

-- Allow service_role to manage subscriptions (for test data setup)
CREATE POLICY "Service role can manage all subscriptions"
ON subscriptions
FOR ALL
TO service_role
USING (TRUE)
WITH CHECK (TRUE);

-- Allow service_role to manage stores (for test data setup)
CREATE POLICY "Service role can manage all stores"
ON stores
FOR ALL
TO service_role
USING (TRUE)
WITH CHECK (TRUE);

-- Allow service_role to manage staff (for test data setup)
CREATE POLICY "Service role can manage all staff"
ON staff
FOR ALL
TO service_role
USING (TRUE)
WITH CHECK (TRUE);

-- Allow service_role to manage customers (for test data setup)
CREATE POLICY "Service role can manage all customers"
ON customers
FOR ALL
TO service_role
USING (TRUE)
WITH CHECK (TRUE);

-- Allow service_role to manage menu categories (for test data setup)
CREATE POLICY "Service role can manage all menu_categories"
ON menu_categories
FOR ALL
TO service_role
USING (TRUE)
WITH CHECK (TRUE);

-- Allow service_role to manage menu items (for test data setup)
CREATE POLICY "Service role can manage all menu_items"
ON menu_items
FOR ALL
TO service_role
USING (TRUE)
WITH CHECK (TRUE);

-- Allow service_role to manage menu modifiers (for test data setup)
CREATE POLICY "Service role can manage all menu_modifiers"
ON menu_modifiers
FOR ALL
TO service_role
USING (TRUE)
WITH CHECK (TRUE);

-- Allow service_role to manage orders (for test data setup)
CREATE POLICY "Service role can manage all orders"
ON orders
FOR ALL
TO service_role
USING (TRUE)
WITH CHECK (TRUE);

-- Note: This migration should only be applied in development/testing environments
-- In production, service_role should be restricted and these policies removed
