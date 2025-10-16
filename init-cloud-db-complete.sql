-- ============================================================================
-- Jumun - Complete Database Setup with Seed Data
-- ============================================================================
-- This script creates all tables and populates comprehensive test data
-- Suitable for Supabase Cloud SQL Editor
-- ============================================================================

-- ============================================================================
-- STEP 1: Enable Extensions
-- ============================================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================================
-- STEP 2: Create Enums
-- ============================================================================

DO $$ BEGIN CREATE TYPE subscription_plan AS ENUM ('trial', 'basic', 'professional', 'enterprise'); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE TYPE subscription_status AS ENUM ('active', 'expired', 'cancelled', 'grace_period'); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE TYPE store_status AS ENUM ('active', 'paused', 'offline', 'inactive'); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE TYPE staff_role AS ENUM ('store_staff', 'store_manager', 'brand_admin', 'super_admin'); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE TYPE build_platform AS ENUM ('ios', 'android'); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE TYPE build_status AS ENUM ('in_progress', 'completed', 'failed'); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE TYPE modifier_type AS ENUM ('single', 'multiple'); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE TYPE order_status AS ENUM ('pending', 'waiting', 'preparing', 'ready', 'completed', 'cancelled', 'payment_issue'); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE TYPE payment_method AS ENUM ('toss', 'kakaopay', 'naverpay', 'stripe', 'cash'); EXCEPTION WHEN duplicate_object THEN null; END $$;
DO $$ BEGIN CREATE TYPE payment_status AS ENUM ('pending', 'authorized', 'captured', 'failed', 'refunded', 'partially_refunded'); EXCEPTION WHEN duplicate_object THEN null; END $$;

-- ============================================================================
-- STEP 3: Create Core Tables
-- ============================================================================

CREATE TABLE IF NOT EXISTS brands (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    logo_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
    plan subscription_plan NOT NULL DEFAULT 'trial',
    status subscription_status NOT NULL DEFAULT 'active',
    expires_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(brand_id)
);

CREATE TABLE IF NOT EXISTS stores (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    slug TEXT NOT NULL,
    address TEXT,
    lat DOUBLE PRECISION,
    lng DOUBLE PRECISION,
    phone TEXT,
    status store_status NOT NULL DEFAULT 'active',
    accepting_orders BOOLEAN NOT NULL DEFAULT TRUE,
    operating_hours JSONB NOT NULL DEFAULT '{}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(brand_id, slug)
);

CREATE TABLE IF NOT EXISTS customers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    phone TEXT,
    full_name TEXT,
    loyalty_points INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS app_configs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
    app_name TEXT NOT NULL,
    logo_url TEXT,
    primary_color TEXT NOT NULL DEFAULT '#6366F1',
    feature_toggles JSONB NOT NULL DEFAULT '{}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(brand_id)
);

-- ============================================================================
-- STEP 4: Create Menu Tables
-- ============================================================================

CREATE TABLE IF NOT EXISTS menu_categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    display_order INTEGER NOT NULL DEFAULT 0,
    image_url TEXT,
    available BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS menu_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
    category_id UUID REFERENCES menu_categories(id) ON DELETE SET NULL,
    name TEXT NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    image_url TEXT,
    available BOOLEAN NOT NULL DEFAULT TRUE,
    display_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT menu_items_price_positive CHECK (price >= 0)
);

