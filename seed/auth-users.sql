-- Seed Test Users for Authentication Testing
-- This file creates test users with different roles for development

-- ============================================================================
-- SUPER ADMIN
-- ============================================================================

-- Create super admin user
INSERT INTO auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  phone,
  phone_confirmed_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at,
  confirmation_token,
  email_change,
  email_change_token_new,
  recovery_token
) VALUES (
  '00000000-0000-0000-0000-000000000000',
  'a0000000-0000-0000-0000-000000000001',
  'authenticated',
  'authenticated',
  'super@jumun.io',
  crypt('SuperAdmin123!', gen_salt('bf')),
  NOW(),
  '+821012340001',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Super Admin","role":"super_admin"}',
  NOW(),
  NOW(),
  '',
  '',
  '',
  ''
) ON CONFLICT (id) DO NOTHING;

-- Link to staff table (no store/brand association for super admin)
INSERT INTO staff (id, store_id, user_id, role, created_at, updated_at)
VALUES (
  'a0000000-0000-0000-0000-000000000001',
  NULL, -- Super admin has no specific store
  'a0000000-0000-0000-0000-000000000001',
  'super_admin',
  NOW(),
  NOW()
) ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- BRAND ADMIN (Coffee & Co)
-- ============================================================================

INSERT INTO auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  phone,
  phone_confirmed_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at,
  confirmation_token,
  email_change,
  email_change_token_new,
  recovery_token
) VALUES (
  '00000000-0000-0000-0000-000000000000',
  'b1111111-1111-1111-1111-111111111111',
  'authenticated',
  'authenticated',
  'brand@coffeeco.com',
  crypt('BrandAdmin123!', gen_salt('bf')),
  NOW(),
  '+821012340002',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Coffee Brand Admin","role":"brand_admin"}',
  NOW(),
  NOW(),
  '',
  '',
  '',
  ''
) ON CONFLICT (id) DO NOTHING;

-- Link to staff table (Coffee & Co brand admin)
INSERT INTO staff (id, store_id, user_id, role, created_at, updated_at)
VALUES (
  'b1111111-1111-1111-1111-111111111111',
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', -- Gangnam store (any store in the brand)
  'b1111111-1111-1111-1111-111111111111',
  'brand_admin',
  NOW(),
  NOW()
) ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- STORE MANAGER (Gangnam Coffee & Co)
-- ============================================================================

INSERT INTO auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  phone,
  phone_confirmed_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at,
  confirmation_token,
  email_change,
  email_change_token_new,
  recovery_token
) VALUES (
  '00000000-0000-0000-0000-000000000000',
  'c2222222-2222-2222-2222-222222222222',
  'authenticated',
  'authenticated',
  'manager@gangnam.coffeeco.com',
  crypt('StoreManager123!', gen_salt('bf')),
  NOW(),
  '+821012340003',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Gangnam Store Manager","role":"store_manager"}',
  NOW(),
  NOW(),
  '',
  '',
  '',
  ''
) ON CONFLICT (id) DO NOTHING;

INSERT INTO staff (id, store_id, user_id, role, created_at, updated_at)
VALUES (
  'c2222222-2222-2222-2222-222222222222',
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', -- Gangnam store
  'c2222222-2222-2222-2222-222222222222',
  'store_manager',
  NOW(),
  NOW()
) ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- STORE STAFF (Hongdae Coffee & Co)
-- ============================================================================

INSERT INTO auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  phone,
  phone_confirmed_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at,
  confirmation_token,
  email_change,
  email_change_token_new,
  recovery_token
) VALUES (
  '00000000-0000-0000-0000-000000000000',
  'd3333333-3333-3333-3333-333333333333',
  'authenticated',
  'authenticated',
  'staff@hongdae.coffeeco.com',
  crypt('StoreStaff123!', gen_salt('bf')),
  NOW(),
  '+821012340004',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Hongdae Store Staff","role":"store_staff"}',
  NOW(),
  NOW(),
  '',
  '',
  '',
  ''
) ON CONFLICT (id) DO NOTHING;

INSERT INTO staff (id, store_id, user_id, role, created_at, updated_at)
VALUES (
  'd3333333-3333-3333-3333-333333333333',
  'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', -- Hongdae store
  'd3333333-3333-3333-3333-333333333333',
  'store_staff',
  NOW(),
  NOW()
) ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- CUSTOMERS
-- ============================================================================

