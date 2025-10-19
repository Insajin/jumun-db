-- ==========================================================================
-- Jumun Supabase Schema
-- Generated: 2025-10-19T00:04:42Z UTC
-- Source: supabase/migrations (concatenated in timestamp order)
-- Do not edit manually. Update migrations instead.
-- ==========================================================================

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET search_path = public, extensions;

-- ==========================================================================
-- Full sample data (seed/seed.sql)
-- ==========================================================================
-- Seed data for Jumun platform
-- This creates test data for development and testing

-- Clean up existing data (in reverse order of dependencies)
TRUNCATE TABLE
  notification_logs,
  loyalty_transactions,
  coupons,
  promotions,
  app_builds,
  app_configs,
  pickup_reservations,
  pickup_slots,
  refunds,
  order_status_history,
  orders,
  inventory,
  menu_modifiers,
  menu_items,
  menu_categories,
  customers,
  staff,
  stores,
  subscriptions,
  brands
CASCADE;

-- ============================================================================
-- BRANDS
-- ============================================================================

INSERT INTO brands (id, name, slug) VALUES
  ('11111111-1111-1111-1111-111111111111', 'Coffee & Co', 'coffee-and-co'),
  ('22222222-2222-2222-2222-222222222222', 'Burger House', 'burger-house');

-- ============================================================================
-- SUBSCRIPTIONS
-- ============================================================================

INSERT INTO subscriptions (brand_id, plan, status, trial_ends_at, expires_at) VALUES
  ('11111111-1111-1111-1111-111111111111', 'professional', 'active', NULL, NOW() + INTERVAL '1 year'),
  ('22222222-2222-2222-2222-222222222222', 'trial', 'active', NOW() + INTERVAL '30 days', NOW() + INTERVAL '1 year');

-- ============================================================================
-- STORES
-- ============================================================================

INSERT INTO stores (id, brand_id, name, slug, address, lat, lng, timezone, phone, status, accepting_orders, operating_hours) VALUES
  -- Coffee & Co stores
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', 'Coffee & Co Gangnam', 'gangnam', '서울시 강남구 테헤란로 123', 37.4979, 127.0276, 'Asia/Seoul', '02-1234-5678', 'active', TRUE,
   '{"monday": {"open": "08:00", "close": "22:00"}, "tuesday": {"open": "08:00", "close": "22:00"}, "wednesday": {"open": "08:00", "close": "22:00"}, "thursday": {"open": "08:00", "close": "22:00"}, "friday": {"open": "08:00", "close": "23:00"}, "saturday": {"open": "09:00", "close": "23:00"}, "sunday": {"open": "09:00", "close": "21:00"}}'::jsonb),

  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '11111111-1111-1111-1111-111111111111', 'Coffee & Co Hongdae', 'hongdae', '서울시 마포구 홍익로 456', 37.5563, 126.9241, 'Asia/Seoul', '02-2345-6789', 'active', TRUE,
   '{"monday": {"open": "08:00", "close": "22:00"}, "tuesday": {"open": "08:00", "close": "22:00"}, "wednesday": {"open": "08:00", "close": "22:00"}, "thursday": {"open": "08:00", "close": "22:00"}, "friday": {"open": "08:00", "close": "24:00"}, "saturday": {"open": "09:00", "close": "24:00"}, "sunday": {"open": "09:00", "close": "22:00"}}'::jsonb),

  -- Burger House stores
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', '22222222-2222-2222-2222-222222222222', 'Burger House Itaewon', 'itaewon', '서울시 용산구 이태원로 789', 37.5340, 126.9946, 'Asia/Seoul', '02-3456-7890', 'active', TRUE,
   '{"monday": {"open": "11:00", "close": "23:00"}, "tuesday": {"open": "11:00", "close": "23:00"}, "wednesday": {"open": "11:00", "close": "23:00"}, "thursday": {"open": "11:00", "close": "23:00"}, "friday": {"open": "11:00", "close": "24:00"}, "saturday": {"open": "11:00", "close": "24:00"}, "sunday": {"open": "11:00", "close": "23:00"}}'::jsonb);

-- ============================================================================
-- STAFF (Note: user_id references auth.users - these should be created via Supabase Auth)
-- ============================================================================

