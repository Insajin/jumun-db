-- Admin users for E2E testing
-- Created: 2025-10-13

-- 1. Super Admin user
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
  '11111111-1111-1111-1111-111111111111'::uuid,
  '00000000-0000-0000-0000-000000000000'::uuid,
  'super@smartorder.io',
  crypt('supersecret', gen_salt('bf')),
  NOW(),
  NOW(),
  NOW(),
  jsonb_build_object(
    'provider', 'email',
    'providers', ARRAY['email'],
    'role', 'super_admin'
  ),
  jsonb_build_object(
    'full_name', 'Super Admin'
  ),
  true,
  'authenticated',
  'authenticated'
);

-- 2. Brand Admin user
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
  '22222222-2222-2222-2222-222222222222'::uuid,
  '00000000-0000-0000-0000-000000000000'::uuid,
  'brand@test.com',
  crypt('test123', gen_salt('bf')),
  NOW(),
  NOW(),
  NOW(),
  jsonb_build_object(
    'provider', 'email',
    'providers', ARRAY['email'],
    'role', 'brand_admin',
    'brand_id', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
  ),
  jsonb_build_object(
    'full_name', 'Brand Admin'
  ),
  false,
  'authenticated',
  'authenticated'
);

-- 3. Store Manager user
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
  '33333333-3333-3333-3333-333333333333'::uuid,
  '00000000-0000-0000-0000-000000000000'::uuid,
  'store@test.com',
  crypt('test123', gen_salt('bf')),
  NOW(),
  NOW(),
  NOW(),
  jsonb_build_object(
    'provider', 'email',
    'providers', ARRAY['email'],
    'role', 'store_manager',
    'brand_id', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
    'store_id', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
  ),
  jsonb_build_object(
    'full_name', 'Store Manager'
  ),
  false,
  'authenticated',
  'authenticated'
);

-- Create identities for auth users (required for Supabase Auth)
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at)
VALUES
  (
    '11111111-1111-1111-1111-111111111111'::uuid,
    '11111111-1111-1111-1111-111111111111'::uuid,
    jsonb_build_object('sub', '11111111-1111-1111-1111-111111111111', 'email', 'super@smartorder.io'),
    'email',
    '11111111-1111-1111-1111-111111111111',
    NOW(),
    NOW(),
    NOW()
  ),
  (
    '22222222-2222-2222-2222-222222222222'::uuid,
    '22222222-2222-2222-2222-222222222222'::uuid,
    jsonb_build_object('sub', '22222222-2222-2222-2222-222222222222', 'email', 'brand@test.com'),
    'email',
    '22222222-2222-2222-2222-222222222222',
    NOW(),
    NOW(),
    NOW()
  ),
  (
    '33333333-3333-3333-3333-333333333333'::uuid,
    '33333333-3333-3333-3333-333333333333'::uuid,
    jsonb_build_object('sub', '33333333-3333-3333-3333-333333333333', 'email', 'store@test.com'),
    'email',
    '33333333-3333-3333-3333-333333333333',
    NOW(),
    NOW(),
    NOW()
  );
