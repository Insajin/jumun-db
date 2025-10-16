-- Row Level Security (RLS) Policies
-- Migration: 20250101000009_rls_policies
-- This enforces multi-tenant data isolation

-- ============================================================================
-- HELPER FUNCTIONS FOR RLS
-- ============================================================================

-- Get current user's role from JWT
CREATE OR REPLACE FUNCTION public.user_role()
RETURNS TEXT AS $$
  SELECT COALESCE(
    auth.jwt() ->> 'role',
    'customer'
  )::TEXT;
$$ LANGUAGE SQL STABLE SECURITY DEFINER;

-- Get current user's brand_id from JWT
CREATE OR REPLACE FUNCTION public.user_brand_id()
RETURNS UUID AS $$
  SELECT COALESCE(
    (auth.jwt() ->> 'brand_id')::UUID,
    NULL
  );
$$ LANGUAGE SQL STABLE SECURITY DEFINER;

-- Get current user's store_id from JWT
CREATE OR REPLACE FUNCTION public.user_store_id()
RETURNS UUID AS $$
  SELECT COALESCE(
    (auth.jwt() ->> 'store_id')::UUID,
    NULL
  );
$$ LANGUAGE SQL STABLE SECURITY DEFINER;

-- Check if user is super admin
CREATE OR REPLACE FUNCTION public.is_super_admin()
RETURNS BOOLEAN AS $$
  SELECT public.user_role() = 'super_admin';
$$ LANGUAGE SQL STABLE SECURITY DEFINER;

-- Check if user is brand admin
CREATE OR REPLACE FUNCTION public.is_brand_admin()
RETURNS BOOLEAN AS $$
  SELECT public.user_role() IN ('brand_admin', 'super_admin');
$$ LANGUAGE SQL STABLE SECURITY DEFINER;

-- ============================================================================
-- BRANDS TABLE POLICIES
-- ============================================================================

-- Super admins can see all brands
CREATE POLICY "Super admins can view all brands"
ON brands FOR SELECT
TO authenticated
USING (public.is_super_admin());

-- Brand admins can see their own brand
CREATE POLICY "Brand admins can view their brand"
ON brands FOR SELECT
TO authenticated
USING (id = public.user_brand_id());

-- Only super admins can insert brands
CREATE POLICY "Only super admins can create brands"
ON brands FOR INSERT
TO authenticated
WITH CHECK (public.is_super_admin());

-- Super admins can update all brands
CREATE POLICY "Super admins can update all brands"
ON brands FOR UPDATE
TO authenticated
USING (public.is_super_admin());

-- ============================================================================
-- SUBSCRIPTIONS TABLE POLICIES
-- ============================================================================

-- Super admins can see all subscriptions
CREATE POLICY "Super admins can view all subscriptions"
ON subscriptions FOR SELECT
TO authenticated
USING (public.is_super_admin());

-- Brand admins can see their brand's subscription
CREATE POLICY "Brand admins can view their subscription"
ON subscriptions FOR SELECT
TO authenticated
USING (brand_id = public.user_brand_id());

-- Only super admins can modify subscriptions
CREATE POLICY "Only super admins can modify subscriptions"
ON subscriptions FOR ALL
TO authenticated
USING (public.is_super_admin());

-- ============================================================================
-- STORES TABLE POLICIES
-- ============================================================================

-- Super admins can see all stores
CREATE POLICY "Super admins can view all stores"
ON stores FOR SELECT
TO authenticated
USING (public.is_super_admin());

-- Brand admins can see their brand's stores
CREATE POLICY "Brand admins can view their stores"
ON stores FOR SELECT
TO authenticated
USING (brand_id = public.user_brand_id());

-- Staff can see their store
CREATE POLICY "Staff can view their store"
ON stores FOR SELECT
TO authenticated
USING (id = public.user_store_id());

-- Customers can see active stores (for browsing)
CREATE POLICY "Customers can view active stores"
ON stores FOR SELECT
TO authenticated
USING (status = 'active' AND accepting_orders = TRUE);

-- Brand admins can update their stores
CREATE POLICY "Brand admins can update their stores"
ON stores FOR UPDATE
TO authenticated
USING (brand_id = public.user_brand_id());

-- ============================================================================
-- STAFF TABLE POLICIES
-- ============================================================================

-- Staff can view staff in their store
CREATE POLICY "Staff can view their store's staff"
ON staff FOR SELECT
TO authenticated
USING (
  store_id = public.user_store_id() OR
  public.is_brand_admin()
);

