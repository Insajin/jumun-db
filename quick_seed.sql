-- Quick seed for testing

-- Make staff.user_id nullable
ALTER TABLE staff ALTER COLUMN user_id DROP NOT NULL;

-- Insert brands
INSERT INTO brands (id, name, slug) VALUES
  ('11111111-1111-1111-1111-111111111111', 'Coffee & Co', 'coffee-and-co'),
  ('22222222-2222-2222-2222-222222222222', 'Burger House', 'burger-house');

-- Insert subscriptions
INSERT INTO subscriptions (brand_id, plan, status, trial_ends_at, expires_at) VALUES
  ('11111111-1111-1111-1111-111111111111', 'professional', 'active', NULL, NOW() + INTERVAL '1 year'),
  ('22222222-2222-2222-2222-222222222222', 'trial', 'active', NOW() + INTERVAL '30 days', NOW() + INTERVAL '1 year');

-- Insert stores
INSERT INTO stores (id, brand_id, name, slug, address, lat, lng, timezone, phone, status, accepting_orders, operating_hours) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', 'Coffee & Co Gangnam', 'gangnam', '서울시 강남구 테헤란로 123', 37.4979, 127.0276, 'Asia/Seoul', '02-1234-5678', 'active', TRUE,
   '{"monday": {"open": "08:00", "close": "22:00"}}'::jsonb),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', '22222222-2222-2222-2222-222222222222', 'Burger House Itaewon', 'itaewon', '서울시 용산구 이태원로 789', 37.5340, 126.9946, 'Asia/Seoul', '02-3456-7890', 'active', TRUE,
   '{"monday": {"open": "11:00", "close": "23:00"}}'::jsonb);

-- Verify
SELECT 'brands' as table_name, COUNT(*) as count FROM brands
UNION ALL
SELECT 'stores', COUNT(*) FROM stores;
