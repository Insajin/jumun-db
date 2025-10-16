-- Allow anonymous users to read brand information
-- Migration: 20251016180000_allow_anon_read_brands

-- This is needed for the customer-web middleware to validate brand slugs
-- Customer-facing apps need to be able to look up brands by slug

CREATE POLICY "Anyone can view brands"
ON brands FOR SELECT
TO anon, authenticated
USING (true);

-- Add comment explaining the policy
COMMENT ON POLICY "Anyone can view brands" ON brands IS
'Allows anonymous and authenticated users to view brand information. This is needed for the customer-facing web app to validate brand slugs in the URL and load brand-specific configuration.';
