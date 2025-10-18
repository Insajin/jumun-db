-- Simplify guest policy column references
DROP POLICY IF EXISTS "Anon guest checkout can create orders" ON orders;

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
    WHERE s.id = store_id
      AND s.brand_id = brand_id
  )
);
