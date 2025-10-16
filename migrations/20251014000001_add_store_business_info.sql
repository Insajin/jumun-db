-- Add business information fields to stores table
-- Migration: 20251014000001_add_store_business_info

-- ============================================================================
-- ADD BUSINESS TYPE ENUM
-- ============================================================================

CREATE TYPE business_type AS ENUM ('individual', 'corporation');

-- ============================================================================
-- ADD NEW COLUMNS TO STORES TABLE
-- ============================================================================

ALTER TABLE stores

-- 사업자 등록 정보
ADD COLUMN business_registration_number TEXT,  -- 사업자등록번호 (123-45-67890)
ADD COLUMN business_owner_name TEXT,           -- 대표자명
ADD COLUMN business_name TEXT,                 -- 상호명/법인명
ADD COLUMN business_type business_type,        -- 개인사업자/법인사업자
ADD COLUMN opening_date DATE,                  -- 개업일
ADD COLUMN business_category TEXT,             -- 업태 (예: 소매업, 음식점업)
ADD COLUMN business_sector TEXT,               -- 업종 (예: 커피전문점, 편의점)

-- 연락처 정보
ADD COLUMN email TEXT,                         -- 이메일
ADD COLUMN fax TEXT,                           -- 팩스번호
ADD COLUMN manager_name TEXT,                  -- 점주/매니저명
ADD COLUMN manager_phone TEXT,                 -- 점주 연락처
ADD COLUMN emergency_contact TEXT,             -- 비상연락처

-- 금융/정산 정보 (JSONB로 저장)
-- Example: {"bank_name": "KB국민은행", "account_number": "123456-78-901234", "account_holder": "홍길동"}
ADD COLUMN bank_account JSONB DEFAULT '{}'::jsonb,

-- 세금계산서 정보 (JSONB로 저장)
-- Example: {"contact_name": "김철수", "contact_email": "tax@example.com", "contact_phone": "010-1234-5678"}
ADD COLUMN tax_invoice_info JSONB DEFAULT '{}'::jsonb,

-- 추가 운영 정보
ADD COLUMN seating_capacity INTEGER,           -- 좌석 수
ADD COLUMN parking_available BOOLEAN DEFAULT FALSE,  -- 주차 가능 여부
ADD COLUMN parking_info TEXT,                  -- 주차 정보 (예: "건물 지하 1층, 2시간 무료")
ADD COLUMN delivery_available BOOLEAN DEFAULT FALSE, -- 배달 가능 여부
ADD COLUMN delivery_radius_km NUMERIC(5,2),    -- 배달 반경 (km)
ADD COLUMN store_images TEXT[] DEFAULT ARRAY[]::TEXT[],  -- 매장 이미지 URLs
ADD COLUMN description TEXT,                   -- 매장 소개
ADD COLUMN features TEXT[] DEFAULT ARRAY[]::TEXT[];  -- 매장 특징 (와이파이, 테라스, 반려동물 등)

-- ============================================================================
-- ADD CONSTRAINTS
-- ============================================================================

-- 사업자등록번호 형식 제약 (123-45-67890)
ALTER TABLE stores
ADD CONSTRAINT stores_business_registration_format
CHECK (
    business_registration_number IS NULL OR
    business_registration_number ~ '^\d{3}-\d{2}-\d{5}$'
);

-- 이메일 형식 제약
ALTER TABLE stores
ADD CONSTRAINT stores_email_format
CHECK (
    email IS NULL OR
    email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$'
);

-- 좌석 수 양수 제약
ALTER TABLE stores
ADD CONSTRAINT stores_seating_capacity_positive
CHECK (seating_capacity IS NULL OR seating_capacity > 0);

-- 배달 반경 양수 제약
ALTER TABLE stores
ADD CONSTRAINT stores_delivery_radius_positive
CHECK (delivery_radius_km IS NULL OR delivery_radius_km > 0);

-- ============================================================================
-- ADD INDEXES
-- ============================================================================

CREATE INDEX idx_stores_business_registration ON stores(business_registration_number)
WHERE business_registration_number IS NOT NULL;

CREATE INDEX idx_stores_email ON stores(email)
WHERE email IS NOT NULL;

CREATE INDEX idx_stores_manager_name ON stores(manager_name)
WHERE manager_name IS NOT NULL;

-- ============================================================================
-- ADD COMMENTS
-- ============================================================================

COMMENT ON COLUMN stores.business_registration_number IS '사업자등록번호 (123-45-67890 형식)';
COMMENT ON COLUMN stores.business_owner_name IS '대표자명';
COMMENT ON COLUMN stores.business_name IS '상호명 또는 법인명';
COMMENT ON COLUMN stores.business_type IS '사업자 유형: individual(개인) 또는 corporation(법인)';
COMMENT ON COLUMN stores.opening_date IS '개업일';
COMMENT ON COLUMN stores.business_category IS '업태 (예: 소매업, 음식점업)';
COMMENT ON COLUMN stores.business_sector IS '업종 (예: 커피전문점, 편의점)';
COMMENT ON COLUMN stores.email IS '매장 이메일 주소';
COMMENT ON COLUMN stores.fax IS '팩스번호';
COMMENT ON COLUMN stores.manager_name IS '점주 또는 매니저 이름';
COMMENT ON COLUMN stores.manager_phone IS '점주 연락처';
COMMENT ON COLUMN stores.emergency_contact IS '비상연락처';
COMMENT ON COLUMN stores.bank_account IS '정산 계좌 정보 (JSONB: bank_name, account_number, account_holder)';
COMMENT ON COLUMN stores.tax_invoice_info IS '세금계산서 담당자 정보 (JSONB: contact_name, contact_email, contact_phone)';
COMMENT ON COLUMN stores.seating_capacity IS '좌석 수';
COMMENT ON COLUMN stores.parking_available IS '주차 가능 여부';
COMMENT ON COLUMN stores.parking_info IS '주차 정보 상세 설명';
COMMENT ON COLUMN stores.delivery_available IS '배달 서비스 제공 여부';
COMMENT ON COLUMN stores.delivery_radius_km IS '배달 가능 반경 (킬로미터)';
COMMENT ON COLUMN stores.store_images IS '매장 이미지 URL 배열';
COMMENT ON COLUMN stores.description IS '매장 소개 또는 설명';
COMMENT ON COLUMN stores.features IS '매장 특징 태그 (예: 와이파이, 테라스, 반려동물 동반)';
