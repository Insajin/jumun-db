-- Allow anonymous users to view active stores
-- Migration: 20251017000001_allow_anon_read_stores

-- This is needed for the customer-web app to display store information
-- to unauthenticated users browsing the menu

CREATE POLICY "Anon can view active stores"
ON stores FOR SELECT
TO anon
USING (status = 'active' AND accepting_orders = TRUE);

-- Add comment explaining the policy
COMMENT ON POLICY "Anon can view active stores" ON stores IS
'Allows anonymous users to view active stores that are accepting orders. This is needed for customers to browse available stores and menus without logging in.';