-- For development, we'll use placeholder UUIDs
-- In production, these should be actual auth.users IDs

INSERT INTO staff (store_id, user_id, role, permissions) VALUES
  -- Coffee & Co Gangnam staff
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'a1111111-1111-1111-1111-111111111111', 'store_manager', '{"can_manage_inventory": true, "can_refund": true, "can_manage_staff": true}'::jsonb),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'a2222222-2222-2222-2222-222222222222', 'store_staff', '{"can_manage_inventory": true, "can_refund": false}'::jsonb),

  -- Coffee & Co Hongdae staff
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'b1111111-1111-1111-1111-111111111111', 'store_manager', '{"can_manage_inventory": true, "can_refund": true, "can_manage_staff": true}'::jsonb),

  -- Burger House Itaewon staff
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'c1111111-1111-1111-1111-111111111111', 'store_manager', '{"can_manage_inventory": true, "can_refund": true, "can_manage_staff": true}'::jsonb);

-- ============================================================================
-- CUSTOMERS
-- ============================================================================

INSERT INTO customers (id, brand_id, user_id, phone, phone_verified_at, loyalty_points, preferences) VALUES
  ('d1111111-1111-1111-1111-111111111111', '11111111-1111-1111-1111-111111111111', 'd1111111-1111-1111-1111-111111111111', '+821012345678', NOW(), 100, '{"notifications": {"push": true, "sms": true}, "language": "ko"}'::jsonb),
  ('d2222222-2222-2222-2222-222222222222', '22222222-2222-2222-2222-222222222222', 'd2222222-2222-2222-2222-222222222222', '+821098765432', NOW(), 50, '{"notifications": {"push": true, "sms": false}, "language": "ko"}'::jsonb);

-- ============================================================================
-- MENU CATEGORIES (Coffee & Co)
-- ============================================================================

INSERT INTO menu_categories (id, brand_id, store_id, parent_id, name, description, display_order, available) VALUES
  -- Brand-level categories
  ('e1111111-1111-1111-1111-111111111111', '11111111-1111-1111-1111-111111111111', NULL, NULL, 'Coffee', 'Hot and cold coffee drinks', 1, TRUE),
  ('e2222222-2222-2222-2222-222222222222', '11111111-1111-1111-1111-111111111111', NULL, NULL, 'Non-Coffee', 'Tea, juice, and other beverages', 2, TRUE),
  ('e3333333-3333-3333-3333-333333333333', '11111111-1111-1111-1111-111111111111', NULL, NULL, 'Desserts', 'Cakes, cookies, and pastries', 3, TRUE),

  -- Subcategories
  ('e4444444-4444-4444-4444-444444444444', '11111111-1111-1111-1111-111111111111', NULL, 'e1111111-1111-1111-1111-111111111111', 'Espresso', 'Espresso-based drinks', 1, TRUE),
  ('e5555555-5555-5555-5555-555555555555', '11111111-1111-1111-1111-111111111111', NULL, 'e1111111-1111-1111-1111-111111111111', 'Brewed', 'Drip and cold brew', 2, TRUE);

-- ============================================================================
-- MENU CATEGORIES (Burger House)
-- ============================================================================

INSERT INTO menu_categories (id, brand_id, store_id, parent_id, name, description, display_order, available) VALUES
  ('f1111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222', NULL, NULL, 'Burgers', 'Our signature burgers', 1, TRUE),
  ('f2222222-2222-2222-2222-222222222222', '22222222-2222-2222-2222-222222222222', NULL, NULL, 'Sides', 'Fries, onion rings, and more', 2, TRUE),
  ('f3333333-3333-3333-3333-333333333333', '22222222-2222-2222-2222-222222222222', NULL, NULL, 'Drinks', 'Soft drinks and shakes', 3, TRUE);

-- ============================================================================
-- MENU ITEMS (Coffee & Co)
-- ============================================================================