-- Only brand admins can manage staff
CREATE POLICY "Brand admins can manage staff"
ON staff FOR ALL
TO authenticated
USING (
  store_id IN (
    SELECT id FROM stores WHERE brand_id = public.user_brand_id()
  )
);

-- ============================================================================
-- CUSTOMERS TABLE POLICIES
-- ============================================================================

-- Customers can only see their own data
CREATE POLICY "Customers can view their own profile"
ON customers FOR SELECT
TO authenticated
USING (user_id = auth.uid());

-- Customers can update their own data
CREATE POLICY "Customers can update their own profile"
ON customers FOR UPDATE
TO authenticated
USING (user_id = auth.uid());

-- Anyone can insert (sign up)
CREATE POLICY "Anyone can create customer profile"
ON customers FOR INSERT
TO authenticated
WITH CHECK (user_id = auth.uid());

-- ============================================================================
-- MENU TABLES POLICIES (menu_categories, menu_items, menu_modifiers)
-- ============================================================================

-- Everyone can view available menu items (for browsing)
CREATE POLICY "Anyone can view available menu categories"
ON menu_categories FOR SELECT
TO authenticated
USING (available = TRUE);

CREATE POLICY "Anyone can view available menu items"
ON menu_items FOR SELECT
TO authenticated
USING (available = TRUE);

CREATE POLICY "Anyone can view menu modifiers"
ON menu_modifiers FOR SELECT
TO authenticated
USING (TRUE);

-- Brand admins can manage their brand's menus
CREATE POLICY "Brand admins can manage menu categories"
ON menu_categories FOR ALL
TO authenticated
USING (brand_id = public.user_brand_id());

CREATE POLICY "Brand admins can manage menu items"
ON menu_items FOR ALL
TO authenticated
USING (brand_id = public.user_brand_id());

CREATE POLICY "Brand admins can manage menu modifiers"
ON menu_modifiers FOR ALL
TO authenticated
USING (
  item_id IN (
    SELECT id FROM menu_items WHERE brand_id = public.user_brand_id()
  )
);

-- ============================================================================
-- INVENTORY TABLE POLICIES
-- ============================================================================

-- Staff can view inventory for their store
CREATE POLICY "Staff can view their store's inventory"
ON inventory FOR SELECT
TO authenticated
USING (store_id = public.user_store_id() OR public.is_brand_admin());

-- Staff can update inventory for their store
CREATE POLICY "Staff can update their store's inventory"
ON inventory FOR ALL
TO authenticated
USING (store_id = public.user_store_id() OR public.is_brand_admin());

-- ============================================================================
-- ORDERS TABLE POLICIES
-- ============================================================================

-- Customers can view their own orders
CREATE POLICY "Customers can view their own orders"
ON orders FOR SELECT
TO authenticated
USING (
  customer_id IN (
    SELECT id FROM customers WHERE user_id = auth.uid()
  )
);

-- Customers can create orders
CREATE POLICY "Customers can create orders"
ON orders FOR INSERT
TO authenticated
WITH CHECK (
  customer_id IN (
    SELECT id FROM customers WHERE user_id = auth.uid()
  )
);

-- Staff can view orders for their store
CREATE POLICY "Staff can view their store's orders"
ON orders FOR SELECT
TO authenticated
USING (
  store_id = public.user_store_id() OR
  public.is_brand_admin()
);

-- Staff can update orders for their store
CREATE POLICY "Staff can update their store's orders"
ON orders FOR UPDATE
TO authenticated
USING (
  store_id = public.user_store_id() OR
  public.is_brand_admin()
);

-- ============================================================================
-- ORDER_STATUS_HISTORY TABLE POLICIES
-- ============================================================================

-- Customers can view history for their orders
CREATE POLICY "Customers can view their order history"
ON order_status_history FOR SELECT
TO authenticated
USING (
  order_id IN (
    SELECT id FROM orders
    WHERE customer_id IN (
      SELECT id FROM customers WHERE user_id = auth.uid()
    )
  )
);

-- Staff can view and insert history for their store's orders
CREATE POLICY "Staff can manage order history for their store"
ON order_status_history FOR ALL
TO authenticated
USING (
  order_id IN (
    SELECT id FROM orders
    WHERE store_id = public.user_store_id() OR
          store_id IN (SELECT id FROM stores WHERE brand_id = public.user_brand_id())
  )
);

-- ============================================================================
-- REFUNDS TABLE POLICIES
-- ============================================================================

-- Customers can view refunds for their orders
CREATE POLICY "Customers can view their refunds"
ON refunds FOR SELECT
TO authenticated
USING (
  order_id IN (
    SELECT id FROM orders
    WHERE customer_id IN (
      SELECT id FROM customers WHERE user_id = auth.uid()
    )
  )
);

