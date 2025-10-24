-- Seed Data: App Configuration for coffee-and-co brand
-- Created: 2025-10-24
-- Purpose: Configure OOZY COFFEE app with brand colors and settings

DO $$
DECLARE
  v_brand_id uuid;
BEGIN
  -- Get the brand_id for coffee-and-co
  SELECT id INTO v_brand_id
  FROM brands
  WHERE slug = 'coffee-and-co'
  LIMIT 1;

  IF v_brand_id IS NULL THEN
    RAISE WARNING 'Brand coffee-and-co not found. Skipping app config insertion.';
    RETURN;
  END IF;

  -- Insert or update app_configs entry
  INSERT INTO app_configs (
    brand_id,
    app_name,
    primary_color,
    secondary_color,
    feature_toggles
  ) VALUES (
    v_brand_id,
    'OOZY COFFEE',
    '#1a4d2e',  -- Dark green (from Tailwind config)
    '#5b4abb',  -- Purple (from Tailwind config)
    '{
      "loyalty_enabled": true,
      "real_time_notifications": true,
      "pickup_scheduling": true,
      "promotional_banners": true
    }'::jsonb
  )
  ON CONFLICT (brand_id) DO UPDATE SET
    app_name = EXCLUDED.app_name,
    primary_color = EXCLUDED.primary_color,
    secondary_color = EXCLUDED.secondary_color,
    feature_toggles = EXCLUDED.feature_toggles,
    updated_at = NOW();

  RAISE NOTICE 'Inserted/updated app_configs for coffee-and-co brand';
END $$;