INSERT INTO menu_items (id, brand_id, store_id, category_id, name, description, price, available, inventory_tracked, display_order) VALUES
  -- Espresso drinks
  ('a1111111-1111-1111-1111-111111111111', '11111111-1111-1111-1111-111111111111', NULL, 'e4444444-4444-4444-4444-444444444444', 'Americano', 'Classic espresso with hot water', 4.50, TRUE, FALSE, 1),
  ('a2222222-2222-2222-2222-222222222222', '11111111-1111-1111-1111-111111111111', NULL, 'e4444444-4444-4444-4444-444444444444', 'Latte', 'Espresso with steamed milk', 5.00, TRUE, FALSE, 2),
  ('a3333333-3333-3333-3333-333333333333', '11111111-1111-1111-1111-111111111111', NULL, 'e4444444-4444-4444-4444-444444444444', 'Cappuccino', 'Espresso with foamed milk', 5.00, TRUE, FALSE, 3),

  -- Brewed coffee
  ('a4444444-4444-4444-4444-444444444444', '11111111-1111-1111-1111-111111111111', NULL, 'e5555555-5555-5555-5555-555555555555', 'Drip Coffee', 'Fresh brewed daily', 3.50, TRUE, FALSE, 1),
  ('a5555555-5555-5555-5555-555555555555', '11111111-1111-1111-1111-111111111111', NULL, 'e5555555-5555-5555-5555-555555555555', 'Cold Brew', 'Smooth cold brew coffee', 5.50, TRUE, FALSE, 2),

  -- Desserts
  ('a6666666-6666-6666-6666-666666666666', '11111111-1111-1111-1111-111111111111', NULL, 'e3333333-3333-3333-3333-333333333333', 'Chocolate Cake', 'Rich chocolate layer cake', 6.00, TRUE, TRUE, 1),
  ('a7777777-7777-7777-7777-777777777777', '11111111-1111-1111-1111-111111111111', NULL, 'e3333333-3333-3333-3333-333333333333', 'Croissant', 'Buttery French croissant', 3.50, TRUE, TRUE, 2);

-- ============================================================================
-- MENU ITEMS (Burger House)
-- ============================================================================

INSERT INTO menu_items (id, brand_id, store_id, category_id, name, description, price, available, inventory_tracked, display_order) VALUES
  -- Burgers
  ('b1111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222', NULL, 'f1111111-1111-1111-1111-111111111111', 'Classic Burger', '100% beef patty with lettuce, tomato, onion', 9.99, TRUE, FALSE, 1),
  ('b2222222-2222-2222-2222-222222222222', '22222222-2222-2222-2222-222222222222', NULL, 'f1111111-1111-1111-1111-111111111111', 'Cheese Burger', 'Classic burger with cheddar cheese', 10.99, TRUE, FALSE, 2),
  ('b3333333-3333-3333-3333-333333333333', '22222222-2222-2222-2222-222222222222', NULL, 'f1111111-1111-1111-1111-111111111111', 'Bacon Burger', 'Topped with crispy bacon', 11.99, TRUE, FALSE, 3),

  -- Sides
  ('b4444444-4444-4444-4444-444444444444', '22222222-2222-2222-2222-222222222222', NULL, 'f2222222-2222-2222-2222-222222222222', 'French Fries', 'Crispy golden fries', 3.99, TRUE, FALSE, 1),
  ('b5555555-5555-5555-5555-555555555555', '22222222-2222-2222-2222-222222222222', NULL, 'f2222222-2222-2222-2222-222222222222', 'Onion Rings', 'Beer-battered onion rings', 4.99, TRUE, FALSE, 2);

-- ============================================================================
-- MENU MODIFIERS
-- ============================================================================

-- Coffee size modifier
INSERT INTO menu_modifiers (item_id, name, type, required, min_selections, max_selections, options, display_order) VALUES
  ('a1111111-1111-1111-1111-111111111111', 'Size', 'single', TRUE, 1, 1,
   '[{"name": "Tall (12oz)", "price": 0}, {"name": "Grande (16oz)", "price": 0.50}, {"name": "Venti (20oz)", "price": 1.00}]'::jsonb, 1),
  ('a2222222-2222-2222-2222-222222222222', 'Size', 'single', TRUE, 1, 1,
   '[{"name": "Tall (12oz)", "price": 0}, {"name": "Grande (16oz)", "price": 0.50}, {"name": "Venti (20oz)", "price": 1.00}]'::jsonb, 1);

