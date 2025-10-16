-- Fix customers RLS policy to properly allow INSERT for anon role
-- Migration: 20251016210000_fix_customers_rls_insert

-- Re-enable RLS on customers table
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;

-- Drop the problematic policy
DROP POLICY IF EXISTS "Anon can insert customers" ON customers;

-- Create a proper INSERT policy with no USING clause (only WITH CHECK)
-- Note: INSERT policies should not have USING clause, only WITH CHECK
CREATE POLICY "Allow anonymous customer creation"
ON customers
FOR INSERT
WITH CHECK (true);

-- Add comment explaining the policy
COMMENT ON POLICY "Allow anonymous customer creation" ON customers IS
'Allows anonymous users to create customer profiles during phone-based registration. Brand filtering is handled by application logic.';
