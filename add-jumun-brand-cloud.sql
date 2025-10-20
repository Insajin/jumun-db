-- Add "jumun" brand for Cloud Supabase (stage.jumun.store)
-- Execute this in Supabase Dashboard > SQL Editor
-- Project: vbwwglhplxmcquiqrqak

-- Insert jumun brand
INSERT INTO brands (id, name, slug, created_at)
VALUES (
  'dddddddd-dddd-dddd-dddd-dddddddddddd'::uuid,
  'Jumun',
  'jumun',
  NOW()
) ON CONFLICT (slug) DO NOTHING;

-- Insert subscription for Jumun brand
INSERT INTO subscriptions (brand_id, plan, status, trial_ends_at, expires_at)
VALUES (
  'dddddddd-dddd-dddd-dddd-dddddddddddd'::uuid,
  'professional',
  'active',
  NULL,
  NOW() + INTERVAL '1 year'
) ON CONFLICT DO NOTHING;

-- Insert app config for Jumun
INSERT INTO app_configs (
  brand_id,
  app_name,
  logo_url,
  primary_color,
  feature_toggles,
  created_at
)
VALUES (
  'dddddddd-dddd-dddd-dddd-dddddddddddd'::uuid,
  'Jumun',
  NULL,
  '#2563eb',
  '{"loyalty": {"enabled": true, "stamps_enabled": true, "stamps_for_reward": 10, "points_earn_rate": 5, "points_redemption_enabled": true, "points_to_currency_ratio": 100}}'::jsonb,
  NOW()
) ON CONFLICT DO NOTHING;

-- Insert test store for Jumun
INSERT INTO stores (id, brand_id, name, slug, address, phone, status, accepting_orders, is_online, created_at)
VALUES (
  'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee'::uuid,
  'dddddddd-dddd-dddd-dddd-dddddddddddd'::uuid,
  'Jumun Flagship Store',
  'flagship',
  'Seoul, South Korea',
  '02-9999-8888',
  'active',
  true,
  true,
  NOW()
) ON CONFLICT DO NOTHING;

-- Add menu categories
INSERT INTO menu_categories (id, brand_id, store_id, parent_id, name, description, display_order, available) VALUES
  ('j1111111-1111-1111-1111-111111111111', 'dddddddd-dddd-dddd-dddd-dddddddddddd', NULL, NULL, '음료', 'Beverages', 1, TRUE),
  ('j2222222-2222-2222-2222-222222222222', 'dddddddd-dddd-dddd-dddd-dddddddddddd', NULL, NULL, '식사', 'Meals', 2, TRUE),
  ('j3333333-3333-3333-3333-333333333333', 'dddddddd-dddd-dddd-dddd-dddddddddddd', NULL, NULL, '디저트', 'Desserts', 3, TRUE)
ON CONFLICT DO NOTHING;

-- Add sample menu items
INSERT INTO menu_items (id, brand_id, store_id, category_id, name, description, price, available, created_at) VALUES
  ('m1111111-1111-1111-1111-111111111111', 'dddddddd-dddd-dddd-dddd-dddddddddddd', NULL, 'j1111111-1111-1111-1111-111111111111', '아메리카노', 'Classic Americano', 4500, TRUE, NOW()),
  ('m2222222-2222-2222-2222-222222222222', 'dddddddd-dddd-dddd-dddd-dddddddddddd', NULL, 'j1111111-1111-1111-1111-111111111111', '카페 라떼', 'Cafe Latte', 5000, TRUE, NOW()),
  ('m3333333-3333-3333-3333-333333333333', 'dddddddd-dddd-dddd-dddd-dddddddddddd', NULL, 'j2222222-2222-2222-2222-222222222222', '크로와상 샌드위치', 'Croissant Sandwich', 7500, TRUE, NOW()),
  ('m4444444-4444-4444-4444-444444444444', 'dddddddd-dddd-dddd-dddd-dddddddddddd', NULL, 'j3333333-3333-3333-3333-333333333333', '초콜릿 케이크', 'Chocolate Cake', 6500, TRUE, NOW())
ON CONFLICT DO NOTHING;

-- Verify insertion
SELECT 'Brand created:' as message, id, name, slug FROM brands WHERE slug = 'jumun';
SELECT 'Store created:' as message, id, name FROM stores WHERE brand_id = 'dddddddd-dddd-dddd-dddd-dddddddddddd';
SELECT 'Menu items:' as message, COUNT(*) as count FROM menu_items WHERE brand_id = 'dddddddd-dddd-dddd-dddd-dddddddddddd';
