-- Allow anonymous guest checkout orders
-- Migration: 20251018033000_allow_guest_orders

-- Add guest_token column to orders table
ALTER TABLE orders
ADD COLUMN guest_token TEXT;

COMMENT ON COLUMN orders.guest_token IS 'Anonymous guest session token used to authorize order access';

-- Allow anonymous users to create guest orders when guest checkout is enabled
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
    WHERE s.id = store_id
      AND s.brand_id = brand_id
  )
);

COMMENT ON POLICY "Anon guest checkout can create orders" ON orders IS
'Allows anonymous guests with matching guest token header to create orders for a store.';

-- Allow anonymous users to read only their own guest orders
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
