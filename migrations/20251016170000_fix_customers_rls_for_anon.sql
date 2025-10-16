-- Fix customers RLS policies to allow anonymous user registration
-- Migration: 20251016170000_fix_customers_rls_for_anon

-- Drop the existing INSERT policy that only allows authenticated users
DROP POLICY IF EXISTS "Customers can create profile with correct brand" ON customers;

-- Create new INSERT policy that allows both anon and authenticated users
-- This is needed for the phone-based registration flow
CREATE POLICY "Anyone can create customer profile"
ON customers FOR INSERT
TO anon, authenticated
WITH CHECK (true);

-- Add a comment explaining the policy
COMMENT ON POLICY "Anyone can create customer profile" ON customers IS
'Allows anonymous users to create customer profiles during phone registration. Brand filtering is handled by application logic.';
