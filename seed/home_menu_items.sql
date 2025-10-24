-- Seed Data: Menu Items for Home Page Popular Rankings
-- Created: 2025-10-24
-- Purpose: Replace mock popular menu data with real database entries

DO $$
DECLARE
  v_brand_id uuid;
  v_coffee_category_id uuid;
  v_large_category_id uuid;
BEGIN
  -- Get the brand_id for coffee-and-co
  SELECT id INTO v_brand_id
  FROM brands
  WHERE slug = 'coffee-and-co'
  LIMIT 1;

  IF v_brand_id IS NULL THEN
    RAISE WARNING 'Brand coffee-and-co not found. Skipping menu item insertion.';
    RETURN;
  END IF;

  -- Get or create "커피" category
  SELECT id INTO v_coffee_category_id
  FROM menu_categories
  WHERE brand_id = v_brand_id AND name = '커피'
  LIMIT 1;

  IF v_coffee_category_id IS NULL THEN
    INSERT INTO menu_categories (brand_id, name, display_order)
    VALUES (v_brand_id, '커피', 1)
    RETURNING id INTO v_coffee_category_id;
    RAISE NOTICE 'Created 커피 category';
  END IF;

  -- Get or create "대용량" category
  SELECT id INTO v_large_category_id
  FROM menu_categories
  WHERE brand_id = v_brand_id AND name = '대용량'
  LIMIT 1;

  IF v_large_category_id IS NULL THEN
    INSERT INTO menu_categories (brand_id, name, display_order)
    VALUES (v_brand_id, '대용량', 3)
    RETURNING id INTO v_large_category_id;
    RAISE NOTICE 'Created 대용량 category';
  END IF;

  -- Insert popular menu items
  -- These match the mock data from home.ts
  INSERT INTO menu_items (
    brand_id,
    category_id,
    name,
    description,
    price,
    image_url,
    available,
    inventory_tracked
  ) VALUES
  (
    v_brand_id,
    v_coffee_category_id,
    'ICE 아메리카노',
    '시원하고 깔끔한 아이스 아메리카노',
    2000,
    'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400',
    true,
    false
  ),
  (
    v_brand_id,
    v_coffee_category_id,
    '딥 카페라떼',
    '진한 에스프레소와 부드러운 우유의 조화',
    3300,
    'https://images.unsplash.com/photo-1534778101976-62847782c213?w=400',
    true,
    false
  ),
  (
    v_brand_id,
    v_coffee_category_id,
    'HOT 아메리카노',
    '따뜻한 클래식 아메리카노',
    1800,
    'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=400',
    true,
    false
  ),
  (
    v_brand_id,
    v_large_category_id,
    '아메리띠(1L)',
    '대용량 아이스 아메리카노 1L',
    3300,
    'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=400',
    true,
    false
  )
  ON CONFLICT DO NOTHING;

  RAISE NOTICE 'Inserted menu items for coffee-and-co brand';
END $$;
