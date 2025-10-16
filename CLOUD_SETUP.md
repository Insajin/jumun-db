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

### 2단계: SQL 스크립트 실행

**추천: `init-cloud-db-complete.sql` 사용** ⭐⭐⭐

이 스크립트는 모든 테이블 + 실제 테스트 가능한 완전한 시드 데이터를 포함합니다.

1. `supabase/init-cloud-db-complete.sql` 파일 열기
2. 전체 내용 복사 (Cmd+A, Cmd+C)
3. SQL Editor에 붙여넣기 (Cmd+V)
4. **Run** 버튼 클릭 (또는 Cmd+Enter)

**대안: 기본 설정만 필요한 경우**
- `init-cloud-db-simple.sql` - 브랜드와 앱 설정만 생성

### 3단계: 실행 확인

스크립트가 성공적으로 실행되면 하단에 결과가 표시됩니다:

**Complete 스크립트 실행 시:**
```
| section | item             | count |
|---------|------------------|-------|
| Summary | App Configs      | 4     |
| Summary | Brands           | 4     |
| Summary | Customers        | 3     |
| Summary | Menu Categories  | 7     |
| Summary | Menu Items       | 16    |
| Summary | Menu Modifiers   | 5     |
| Summary | Orders           | 2     |
| Summary | Stores           | 5     |

✅ Complete database setup finished!
```

**Simple 스크립트 실행 시:**
```
| table_name    | row_count |
|---------------|-----------|
| Brands        | 4         |
| App Configs   | 4         |
| Subscriptions | 4         |
```

✅ 데이터베이스 설정 완료!

---

## 📊 생성된 테이블

### 핵심 테이블
- **brands** - 브랜드/테넌트 정보
- **app_configs** - 브랜드별 화이트 라벨 앱 설정
- **app_builds** - 앱 빌드 히스토리
- **stores** - 매장 정보
- **staff** - 직원 정보
- **customers** - 고객 정보
- **subscriptions** - 구독 플랜

### 기본 시드 데이터

#### 브랜드 (4개)
- **Jumun** - 기본 브랜드 (#6366F1 인디고)
- **스타벅스** - 프로페셔널 플랜 (#00704A 그린)
- **투썸플레이스** - 베이직 플랜 (#E94B3C 레드)
- **메가커피** - 트라이얼 플랜 (#FFB81C 옐로우)

#### 매장 (5개)
- Jumun 테스트 매장 (강남)
- 스타벅스 강남점, 홍대점
- 투썸플레이스 역삼점
- 메가커피 신촌점

#### 메뉴 (16개 메뉴 아이템)
**스타벅스:**
- 커피: 아메리카노, 카페 라떼, 카푸치노, 카라멜 마키아또
- 논커피: 자몽 허니 블랙 티, 딸기 요거트 블렌디드
- 푸드: 뉴욕 치즈케이크, BLT 샌드위치

**투썸플레이스:**
- 커피: 아메리카노, 카페 라떼
- 케이크: 티라미수, 초코 생크림

**메가커피:**
- 커피: 메가 아메리카노, 메가 라떼
- 에이드: 레몬, 자몽

#### 고객 (3명)
- 김테스트 (1,000 포인트)
- 이고객 (500 포인트)
- 박주문 (2,500 포인트)

#### 샘플 주문 (2건)
- 완료된 주문: 스타벅스 아메리카노 x2
- 진행 중인 주문: 카페 라떼 + 치즈케이크

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
- ✅ 4개 브랜드 표시 (Jumun, 스타벅스, 투썸플레이스, 메가커피)
- ✅ 브랜드 선택 시 테마 색상 변경
- ✅ 브랜드 이름이 앱 타이틀에 표시

### 3. 매장 및 메뉴 확인

SQL Editor에서 실행:
```sql
-- 스타벅스 매장 조회
SELECT name, address, phone FROM stores
WHERE brand_id = '00000000-0000-0000-0000-000000000002';

-- 스타벅스 메뉴 조회
SELECT
    mc.name as category,
    mi.name as item,
    mi.price
FROM menu_items mi
JOIN menu_categories mc ON mi.category_id = mc.id
WHERE mi.brand_id = '00000000-0000-0000-0000-000000000002'
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