-- Coffee extras
INSERT INTO menu_modifiers (item_id, name, type, required, min_selections, max_selections, options, display_order) VALUES
  ('a2222222-2222-2222-2222-222222222222', 'Extras', 'multiple', FALSE, 0, 3,
   '[{"name": "Extra Shot", "price": 0.75}, {"name": "Whipped Cream", "price": 0.50}, {"name": "Caramel Drizzle", "price": 0.50}]'::jsonb, 2);

-- Burger extras
INSERT INTO menu_modifiers (item_id, name, type, required, min_selections, max_selections, options, display_order) VALUES
  ('b1111111-1111-1111-1111-111111111111', 'Add-ons', 'multiple', FALSE, 0, 5,
   '[{"name": "Extra Cheese", "price": 1.00}, {"name": "Bacon", "price": 1.50}, {"name": "Avocado", "price": 1.50}, {"name": "Egg", "price": 1.00}]'::jsonb, 1);

-- ============================================================================
-- INVENTORY
-- ============================================================================

INSERT INTO inventory (store_id, item_id, quantity, low_stock_threshold) VALUES
  -- Coffee & Co Gangnam desserts
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'a6666666-6666-6666-6666-666666666666', 10, 3),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'a7777777-7777-7777-7777-777777777777', 15, 5),

  -- Coffee & Co Hongdae desserts
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'a6666666-6666-6666-6666-666666666666', 8, 3),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'a7777777-7777-7777-7777-777777777777', 12, 5);

-- ============================================================================
-- PICKUP SLOTS
-- ============================================================================

-- Coffee & Co stores (every day, 30 min slots, 20 min lead time, 5 orders per slot)
INSERT INTO pickup_slots (store_id, day_of_week, slot_duration_minutes, lead_time_minutes, capacity_per_slot) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 0, 30, 20, 5), -- Sunday
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 1, 30, 20, 5), -- Monday
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 2, 30, 20, 5), -- Tuesday
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 3, 30, 20, 5), -- Wednesday
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 4, 30, 20, 5), -- Thursday
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 5, 30, 20, 5), -- Friday
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 6, 30, 20, 5), -- Saturday

  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 0, 30, 20, 5),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 1, 30, 20, 5),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 2, 30, 20, 5),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 3, 30, 20, 5),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 4, 30, 20, 5),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 5, 30, 20, 5),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 6, 30, 20, 5);

-- Burger House (15 min slots, 15 min lead time, 8 orders per slot)
INSERT INTO pickup_slots (store_id, day_of_week, slot_duration_minutes, lead_time_minutes, capacity_per_slot) VALUES
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 0, 15, 15, 8),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 1, 15, 15, 8),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 2, 15, 15, 8),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 3, 15, 15, 8),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 4, 15, 15, 8),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 5, 15, 15, 8),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 6, 15, 15, 8);

-- ============================================================================
-- APP CONFIGS
-- ============================================================================

INSERT INTO app_configs (brand_id, app_name, primary_color, feature_toggles, build_version) VALUES
  ('11111111-1111-1111-1111-111111111111', 'Coffee & Co', '#8B4513',
   '{"loyalty": true, "promotions": true, "multi_language": true}'::jsonb, '1.0.0'),

  ('22222222-2222-2222-2222-222222222222', 'Burger House', '#DC2626',
   '{"loyalty": true, "promotions": true, "multi_language": false}'::jsonb, '1.0.0');

-- ============================================================================
-- PROMOTIONS
-- ============================================================================

INSERT INTO promotions (brand_id, store_ids, name, description, type, discount_value, conditions, valid_from, valid_to, active) VALUES
  ('11111111-1111-1111-1111-111111111111', '{}', 'Happy Hour', '20% off all drinks 2-4pm', 'percentage_discount', 20,
   '{"time_range": {"start": "14:00", "end": "16:00"}}'::jsonb,
   NOW() - INTERVAL '1 day', NOW() + INTERVAL '30 days', TRUE),

  ('22222222-2222-2222-2222-222222222222', '{}', 'Free Fries Friday', 'Free fries with any burger on Fridays', 'buy_x_get_y', 0,
   '{"day_of_week": 5, "buy_items": ["burger"], "get_items": ["fries"]}'::jsonb,
   NOW() - INTERVAL '1 day', NOW() + INTERVAL '90 days', TRUE);

-- ============================================================================
-- COUPONS
-- ============================================================================

