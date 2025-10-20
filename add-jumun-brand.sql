-- Add "jumun" brand for staging environment
-- This allows https://jumun.store/jumun to work

-- Insert jumun brand
INSERT INTO brands (id, name, slug, created_at)
VALUES (
  'dddddddd-dddd-dddd-dddd-dddddddddddd'::uuid,
  'Jumun',
  'jumun',
  NOW()
) ON CONFLICT (slug) DO NOTHING;

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
  '{"loyalty": {"enabled": true, "stamps_enabled": true, "stamps_for_reward": 10, "points_earn_rate": 5, "points_redemption_enabled": true}}'::jsonb,
  NOW()
) ON CONFLICT DO NOTHING;

-- Insert test store for Jumun
INSERT INTO stores (id, brand_id, name, slug, address, phone, status, accepting_orders, created_at)
VALUES (
  'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee'::uuid,
  'dddddddd-dddd-dddd-dddd-dddddddddddd'::uuid,
  'Jumun Flagship Store',
  'flagship',
  'Seoul, South Korea',
  '02-9999-8888',
  'active',
  true,
  NOW()
) ON CONFLICT DO NOTHING;