-- Customer 1: Regular customer with loyalty points
INSERT INTO auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  phone,
  phone_confirmed_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at,
  confirmation_token,
  email_change,
  email_change_token_new,
  recovery_token
) VALUES (
  '00000000-0000-0000-0000-000000000000',
  'e4444444-4444-4444-4444-444444444444',
  'authenticated',
  'authenticated',
  'customer1@example.com',
  crypt('Customer123!', gen_salt('bf')),
  NOW(),
  '+821012340005',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"김철수","role":"customer"}',
  NOW(),
  NOW(),
  '',
  '',
  '',
  ''
) ON CONFLICT (id) DO NOTHING;

-- Customer already exists in seed.sql, just update user_id
UPDATE customers
SET user_id = 'e4444444-4444-4444-4444-444444444444'
WHERE id = 'm1111111-1111-1111-1111-111111111111';

-- Customer 2: New customer
INSERT INTO auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  phone,
  phone_confirmed_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at,
  confirmation_token,
  email_change,
  email_change_token_new,
  recovery_token
) VALUES (
  '00000000-0000-0000-0000-000000000000',
  'f5555555-5555-5555-5555-555555555555',
  'authenticated',
  'authenticated',
  'customer2@example.com',
  crypt('Customer123!', gen_salt('bf')),
  NOW(),
  '+821012340006',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"이영희","role":"customer"}',
  NOW(),
  NOW(),
  '',
  '',
  '',
  ''
) ON CONFLICT (id) DO NOTHING;

UPDATE customers
SET user_id = 'f5555555-5555-5555-5555-555555555555'
WHERE id = 'm2222222-2222-2222-2222-222222222222';

-- Customer 3: Phone-only authentication (for testing SMS OTP)
INSERT INTO auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  phone,
  phone_confirmed_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at,
  confirmation_token,
  email_change,
  email_change_token_new,
  recovery_token
) VALUES (
  '00000000-0000-0000-0000-000000000000',
  'g6666666-6666-6666-6666-666666666666',
  'authenticated',
  'authenticated',
  NULL, -- No email, phone-only
  NULL, -- No password, uses OTP
  NULL,
  '+821012340007',
  NOW(),
  '{"provider":"phone","providers":["phone"]}',
  '{"full_name":"박민수","role":"customer"}',
  NOW(),
  NOW(),
  '',
  '',
  '',
  ''
) ON CONFLICT (id) DO NOTHING;

INSERT INTO customers (id, user_id, phone, full_name, created_at, updated_at)
VALUES (
  'g6666666-6666-6666-6666-666666666666',
  'g6666666-6666-6666-6666-666666666666',
  '+821012340007',
  '박민수',
  NOW(),
  NOW()
) ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- SUMMARY
-- ============================================================================

COMMENT ON COLUMN auth.users.encrypted_password IS 'All test passwords: [Role]123! (e.g., Customer123!, SuperAdmin123!)';

-- Create a view to easily see all test users
CREATE OR REPLACE VIEW test_users_summary AS
SELECT
  u.id,
  u.email,
  u.phone,
  u.email_confirmed_at IS NOT NULL AS email_confirmed,
  u.phone_confirmed_at IS NOT NULL AS phone_confirmed,
  COALESCE(s.role::TEXT, 'customer') AS role,
  CASE
    WHEN s.role = 'super_admin' THEN 'Full platform access'
    WHEN s.role = 'brand_admin' THEN 'Brand: ' || b.name
    WHEN s.role IN ('store_manager', 'store_staff') THEN 'Store: ' || st.name
    ELSE 'Customer'
  END AS access_scope
FROM auth.users u
LEFT JOIN staff s ON u.id = s.user_id
LEFT JOIN stores st ON s.store_id = st.id
LEFT JOIN brands b ON st.brand_id = b.id
WHERE u.email LIKE '%jumun.io' OR u.email LIKE '%coffeeco.com' OR u.email LIKE '%example.com'
ORDER BY
  CASE s.role
    WHEN 'super_admin' THEN 1
    WHEN 'brand_admin' THEN 2
    WHEN 'store_manager' THEN 3
    WHEN 'store_staff' THEN 4
    ELSE 5
  END,
  u.created_at;

COMMENT ON VIEW test_users_summary IS 'Summary of all test users for development';
