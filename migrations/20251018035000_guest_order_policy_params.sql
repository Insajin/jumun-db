-- Adjust guest checkout policies to use request parameters instead of custom headers
-- Migration: 20251018035000_guest_order_policy_params

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
  AND char_length(guest_token) >= 12
  AND EXISTS (
    SELECT 1
    FROM stores s
    WHERE s.id = orders.store_id
      AND s.brand_id = orders.brand_id
  )
);

COMMENT ON POLICY "Anon guest checkout can create orders" ON orders IS
'Allows anonymous guests to create orders when a guest token is provided.';

CREATE POLICY "Anon guest checkout can view orders"
ON orders
FOR SELECT
TO anon
USING (
  guest_token IS NOT NULL
  AND current_setting('request.parameter.guest_token', true) LIKE 'eq.%'
  AND guest_token = substring(current_setting('request.parameter.guest_token', true) FROM 4)
);

COMMENT ON POLICY "Anon guest checkout can view orders" ON orders IS
'Allows anonymous guests to view orders by filtering with guest_token=eq.{token}.';