INSERT INTO coupons (brand_id, customer_id, code, type, value, min_order_value, expires_at) VALUES
  ('11111111-1111-1111-1111-111111111111', 'd1111111-1111-1111-1111-111111111111', 'WELCOME10', 'percentage', 10, 10.00, NOW() + INTERVAL '30 days'),
  ('11111111-1111-1111-1111-111111111111', 'd2222222-2222-2222-2222-222222222222', 'COFFEE5', 'fixed_amount', 5, 15.00, NOW() + INTERVAL '30 days'),
  ('22222222-2222-2222-2222-222222222222', NULL, 'BURGER2024', 'fixed_amount', 3, 20.00, NOW() + INTERVAL '60 days'); -- Public coupon

-- ============================================================================
-- SAMPLE ORDERS (for testing)
-- ============================================================================

INSERT INTO orders (
  id, brand_id, store_id, customer_id, items, subtotal, tax, total,
  pickup_window_start, pickup_window_end, status, payment_method, payment_status,
  customer_name, customer_phone, guest_token
) VALUES
  -- Completed order
  ('c1111111-1111-1111-1111-111111111111', '11111111-1111-1111-1111-111111111111',
   'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'd1111111-1111-1111-1111-111111111111',
   '[{"item_id": "a2222222-2222-2222-2222-222222222222", "name": "Latte", "quantity": 2, "price": 5.00, "modifiers": [{"name": "Size", "option": "Grande (16oz)", "price": 0.50}]}]'::jsonb,
   11.00, 1.10, 12.10,
   NOW() - INTERVAL '2 hours', NOW() - INTERVAL '1 hour 30 minutes',
   'completed', 'toss', 'captured',
   '김철수', '+821012345678', NULL),

  -- Active order (waiting)
  ('c2222222-2222-2222-2222-222222222222', '22222222-2222-2222-2222-222222222222',
   'cccccccc-cccc-cccc-cccc-cccccccccccc', NULL,
   '[{"item_id": "b1111111-1111-1111-1111-111111111111", "name": "Classic Burger", "quantity": 1, "price": 9.99}, {"item_id": "b4444444-4444-4444-4444-444444444444", "name": "French Fries", "quantity": 1, "price": 3.99}]'::jsonb,
   13.98, 1.40, 15.38,
   NOW() + INTERVAL '30 minutes', NOW() + INTERVAL '1 hour',
   'waiting', 'kakaopay', 'captured',
   '이영희', '+821098765432', 'seed-guest-token');

-- ============================================================================
-- SUMMARY
-- ============================================================================

-- Display summary
DO $$
BEGIN
  RAISE NOTICE '✅ Seed data created successfully!';
  RAISE NOTICE '';
  RAISE NOTICE 'Summary:';
  RAISE NOTICE '  - Brands: %', (SELECT COUNT(*) FROM brands);
  RAISE NOTICE '  - Stores: %', (SELECT COUNT(*) FROM stores);
  RAISE NOTICE '  - Staff: %', (SELECT COUNT(*) FROM staff);
  RAISE NOTICE '  - Customers: %', (SELECT COUNT(*) FROM customers);
  RAISE NOTICE '  - Menu Categories: %', (SELECT COUNT(*) FROM menu_categories);
  RAISE NOTICE '  - Menu Items: %', (SELECT COUNT(*) FROM menu_items);
  RAISE NOTICE '  - Menu Modifiers: %', (SELECT COUNT(*) FROM menu_modifiers);
  RAISE NOTICE '  - Inventory: %', (SELECT COUNT(*) FROM inventory);
  RAISE NOTICE '  - Pickup Slots: %', (SELECT COUNT(*) FROM pickup_slots);
  RAISE NOTICE '  - App Configs: %', (SELECT COUNT(*) FROM app_configs);
  RAISE NOTICE '  - Promotions: %', (SELECT COUNT(*) FROM promotions);
  RAISE NOTICE '  - Coupons: %', (SELECT COUNT(*) FROM coupons);
  RAISE NOTICE '  - Orders: %', (SELECT COUNT(*) FROM orders);
  RAISE NOTICE '';
  RAISE NOTICE '⚠️  Note: Staff and Customer user_ids are placeholders.';
  RAISE NOTICE '   Create actual users via Supabase Auth and update these records.';
END $$;

