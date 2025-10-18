-- Allow anonymous role to view menu data for customer web app
-- Migration: 20251018031500_allow_anon_view_menu

-- Menu categories should be publicly readable (for browsing)
ALTER POLICY "Customers can view available menu categories"
ON menu_categories
TO anon, authenticated;

-- Menu items should be publicly readable (for browsing)
ALTER POLICY "Customers can view available menu items"
ON menu_items
TO anon, authenticated;

-- Menu modifiers should be publicly readable (for browsing)
ALTER POLICY "Customers can view menu modifiers"
ON menu_modifiers
TO anon, authenticated;

COMMENT ON POLICY "Customers can view available menu categories" ON menu_categories IS
'Allows anonymous and authenticated customers to browse available menu categories';

COMMENT ON POLICY "Customers can view available menu items" ON menu_items IS
'Allows anonymous and authenticated customers to browse available menu items';

COMMENT ON POLICY "Customers can view menu modifiers" ON menu_modifiers IS
'Allows anonymous and authenticated customers to browse menu modifiers for available items';