CREATE TABLE IF NOT EXISTS menu_modifiers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    item_id UUID NOT NULL REFERENCES menu_items(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    type modifier_type NOT NULL DEFAULT 'single',
    required BOOLEAN NOT NULL DEFAULT FALSE,
    options JSONB NOT NULL DEFAULT '[]',
    display_order INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS inventory (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
    item_id UUID NOT NULL REFERENCES menu_items(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL DEFAULT 0,
    UNIQUE(store_id, item_id)
);

-- ============================================================================
-- STEP 5: Create Order Tables
-- ============================================================================

CREATE TABLE IF NOT EXISTS orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
    store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    items JSONB NOT NULL DEFAULT '[]',
    subtotal DECIMAL(10,2) NOT NULL,
    tax DECIMAL(10,2) NOT NULL DEFAULT 0,
    total DECIMAL(10,2) NOT NULL,
    pickup_window_start TIMESTAMPTZ NOT NULL,
    pickup_window_end TIMESTAMPTZ NOT NULL,
    status order_status NOT NULL DEFAULT 'pending',
    payment_method payment_method,
    payment_status payment_status NOT NULL DEFAULT 'pending',
    customer_name TEXT,
    customer_phone TEXT,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS order_status_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    from_status order_status,
    to_status order_status NOT NULL,
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================================
-- STEP 6: Create Indexes
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_brands_slug ON brands(slug);
CREATE INDEX IF NOT EXISTS idx_stores_brand_id ON stores(brand_id);
CREATE INDEX IF NOT EXISTS idx_menu_categories_brand_id ON menu_categories(brand_id);
CREATE INDEX IF NOT EXISTS idx_menu_items_brand_id ON menu_items(brand_id);
CREATE INDEX IF NOT EXISTS idx_menu_items_category_id ON menu_items(category_id);
CREATE INDEX IF NOT EXISTS idx_orders_store_id ON orders(store_id);
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);

-- ============================================================================
-- STEP 7: Enable RLS with Public Access
-- ============================================================================

ALTER TABLE brands ENABLE ROW LEVEL SECURITY;
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE app_configs ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_modifiers ENABLE ROW LEVEL SECURITY;
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- Drop existing policies
DROP POLICY IF EXISTS "Public read brands" ON brands;
DROP POLICY IF EXISTS "Public read stores" ON stores;
DROP POLICY IF EXISTS "Public read app_configs" ON app_configs;
DROP POLICY IF EXISTS "Public read menu_categories" ON menu_categories;
DROP POLICY IF EXISTS "Public read menu_items" ON menu_items;
DROP POLICY IF EXISTS "Public read menu_modifiers" ON menu_modifiers;

-- Public read access (for mobile apps)
CREATE POLICY "Public read brands" ON brands FOR SELECT TO public USING (true);
CREATE POLICY "Public read stores" ON stores FOR SELECT TO public USING (status = 'active');
CREATE POLICY "Public read app_configs" ON app_configs FOR SELECT TO public USING (true);
CREATE POLICY "Public read menu_categories" ON menu_categories FOR SELECT TO public USING (available = true);
CREATE POLICY "Public read menu_items" ON menu_items FOR SELECT TO public USING (available = true);
CREATE POLICY "Public read menu_modifiers" ON menu_modifiers FOR SELECT TO public USING (true);

-- ============================================================================
-- STEP 7.5: Clean up existing seed data
-- ============================================================================

-- Delete existing test brands and all related data (CASCADE)
DELETE FROM brands
WHERE slug IN ('jumun', 'starbucks', 'twosome', 'mega-coffee');

-- ============================================================================
-- STEP 8: Insert Seed Data - Brands
-- ============================================================================

INSERT INTO brands (id, name, slug, logo_url) VALUES
    ('00000000-0000-0000-0000-000000000001', 'Jumun', 'jumun', NULL),
    ('00000000-0000-0000-0000-000000000002', '스타벅스', 'starbucks', 'https://upload.wikimedia.org/wikipedia/en/thumb/d/d3/Starbucks_Corporation_Logo_2011.svg/200px-Starbucks_Corporation_Logo_2011.svg.png'),
    ('00000000-0000-0000-0000-000000000003', '투썸플레이스', 'twosome', NULL),
    ('00000000-0000-0000-0000-000000000004', '메가커피', 'mega-coffee', NULL)
ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, logo_url = EXCLUDED.logo_url;

-- ============================================================================
-- STEP 9: Insert Seed Data - Subscriptions
-- ============================================================================

INSERT INTO subscriptions (brand_id, plan, status, expires_at) VALUES
    ('00000000-0000-0000-0000-000000000001', 'enterprise', 'active', NOW() + INTERVAL '1 year'),
    ('00000000-0000-0000-0000-000000000002', 'professional', 'active', NOW() + INTERVAL '1 year'),
    ('00000000-0000-0000-0000-000000000003', 'basic', 'active', NOW() + INTERVAL '6 months'),
    ('00000000-0000-0000-0000-000000000004', 'trial', 'active', NOW() + INTERVAL '30 days')
ON CONFLICT (brand_id) DO UPDATE SET plan = EXCLUDED.plan, status = EXCLUDED.status;

-- ============================================================================
-- STEP 10: Insert Seed Data - App Configs
-- ============================================================================

INSERT INTO app_configs (brand_id, app_name, primary_color, feature_toggles) VALUES
    ('00000000-0000-0000-0000-000000000001', 'Jumun', '#6366F1', '{"loyalty": true, "promotions": true, "qr_ordering": true}'::jsonb),
    ('00000000-0000-0000-0000-000000000002', '스타벅스', '#00704A', '{"loyalty": true, "promotions": true, "qr_ordering": true}'::jsonb),
    ('00000000-0000-0000-0000-000000000003', '투썸플레이스', '#E94B3C', '{"loyalty": true, "promotions": false, "qr_ordering": true}'::jsonb),
    ('00000000-0000-0000-0000-000000000004', '메가커피', '#FFB81C', '{"loyalty": false, "promotions": true, "qr_ordering": true}'::jsonb)
ON CONFLICT (brand_id) DO UPDATE SET app_name = EXCLUDED.app_name, primary_color = EXCLUDED.primary_color;

-- ============================================================================
-- STEP 11: Insert Seed Data - Stores
-- ============================================================================

INSERT INTO stores (id, brand_id, name, slug, address, lat, lng, phone, status) VALUES
    -- Jumun 테스트 매장
    ('10000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 'Jumun 테스트 매장', 'test-store', '서울시 강남구 테헤란로 123', 37.5012, 127.0396, '02-1234-5678', 'active'),

    -- 스타벅스 매장
    ('10000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000002', '스타벅스 강남점', 'gangnam', '서울시 강남구 강남대로 396', 37.4979, 127.0276, '02-2000-0001', 'active'),
    ('10000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000002', '스타벅스 홍대점', 'hongdae', '서울시 마포구 양화로 160', 37.5563, 126.9236, '02-2000-0002', 'active'),

    -- 투썸플레이스 매장
    ('10000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000003', '투썸플레이스 역삼점', 'yeoksam', '서울시 강남구 역삼로 123', 37.5001, 127.0364, '02-3000-0001', 'active'),

    -- 메가커피 매장
    ('10000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000004', '메가커피 신촌점', 'sinchon', '서울시 서대문구 신촌로 50', 37.5591, 126.9425, '02-4000-0001', 'active')
ON CONFLICT (brand_id, slug) DO UPDATE SET name = EXCLUDED.name, address = EXCLUDED.address;

-- ============================================================================
-- STEP 12: Insert Seed Data - Menu Categories
-- ============================================================================

-- 스타벅스 카테고리
INSERT INTO menu_categories (id, brand_id, name, description, display_order) VALUES
    ('20000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000002', '커피', '에스프레소 음료', 1),
    ('20000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000002', '논커피', '커피가 들어가지 않은 음료', 2),
    ('20000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000002', '푸드', '케이크 & 샌드위치', 3),

    -- 투썸플레이스 카테고리
    ('20000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000003', '커피', '시그니처 커피', 1),
    ('20000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000003', '케이크', '투썸 시그니처 케이크', 2),

    -- 메가커피 카테고리
    ('20000000-0000-0000-0000-000000000006', '00000000-0000-0000-0000-000000000004', '커피', '메가 커피 메뉴', 1),
    ('20000000-0000-0000-0000-000000000007', '00000000-0000-0000-0000-000000000004', '에이드', '상큼한 에이드', 2)
ON CONFLICT DO NOTHING;

-- ============================================================================
-- STEP 13: Insert Seed Data - Menu Items
-- ============================================================================

-- 스타벅스 메뉴
INSERT INTO menu_items (id, brand_id, category_id, name, description, price, display_order) VALUES
    -- 커피
    ('30000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000001', '아메리카노', '에스프레소에 물을 더한 커피', 4500, 1),
    ('30000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000001', '카페 라떼', '에스프레소와 스팀 우유', 5000, 2),
    ('30000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000001', '카푸치노', '풍부한 우유 거품', 5000, 3),
    ('30000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000001', '카라멜 마키아또', '카라멜 시럽과 에스프레소', 6000, 4),

    -- 논커피
    ('30000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000002', '자몽 허니 블랙 티', '상큼한 자몽과 홍차', 5500, 1),
    ('30000000-0000-0000-0000-000000000006', '00000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000002', '딸기 요거트 블렌디드', '딸기와 요거트', 6500, 2),

    -- 푸드
    ('30000000-0000-0000-0000-000000000007', '00000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000003', '뉴욕 치즈케이크', '부드러운 치즈케이크', 7000, 1),
    ('30000000-0000-0000-0000-000000000008', '00000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000003', 'BLT 샌드위치', '베이컨 레터스 토마토', 6500, 2),

    -- 투썸플레이스 메뉴
    ('30000000-0000-0000-0000-000000000009', '00000000-0000-0000-0000-000000000003', '20000000-0000-0000-0000-000000000004', '아메리카노', '클래식 아메리카노', 4000, 1),
    ('30000000-0000-0000-0000-000000000010', '00000000-0000-0000-0000-000000000003', '20000000-0000-0000-0000-000000000004', '카페 라떼', '부드러운 카페 라떼', 4500, 2),
    ('30000000-0000-0000-0000-000000000011', '00000000-0000-0000-0000-000000000003', '20000000-0000-0000-0000-000000000005', '티라미수 케이크', '시그니처 티라미수', 7500, 1),
    ('30000000-0000-0000-0000-000000000012', '00000000-0000-0000-0000-000000000003', '20000000-0000-0000-0000-000000000005', '초코 생크림 케이크', '진한 초콜릿 케이크', 8000, 2),

    -- 메가커피 메뉴
    ('30000000-0000-0000-0000-000000000013', '00000000-0000-0000-0000-000000000004', '20000000-0000-0000-0000-000000000006', '메가 아메리카노', '가성비 아메리카노', 2000, 1),
    ('30000000-0000-0000-0000-000000000014', '00000000-0000-0000-0000-000000000004', '20000000-0000-0000-0000-000000000006', '메가 라떼', '가성비 카페 라떼', 2500, 2),
    ('30000000-0000-0000-0000-000000000015', '00000000-0000-0000-0000-000000000004', '20000000-0000-0000-0000-000000000007', '레몬 에이드', '상큼한 레몬 에이드', 3000, 1),
    ('30000000-0000-0000-0000-000000000016', '00000000-0000-0000-0000-000000000004', '20000000-0000-0000-0000-000000000007', '자몽 에이드', '새콤달콤 자몽 에이드', 3500, 2)
ON CONFLICT DO NOTHING;

-- ============================================================================
-- STEP 14: Insert Seed Data - Menu Modifiers
-- ============================================================================

-- 커피 사이즈 옵션 (스타벅스)
INSERT INTO menu_modifiers (item_id, name, type, required, options, display_order) VALUES
    ('30000000-0000-0000-0000-000000000001', '사이즈', 'single', true,
     '[{"name": "Tall", "price": 0}, {"name": "Grande", "price": 500}, {"name": "Venti", "price": 1000}]'::jsonb, 1),
    ('30000000-0000-0000-0000-000000000002', '사이즈', 'single', true,
     '[{"name": "Tall", "price": 0}, {"name": "Grande", "price": 500}, {"name": "Venti", "price": 1000}]'::jsonb, 1),

    -- 온도 옵션
    ('30000000-0000-0000-0000-000000000001', '온도', 'single', true,
     '[{"name": "HOT", "price": 0}, {"name": "ICE", "price": 0}]'::jsonb, 2),
    ('30000000-0000-0000-0000-000000000002', '온도', 'single', true,
     '[{"name": "HOT", "price": 0}, {"name": "ICE", "price": 0}]'::jsonb, 2),

    -- 추가 옵션
    ('30000000-0000-0000-0000-000000000002', '추가 옵션', 'multiple', false,
     '[{"name": "샷 추가", "price": 500}, {"name": "휘핑크림", "price": 500}, {"name": "시럽 추가", "price": 500}]'::jsonb, 3)
ON CONFLICT DO NOTHING;

-- ============================================================================
-- STEP 15: Insert Seed Data - Customers
-- ============================================================================

INSERT INTO customers (id, phone, full_name, loyalty_points) VALUES
    ('40000000-0000-0000-0000-000000000001', '010-1234-5678', '김테스트', 1000),
    ('40000000-0000-0000-0000-000000000002', '010-9876-5432', '이고객', 500),
    ('40000000-0000-0000-0000-000000000003', '010-5555-6666', '박주문', 2500)
ON CONFLICT DO NOTHING;

-- ============================================================================
-- STEP 16: Insert Seed Data - Sample Orders
-- ============================================================================

-- 완료된 주문 예시
INSERT INTO orders (
    id, brand_id, store_id, customer_id,
    items, subtotal, tax, total,
    pickup_window_start, pickup_window_end,
    status, payment_method, payment_status,
    customer_name, customer_phone
) VALUES
    (
        '50000000-0000-0000-0000-000000000001',
        '00000000-0000-0000-0000-000000000002',  -- 스타벅스
        '10000000-0000-0000-0000-000000000002',  -- 강남점
        '40000000-0000-0000-0000-000000000001',  -- 김테스트
        '[{
            "item_id": "30000000-0000-0000-0000-000000000001",
            "name": "아메리카노",
            "quantity": 2,
            "price": 4500,
            "modifiers": [
                {"name": "사이즈", "option": "Grande", "price": 500},
                {"name": "온도", "option": "ICE", "price": 0}
            ]
        }]'::jsonb,
        10000, 1000, 11000,
        NOW() - INTERVAL '1 hour', NOW() - INTERVAL '30 minutes',
        'completed', 'toss', 'captured',
        '김테스트', '010-1234-5678'
    ),

    -- 진행 중인 주문 예시
    (
        '50000000-0000-0000-0000-000000000002',
        '00000000-0000-0000-0000-000000000002',  -- 스타벅스
        '10000000-0000-0000-0000-000000000002',  -- 강남점
        '40000000-0000-0000-0000-000000000002',  -- 이고객
        '[{
            "item_id": "30000000-0000-0000-0000-000000000002",
            "name": "카페 라떼",
            "quantity": 1,
            "price": 5000,
            "modifiers": [
                {"name": "사이즈", "option": "Tall", "price": 0},
                {"name": "온도", "option": "HOT", "price": 0}
            ]
        }, {
            "item_id": "30000000-0000-0000-0000-000000000007",
            "name": "뉴욕 치즈케이크",
            "quantity": 1,
            "price": 7000,
            "modifiers": []
        }]'::jsonb,
        12000, 1200, 13200,
        NOW() + INTERVAL '15 minutes', NOW() + INTERVAL '30 minutes',
        'preparing', 'kakaopay', 'captured',
        '이고객', '010-9876-5432'
    )
ON CONFLICT DO NOTHING;

-- ============================================================================
-- STEP 17: Verification Query
-- ============================================================================

SELECT
    'Summary' as section,
    'Brands' as item,
    count(*)::text as count
FROM brands
UNION ALL
SELECT 'Summary', 'Stores', count(*)::text FROM stores
UNION ALL
SELECT 'Summary', 'App Configs', count(*)::text FROM app_configs
UNION ALL
SELECT 'Summary', 'Menu Categories', count(*)::text FROM menu_categories
UNION ALL
SELECT 'Summary', 'Menu Items', count(*)::text FROM menu_items
UNION ALL
SELECT 'Summary', 'Menu Modifiers', count(*)::text FROM menu_modifiers
UNION ALL
SELECT 'Summary', 'Customers', count(*)::text FROM customers
UNION ALL
SELECT 'Summary', 'Orders', count(*)::text FROM orders
ORDER BY item;

-- Success message
SELECT '✅ Complete database setup finished!' as status;
