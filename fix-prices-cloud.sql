-- Fix menu item prices for Cloud Supabase
-- Prices should be in Korean Won (no decimals)
-- Execute this in Supabase Dashboard > SQL Editor

-- Fix Coffee & Co prices
UPDATE menu_items
SET price = price * 1000
WHERE brand_id = '11111111-1111-1111-1111-111111111111'
  AND price < 100;

-- Fix Burger House prices
UPDATE menu_items
SET price = price * 1000
WHERE brand_id = '22222222-2222-2222-2222-222222222222'
  AND price < 100;

-- Verify the changes
SELECT brand_id, name, price
FROM menu_items
ORDER BY brand_id, name;
