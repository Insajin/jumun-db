-- Temporary RLS policies for E2E testing (2025-10-13)
-- These policies allow anonymous users to SELECT/UPDATE orders/stores for the test store
-- ⚠️ REMOVE THESE POLICIES BEFORE PRODUCTION DEPLOYMENT

-- Allow anonymous users to SELECT the test store
CREATE POLICY "Allow anon select test store"
ON stores
FOR SELECT
TO anon
USING (id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'::uuid);

-- Allow anonymous users to UPDATE orders for test store
CREATE POLICY "Allow anon update orders for test store"
ON orders
FOR UPDATE
TO anon
USING (store_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'::uuid)
WITH CHECK (store_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'::uuid);

-- Allow anonymous users to SELECT orders for test store
CREATE POLICY "Allow anon select orders for test store"
ON orders
FOR SELECT
TO anon
USING (store_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'::uuid);

-- Note: stores UPDATE policy already exists from previous migration
