-- Fix menu_items RLS policies to enforce strict brand isolation (2025-10-16)
--
-- Problem: The "Anyone can view available menu items" policy allows brand admins
-- to view ALL available items across brands, breaking tenant isolation.
--
-- Solution: Split the SELECT policies by role:
-- - Customers/Anonymous: Can view available items (for browsing)
-- - Brand Admins: Can ONLY view their own brand's items (enforces isolation)

-- Drop existing conflicting policies
DROP POLICY IF EXISTS "Anyone can view available menu categories" ON menu_categories;
DROP POLICY IF EXISTS "Anyone can view available menu items" ON menu_items;
DROP POLICY IF EXISTS "Anyone can view menu modifiers" ON menu_modifiers;
DROP POLICY IF EXISTS "Brand admins can manage menu categories" ON menu_categories;
DROP POLICY IF EXISTS "Brand admins can manage menu items" ON menu_items;
DROP POLICY IF EXISTS "Brand admins can manage menu modifiers" ON menu_modifiers;

-- ============================================================================
-- MENU CATEGORIES - Strict Role-Based Access
-- ============================================================================

-- Customers and anonymous users can view available categories
CREATE POLICY "Customers can view available menu categories"
ON menu_categories FOR SELECT
TO authenticated
USING (
  available = TRUE
  AND public.user_role() NOT IN ('brand_admin', 'super_admin')
);

-- Brand admins can view only their brand's categories (available or not)
CREATE POLICY "Brand admins can view their menu categories"
ON menu_categories FOR SELECT
TO authenticated
USING (
  brand_id = public.user_brand_id()
  AND public.is_brand_admin()
);

-- Brand admins can insert their brand's categories
CREATE POLICY "Brand admins can insert menu categories"
ON menu_categories FOR INSERT
TO authenticated
WITH CHECK (
  brand_id = public.user_brand_id()
  AND public.is_brand_admin()
);

-- Brand admins can update their brand's categories
CREATE POLICY "Brand admins can update menu categories"
ON menu_categories FOR UPDATE
TO authenticated
USING (
  brand_id = public.user_brand_id()
  AND public.is_brand_admin()
);

-- Brand admins can delete their brand's categories
CREATE POLICY "Brand admins can delete menu categories"
ON menu_categories FOR DELETE
TO authenticated
USING (
  brand_id = public.user_brand_id()
  AND public.is_brand_admin()
);

-- ============================================================================
-- MENU ITEMS - Strict Role-Based Access
-- ============================================================================

-- Customers and anonymous users can view available items
CREATE POLICY "Customers can view available menu items"
ON menu_items FOR SELECT
TO authenticated
USING (
  available = TRUE
  AND public.user_role() NOT IN ('brand_admin', 'super_admin')
);

-- Brand admins can view only their brand's items (available or not)
CREATE POLICY "Brand admins can view their menu items"
ON menu_items FOR SELECT
TO authenticated
USING (
  brand_id = public.user_brand_id()
  AND public.is_brand_admin()
);

-- Brand admins can insert their brand's items
CREATE POLICY "Brand admins can insert menu items"
ON menu_items FOR INSERT
TO authenticated
WITH CHECK (
  brand_id = public.user_brand_id()
  AND public.is_brand_admin()
);

-- Brand admins can update their brand's items
CREATE POLICY "Brand admins can update menu items"
ON menu_items FOR UPDATE
TO authenticated
USING (
  brand_id = public.user_brand_id()
  AND public.is_brand_admin()
);

-- Brand admins can delete their brand's items
CREATE POLICY "Brand admins can delete menu items"
ON menu_items FOR DELETE
TO authenticated
USING (
  brand_id = public.user_brand_id()
  AND public.is_brand_admin()
);

-- ============================================================================
-- MENU MODIFIERS - Strict Role-Based Access
-- ============================================================================

-- Customers can view modifiers for available items
CREATE POLICY "Customers can view menu modifiers"
ON menu_modifiers FOR SELECT
TO authenticated
USING (
  public.user_role() NOT IN ('brand_admin', 'super_admin')
  AND item_id IN (
    SELECT id FROM menu_items WHERE available = TRUE
  )
);

-- Brand admins can view modifiers for their brand's items
CREATE POLICY "Brand admins can view their menu modifiers"
ON menu_modifiers FOR SELECT
TO authenticated
USING (
  item_id IN (
    SELECT id FROM menu_items WHERE brand_id = public.user_brand_id()
  )
  AND public.is_brand_admin()
);

-- Brand admins can insert modifiers for their brand's items
CREATE POLICY "Brand admins can insert menu modifiers"
ON menu_modifiers FOR INSERT
TO authenticated
WITH CHECK (
  item_id IN (
    SELECT id FROM menu_items WHERE brand_id = public.user_brand_id()
  )
  AND public.is_brand_admin()
);

-- Brand admins can update modifiers for their brand's items
CREATE POLICY "Brand admins can update menu modifiers"
ON menu_modifiers FOR UPDATE
TO authenticated
USING (
  item_id IN (
    SELECT id FROM menu_items WHERE brand_id = public.user_brand_id()
  )
  AND public.is_brand_admin()
);

-- Brand admins can delete modifiers for their brand's items
CREATE POLICY "Brand admins can delete menu modifiers"
ON menu_modifiers FOR DELETE
TO authenticated
USING (
  item_id IN (
    SELECT id FROM menu_items WHERE brand_id = public.user_brand_id()
  )
  AND public.is_brand_admin()
);

-- ============================================================================
-- COMMENTS
-- ============================================================================

COMMENT ON POLICY "Customers can view available menu items" ON menu_items IS
'Allows non-admin users to browse available menu items for ordering';

COMMENT ON POLICY "Brand admins can view their menu items" ON menu_items IS
'Enforces strict brand isolation - admins can only view their own brand items';
