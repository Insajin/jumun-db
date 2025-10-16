-- Update customers RLS policies for brand isolation
-- Migration: 20251016000003_update_customers_rls

-- Drop existing customer policies
DROP POLICY IF EXISTS "Customers can view their own profile" ON customers;
DROP POLICY IF EXISTS "Customers can update their own profile" ON customers;
DROP POLICY IF EXISTS "Anyone can create customer profile" ON customers;

-- ============================================================================
-- UPDATED CUSTOMERS TABLE POLICIES (with brand_id isolation)
-- ============================================================================

-- Customers can only see their own data (with brand isolation)
CREATE POLICY "Customers can view their own profile"
ON customers FOR SELECT
TO authenticated
USING (
  user_id = auth.uid() AND
  (brand_id = public.user_brand_id() OR public.user_brand_id() IS NULL)
);

-- Customers can update their own data (with brand isolation)
CREATE POLICY "Customers can update their own profile"
ON customers FOR UPDATE
TO authenticated
USING (
  user_id = auth.uid() AND
  (brand_id = public.user_brand_id() OR public.user_brand_id() IS NULL)
);

-- Customer signup: brand_id must match JWT claim
CREATE POLICY "Customers can create profile with correct brand"
ON customers FOR INSERT
TO authenticated
WITH CHECK (
  user_id = auth.uid() AND
  brand_id = public.user_brand_id()
);

-- Brand admins can view customers in their brand
CREATE POLICY "Brand admins can view their brand's customers"
ON customers FOR SELECT
TO authenticated
USING (
  brand_id = public.user_brand_id() AND
  public.is_brand_admin()
);

-- Super admins can view all customers
CREATE POLICY "Super admins can view all customers"
ON customers FOR SELECT
TO authenticated
USING (public.is_super_admin());

COMMENT ON TABLE customers IS 'Customer profiles (brand-isolated, extends Supabase Auth users)';
