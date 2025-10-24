-- Seed Data: Promotion Banners for Home Page Carousel
-- Created: 2025-10-24
-- Purpose: Replace mock carousel data with real database entries

-- Insert carousel banners for the coffee-and-co brand (OOZY COFFEE)
-- Note: brand_id will be resolved from the brands table

DO $$
DECLARE
  v_brand_id uuid;
BEGIN
  -- Get the brand_id for coffee-and-co
  SELECT id INTO v_brand_id
  FROM brands
  WHERE slug = 'coffee-and-co'
  LIMIT 1;

  -- Only insert if the brand exists
  IF v_brand_id IS NOT NULL THEN
    -- Insert carousel banners
    INSERT INTO promotion_banners (
      brand_id,
      title,
      description,
      image_url,
      link_url,
      display_order,
      active,
      valid_from,
      valid_to
    ) VALUES
    (
      v_brand_id,
      '우지 말차 신메뉴',
      '새로운 맛의 말차 시리즈를 만나보세요',
      'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800',
      NULL,
      1,
      true,
      NOW(),
      NOW() + INTERVAL '30 days'
    ),
    (
      v_brand_id,
      '타임 할인 진행중',
      '지금 주문하면 20% 할인 혜택을 받으실 수 있습니다',
      'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=800',
      NULL,
      2,
      true,
      NOW(),
      NOW() + INTERVAL '7 days'
    )
    ON CONFLICT DO NOTHING;

    RAISE NOTICE 'Inserted promotion banners for coffee-and-co brand';
  ELSE
    RAISE WARNING 'Brand coffee-and-co not found. Skipping banner insertion.';
  END IF;
END $$;