-- Staff can manage refunds for their store
CREATE POLICY "Staff can manage refunds for their store"
ON refunds FOR ALL
TO authenticated
USING (
  order_id IN (
    SELECT id FROM orders
    WHERE store_id = public.user_store_id() OR
          store_id IN (SELECT id FROM stores WHERE brand_id = public.user_brand_id())
  )
);

-- ============================================================================
-- PICKUP TABLES POLICIES
-- ============================================================================

-- Anyone can view pickup slots
CREATE POLICY "Anyone can view pickup slots"
ON pickup_slots FOR SELECT
TO authenticated
USING (TRUE);

-- Staff can manage pickup slots for their store
CREATE POLICY "Staff can manage their store's pickup slots"
ON pickup_slots FOR ALL
TO authenticated
USING (store_id = public.user_store_id() OR public.is_brand_admin());

-- Customers can view their own reservations
CREATE POLICY "Customers can view their own reservations"
ON pickup_reservations FOR SELECT
TO authenticated
USING (
  customer_id IN (
    SELECT id FROM customers WHERE user_id = auth.uid()
  )
);

-- Customers can create reservations
CREATE POLICY "Customers can create reservations"
ON pickup_reservations FOR INSERT
TO authenticated
WITH CHECK (
  customer_id IN (
    SELECT id FROM customers WHERE user_id = auth.uid()
  )
);

-- ============================================================================
-- APP CONFIGURATION POLICIES
-- ============================================================================

-- Brand admins can manage their app config
CREATE POLICY "Brand admins can manage their app config"
ON app_configs FOR ALL
TO authenticated
USING (brand_id = public.user_brand_id());

-- Brand admins can view their app builds
CREATE POLICY "Brand admins can view their app builds"
ON app_builds FOR SELECT
TO authenticated
USING (
  app_config_id IN (
    SELECT id FROM app_configs WHERE brand_id = public.user_brand_id()
  )
);

-- ============================================================================
-- PROMOTIONS & LOYALTY POLICIES
-- ============================================================================

-- Brand admins can manage promotions
CREATE POLICY "Brand admins can manage promotions"
ON promotions FOR ALL
TO authenticated
USING (brand_id = public.user_brand_id());

-- Customers can view active promotions
CREATE POLICY "Customers can view active promotions"
ON promotions FOR SELECT
TO authenticated
USING (active = TRUE AND valid_from <= NOW() AND valid_to >= NOW());

-- Customers can view their own coupons
CREATE POLICY "Customers can view their own coupons"
ON coupons FOR SELECT
TO authenticated
USING (
  customer_id IN (
    SELECT id FROM customers WHERE user_id = auth.uid()
  ) OR
  customer_id IS NULL -- public coupons
);

-- Brand admins can manage coupons
CREATE POLICY "Brand admins can manage coupons"
ON coupons FOR ALL
TO authenticated
USING (brand_id = public.user_brand_id());

-- Customers can view their own loyalty transactions
CREATE POLICY "Customers can view their own loyalty transactions"
ON loyalty_transactions FOR SELECT
TO authenticated
USING (
  customer_id IN (
    SELECT id FROM customers WHERE user_id = auth.uid()
  )
);

-- System can insert loyalty transactions
CREATE POLICY "System can create loyalty transactions"
ON loyalty_transactions FOR INSERT
TO authenticated
WITH CHECK (TRUE);

-- ============================================================================
-- NOTIFICATIONS POLICIES
-- ============================================================================

-- Customers can view their own notifications
CREATE POLICY "Customers can view their own notifications"
ON notification_logs FOR SELECT
TO authenticated
USING (
  customer_id IN (
    SELECT id FROM customers WHERE user_id = auth.uid()
  )
);

-- System can manage notifications
CREATE POLICY "System can manage notifications"
ON notification_logs FOR ALL
TO authenticated
WITH CHECK (TRUE);

-- ============================================================================
-- COMMENTS
-- ============================================================================

COMMENT ON FUNCTION public.user_role IS 'Get current user role from JWT claims';
COMMENT ON FUNCTION public.user_brand_id IS 'Get current user brand_id from JWT claims';
COMMENT ON FUNCTION public.user_store_id IS 'Get current user store_id from JWT claims';
COMMENT ON FUNCTION public.is_super_admin IS 'Check if current user is super admin';
COMMENT ON FUNCTION public.is_brand_admin IS 'Check if current user is brand admin or higher';
