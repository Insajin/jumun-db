-- Seed data for E2E testing
-- Created: 2025-10-13

-- Insert test brand
INSERT INTO brands (id, name, slug, created_at)
VALUES (
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'::uuid,
  'Coffee Co',
  'coffeeco',
  NOW()
);

-- Insert app config for Coffee Co
INSERT INTO app_configs (
  brand_id,
  app_name,
  logo_url,
  primary_color,
  feature_toggles,
  created_at
)
VALUES (
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'::uuid,
  'Coffee Co',
  NULL,
  '#2563eb',
  '{"loyalty": {"enabled": true, "stamps_enabled": true, "stamps_for_reward": 10, "points_earn_rate": 5, "points_redemption_enabled": true}}'::jsonb,
  NOW()
);

-- Insert test store
INSERT INTO stores (id, brand_id, name, slug, address, phone, status, accepting_orders, created_at)
VALUES (
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'::uuid,
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'::uuid,
  'Coffee Co Gangnam',
  'gangnam',
  '123 Gangnam-daero, Seoul',
  '02-1234-5678',
  'active',
  true,
  NOW()
);

-- Create test user in auth.users (required for customers table)
INSERT INTO auth.users (
  id,
  instance_id,
  email,
  encrypted_password,
  email_confirmed_at,
  created_at,
  updated_at,
  raw_app_meta_data,
  raw_user_meta_data,
  is_super_admin,
  role,
  aud
)
VALUES (
  'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'::uuid,
  '00000000-0000-0000-0000-000000000000'::uuid,
  'testcustomer@test.com',
  crypt('password123', gen_salt('bf')),
  NOW(),
  NOW(),
  NOW(),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Test Customer"}'::jsonb,
  false,
  'authenticated',
  'authenticated'
);

-- Create customer record
INSERT INTO customers (id, user_id, brand_id, phone, created_at)
VALUES (
  'cccccccc-cccc-cccc-cccc-cccccccccccc'::uuid,
  'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'::uuid,
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'::uuid,
  '010-9999-8888',
  NOW()
);

-- Insert test order with payment failed
INSERT INTO orders (
  id, brand_id, store_id, customer_id,
  customer_name, customer_phone,
  status, payment_status, payment_method,
  subtotal, tax, total,
  pickup_window_start, pickup_window_end,
  items,
  created_at
)
VALUES (
  '00000006-0000-0000-0000-000000000001'::uuid,
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'::uuid,
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'::uuid,
  'cccccccc-cccc-cccc-cccc-cccccccccccc'::uuid,  -- Reference test customer
  'Payment Failed Customer',
  '010-9999-8888',
  'waiting',
  'failed',
  'toss',
  5500,
  550,
  6050,
  NOW() + INTERVAL '5 minutes',
  NOW() + INTERVAL '35 minutes',
  '[{"menu_item_id": "item-1", "menu_item_name": "Green Tea Latte", "quantity": 1, "unit_price": 5500, "selected_modifiers": [{"name": "Large", "price": 1000}]}]'::jsonb,
  NOW() - INTERVAL '10 minutes'
);
