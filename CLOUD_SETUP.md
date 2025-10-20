# Supabase Cloud 데이터베이스 설정 가이드

## 📋 개요

이 가이드는 클라우드 Supabase 인스턴스에 Jumun 앱의 데이터베이스 스키마를 설정하는 방법을 안내합니다.

**프로젝트 정보:**
- Project ID: `vbwwglhplxmcquiqrqak`
- URL: `https://vbwwglhplxmcquiqrqak.supabase.co`
- Publishable Key: `sb_publishable_P_8fay0j5nDFrr4zd7ayAg_xjRfJJmk`

---

## 🚀 빠른 시작 (5분)

### 1단계: Supabase 대시보드 접속

1. [Supabase Dashboard](https://supabase.com/dashboard/project/vbwwglhplxmcquiqrqak)에 로그인
2. 왼쪽 메뉴에서 **SQL Editor** 클릭
3. **New Query** 버튼 클릭

### 2단계: 스키마 동기화 (필수)

1. `jumun-db/init-cloud-db.sql` 파일을 엽니다.
2. 전체 내용을 복사하여 SQL Editor에 붙여넣습니다.
3. **Run** (또는 `Cmd+Enter`)로 실행합니다.

> ℹ️ `init-cloud-db.sql`은 `supabase/migrations` 폴더를 순서대로 이어 붙여 자동 생성됩니다.  
> 로컬 Supabase CLI에서 사용하는 스키마와 100% 동일합니다.

### 3단계: 샘플 데이터 선택 (선택)

- `jumun-db/init-cloud-db-simple.sql`  
  : 최소한의 브랜드/스토어/앱 설정을 채웁니다. 빠른 연동 테스트용.
- `jumun-db/init-cloud-db-complete.sql`  
  : 로컬 `seed/seed.sql`과 동일한 풀 샘플 데이터를 추가합니다. 실행 전 테이블을 `TRUNCATE`하므로 초기화 용도로 사용하세요.

사용 방법은 스키마 스크립트와 동일합니다. 필요한 스크립트를 열어 복사 → 붙여넣기 → 실행하면 됩니다.

### 4단계: 실행 확인

아래 쿼리로 주요 테이블이 생성/채워졌는지 확인하세요:

```sql
SELECT COUNT(*) AS brands     FROM brands;
SELECT COUNT(*) AS stores     FROM stores;
SELECT COUNT(*) AS menu_items FROM menu_items;
SELECT COUNT(*) AS customers  FROM customers;
```

`init-cloud-db-complete.sql` 실행 후에는 브랜드 2개, 매장 3곳, 메뉴 아이템 12개, 고객 2명이 반환됩니다.

---

## 📊 생성된 테이블

### 핵심 도메인
- **brands / subscriptions / stores / staff / customers**  
  멀티 테넌트 구조, 스토어별 직원/고객 관리, 브랜드별 RLS 정책 적용
- **menu_categories / menu_items / menu_modifiers / inventory**  
  브랜드·스토어 단위 메뉴 구성과 옵션, 재고 관리
- **orders / order_status_history / refunds / pickup_slots / pickup_reservations**  
  주문 흐름(결제·픽업·취소) 및 예약 슬롯 관리
- **app_configs / app_builds**  
  화이트 라벨 앱 설정 및 빌드 추적
- **promotions / coupons / loyalty_transactions / stamp_cards**  
  프로모션, 쿠폰, 포인트·스탬프 적립 로직
- **notifications / notification_templates / push_tokens / promotion_banners / customer_segments**  
  마케팅·푸시 알림 채널
- **ab_tests / ab_test_variants / ab_test_exposures / ab_test_conversions**  
  실험/AB 테스트 관리용 테이블

### 기본 시드 데이터 (`init-cloud-db-complete.sql`)

- **브랜드 2개**  
  - Coffee & Co (인디고 테마)  
  - Burger House (레드 테마)
- **매장 3곳**  
  - Coffee & Co Gangnam / Hongdae  
  - Burger House Itaewon
- **고객 2명**  
  - Coffee & Co 전용 고객 1명  
  - Burger House 전용 고객 1명
- **메뉴/옵션**  
  - 커피 브랜드용 대분류·소분류 5개, 음료/디저트 8개, 옵션 3세트  
  - 버거 브랜드용 카테고리 3개, 메뉴 5개, 옵션 1세트
- **주문 샘플 2건**  
  - 완료된 커피 주문 1건, 진행 중인 버거 주문 1건
- **앱 설정 2개 + 프로모션/쿠폰 샘플 데이터**

---

## 🔒 보안 설정 (RLS)

모든 테이블에 **Row Level Security (RLS)**가 활성화되어 있습니다:

### 읽기 권한
- ✅ **brands**, **app_configs**, **stores**: 인증된 사용자 + 익명 사용자
- ✅ **customers**: 본인 데이터만 조회
- ✅ **staff**: 소속 매장 정보만 조회

### 쓰기 권한
- ✅ **app_configs**: 브랜드 관리자만 수정 가능
- ✅ **customers**: 본인 프로필만 수정 가능

---

## 🧪 테스트 방법

### 1. 테이블 조회 (SQL Editor)

```sql
-- 브랜드 목록 확인
SELECT id, name, slug FROM brands;

-- 앱 설정 확인
SELECT
    ac.app_name,
    ac.primary_color,
    ac.feature_toggles,
    b.name as brand_name
FROM app_configs ac
JOIN brands b ON ac.brand_id = b.id;
```

### 2. Flutter 앱에서 확인

1. Flutter 앱 재시작 (이미 실행 중)
2. 브라우저에서 `http://localhost:8888` 접속
3. 홈 화면에서 **"브랜드 변경 (개발용)"** 링크 클릭
4. 브랜드 목록이 로딩되는지 확인

**예상 결과:**
- ✅ 2개 브랜드 표시 (Coffee & Co, Burger House)
- ✅ 브랜드 선택 시 테마 색상 변경
- ✅ 브랜드 이름이 앱 타이틀에 표시

### 3. 매장 및 메뉴 확인

SQL Editor에서 실행:
```sql
-- Coffee & Co 매장 조회
SELECT name, address, phone FROM stores
WHERE brand_id = '11111111-1111-1111-1111-111111111111';

-- Coffee & Co 메뉴 조회
SELECT
    mc.name as category,
    mi.name as item,
    mi.price
FROM menu_items mi
JOIN menu_categories mc ON mi.category_id = mc.id
WHERE mi.brand_id = '11111111-1111-1111-1111-111111111111'
ORDER BY mc.display_order, mi.display_order;

-- 주문 내역 조회
SELECT
    o.id,
    b.name as brand,
    s.name as store,
    o.customer_name,
    o.total,
    o.status
FROM orders o
JOIN brands b ON o.brand_id = b.id
JOIN stores s ON o.store_id = s.id
ORDER BY o.created_at DESC;
```

---

## 🔁 로컬 ↔ 클라우드 동기화

1. **로컬 동기화**
   ```bash
   supabase start          # 로컬 스택 실행
   supabase db reset       # (옵션) 전체 초기화 후 마이그레이션 적용
   ```
2. **클라우드에 최신 마이그레이션 반영**
   ```bash
   supabase link --project-ref <project-id>
   supabase db push        # supabase/migrations 를 그대로 업로드
   ```
3. **SQL 스크립트 재생성**
   ```bash
   ./scripts/generate-cloud-sql.sh
   ```
   위 스크립트는 `supabase/migrations`를 읽어 `init-cloud-db*.sql` 세 파일을 다시 만듭니다.  
   로컬/클라우드 스키마가 항상 동일하도록 변경 사항을 반영한 뒤 커밋하세요.

---

## 🔧 트러블슈팅

### 문제 1: "Permission denied for schema auth"

**원인**: Supabase Cloud에서 `auth` 스키마에 직접 함수를 생성할 권한이 없음

**해결**: ✅ `init-cloud-db-simple.sql` 스크립트를 사용하면 이 문제가 발생하지 않습니다.

### 문제 2: "Permission denied for table brands"

**원인**: RLS 정책이 제대로 적용되지 않음

**해결**:
```sql
-- RLS 재적용
ALTER TABLE brands ENABLE ROW LEVEL SECURITY;

-- 정책 확인
SELECT * FROM pg_policies WHERE tablename = 'brands';
```

### 문제 3: "Extension postgis does not exist"

**원인**: PostGIS 확장이 설치되지 않음 (선택사항 - 위치 기반 기능에만 필요)

**해결**: 현재는 불필요합니다. 나중에 매장 위치 검색 기능을 추가할 때 활성화하면 됩니다.

### 문제 4: "Relation already exists"

**원인**: 테이블이 이미 존재함 (재실행 시)

**해결**: 정상입니다. `ON CONFLICT` 절이 중복을 방지합니다.

---

## 🎯 다음 단계

1. ✅ **데이터베이스 설정 완료**
2. 🔄 **Flutter 앱 테스트** - 브랜드 데이터 로딩 확인
3. 📱 **Admin Dashboard 연동** - App Builder 기능 테스트
4. 🚀 **GitHub Actions 설정** - 자동 빌드 파이프라인
5. 🧪 **E2E 테스트** - 전체 플로우 검증

---

## 📚 참고 자료

- [Supabase RLS 문서](https://supabase.com/docs/guides/auth/row-level-security)
- [PostgreSQL 확장](https://supabase.com/docs/guides/database/extensions)
- [Jumun 프로젝트 문서](../docs/)

---

**설정 일시**: 2025-10-01
**작성자**: Claude Code
**버전**: 1.0
