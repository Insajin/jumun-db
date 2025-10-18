-- Fix guest checkout policy brand/store validation
-- Migration: 20251018033500_fix_guest_order_policy

DROP POLICY IF EXISTS "Anon guest checkout can create orders" ON orders;
DROP POLICY IF EXISTS "Anon guest checkout can view orders" ON orders;

CREATE POLICY "Anon guest checkout can create orders"
ON orders
FOR INSERT
TO anon
WITH CHECK (
  customer_name IS NOT NULL
  AND customer_phone IS NOT NULL
  AND store_id IS NOT NULL
  AND brand_id IS NOT NULL
  AND guest_token IS NOT NULL
  AND guest_token = COALESCE(current_setting('request.header.x-guest-token', true), '')
  AND EXISTS (
    SELECT 1
    FROM stores s
    WHERE s.id = orders.store_id
      AND s.brand_id = orders.brand_id
  )
);

COMMENT ON POLICY "Anon guest checkout can create orders" ON orders IS
'Allows anonymous guests with matching guest token header to create orders for a store.';

CREATE POLICY "Anon guest checkout can view orders"
ON orders
FOR SELECT
TO anon
USING (
  guest_token IS NOT NULL
  AND guest_token = COALESCE(current_setting('request.header.x-guest-token', true), '')
);

COMMENT ON POLICY "Anon guest checkout can view orders" ON orders IS
'Allows anonymous guests to read orders that match their guest session token.';
