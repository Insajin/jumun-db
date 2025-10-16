-- Seed data for menu categories and items
-- Brand: Demo Brand (aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa)

-- Insert menu categories
INSERT INTO menu_categories (id, brand_id, name, description, display_order, available, created_at, updated_at)
VALUES
  ('11111111-1111-1111-1111-111111111111', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '커피', '다양한 커피 메뉴', 1, true, NOW(), NOW()),
  ('22222222-2222-2222-2222-222222222222', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '디저트', '달콤한 디저트', 2, true, NOW(), NOW()),
  ('33333333-3333-3333-3333-333333333333', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '베이커리', '신선한 빵', 3, true, NOW(), NOW()),
  ('44444444-4444-4444-4444-444444444444', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '음료', '시원한 음료', 4, true, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- Insert menu items for 커피 category
INSERT INTO menu_items (id, brand_id, category_id, name, description, price, image_url, available, display_order, created_at, updated_at)
VALUES
  ('aaaaaaaa-0001-0001-0001-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', '아메리카노', '깔끔한 에스프레소 샷', 4500, NULL, true, 1, NOW(), NOW()),
  ('aaaaaaaa-0001-0001-0001-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', '카페라떼', '부드러운 우유와 에스프레소', 5000, NULL, true, 2, NOW(), NOW()),
  ('aaaaaaaa-0001-0001-0001-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', '카푸치노', '풍성한 우유 거품', 5000, NULL, true, 3, NOW(), NOW()),
  ('aaaaaaaa-0001-0001-0001-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', '바닐라 라떼', '달콤한 바닐라 시럽', 5500, NULL, true, 4, NOW(), NOW()),
  ('aaaaaaaa-0001-0001-0001-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', '카라멜 마키아또', '진한 카라멜 시럽', 6000, NULL, true, 5, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- Insert menu items for 디저트 category
INSERT INTO menu_items (id, brand_id, category_id, name, description, price, image_url, available, display_order, created_at, updated_at)
VALUES
  ('aaaaaaaa-0002-0002-0002-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '22222222-2222-2222-2222-222222222222', '치즈케이크', '부드러운 크림치즈', 6500, NULL, true, 1, NOW(), NOW()),
  ('aaaaaaaa-0002-0002-0002-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '22222222-2222-2222-2222-222222222222', '티라미수', '이탈리아 전통 디저트', 7000, NULL, true, 2, NOW(), NOW()),
  ('aaaaaaaa-0002-0002-0002-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '22222222-2222-2222-2222-222222222222', '브라우니', '진한 초콜릿', 5500, NULL, true, 3, NOW(), NOW()),
  ('aaaaaaaa-0002-0002-0002-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '22222222-2222-2222-2222-222222222222', '마카롱 세트', '다양한 맛 5개', 8000, NULL, true, 4, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- Insert menu items for 베이커리 category
INSERT INTO menu_items (id, brand_id, category_id, name, description, price, image_url, available, display_order, created_at, updated_at)
VALUES
  ('aaaaaaaa-0003-0003-0003-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '33333333-3333-3333-3333-333333333333', '크루아상', '버터 풍미 가득', 3500, NULL, true, 1, NOW(), NOW()),
  ('aaaaaaaa-0003-0003-0003-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '33333333-3333-3333-3333-333333333333', '베이글', '쫄깃한 식감', 3000, NULL, true, 2, NOW(), NOW()),
  ('aaaaaaaa-0003-0003-0003-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '33333333-3333-3333-3333-333333333333', '식빵', '매일 아침 구운 빵', 4500, NULL, true, 3, NOW(), NOW()),
  ('aaaaaaaa-0003-0003-0003-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '33333333-3333-3333-3333-333333333333', '단팥빵', '달콤한 팥소', 2800, NULL, true, 4, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- Insert menu items for 음료 category
INSERT INTO menu_items (id, brand_id, category_id, name, description, price, image_url, available, display_order, created_at, updated_at)
VALUES
  ('aaaaaaaa-0004-0004-0004-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '44444444-4444-4444-4444-444444444444', '오렌지 주스', '신선한 오렌지', 5000, NULL, true, 1, NOW(), NOW()),
  ('aaaaaaaa-0004-0004-0004-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '44444444-4444-4444-4444-444444444444', '레모네이드', '상큼한 레몬', 4500, NULL, true, 2, NOW(), NOW()),
  ('aaaaaaaa-0004-0004-0004-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '44444444-4444-4444-4444-444444444444', '아이스티', '홍차 베이스', 4000, NULL, true, 3, NOW(), NOW()),
  ('aaaaaaaa-0004-0004-0004-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '44444444-4444-4444-4444-444444444444', '딸기 스무디', '신선한 딸기', 6500, NULL, true, 4, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;
