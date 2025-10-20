-- Phase 1: Admin Management Features
-- Migration: 20251016120000_phase1_admin_management_features
--
-- This migration adds tables and enhancements for:
-- 1. Promotion Banners (홈 화면 배너 관리)
-- 2. Enhanced Coupon Management (쿠폰 발행/배포 관리)
-- 3. Customer Segmentation (고객 세그먼테이션)
-- 4. Notification System (알림 관리)
-- 5. Recommended Menus Configuration (추천 메뉴 설정)

-- ============================================================================
-- 1. PROMOTION BANNERS TABLE
-- ============================================================================

CREATE TABLE promotion_banners (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,

    -- Banner content
    title TEXT NOT NULL,
    description TEXT,
    image_url TEXT NOT NULL,
    link_url TEXT,  -- Optional deep link

    -- Display settings
    display_order INTEGER NOT NULL DEFAULT 0,
    active BOOLEAN NOT NULL DEFAULT TRUE,

    -- Validity period
    valid_from TIMESTAMPTZ NOT NULL,
    valid_to TIMESTAMPTZ NOT NULL,

    -- Analytics
    view_count INTEGER NOT NULL DEFAULT 0,
    click_count INTEGER NOT NULL DEFAULT 0,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT promotion_banners_title_not_empty CHECK (length(trim(title)) > 0),
    CONSTRAINT promotion_banners_image_url_not_empty CHECK (length(trim(image_url)) > 0),
    CONSTRAINT promotion_banners_valid_dates CHECK (valid_from < valid_to),
    CONSTRAINT promotion_banners_display_order_non_negative CHECK (display_order >= 0)
);

CREATE INDEX idx_promotion_banners_brand_id ON promotion_banners(brand_id);
CREATE INDEX idx_promotion_banners_active ON promotion_banners(active, valid_from, valid_to);
CREATE INDEX idx_promotion_banners_display_order ON promotion_banners(brand_id, display_order);

COMMENT ON TABLE promotion_banners IS 'Promotional banners displayed on customer app home screen';
COMMENT ON COLUMN promotion_banners.display_order IS 'Lower number = higher priority in carousel';
COMMENT ON COLUMN promotion_banners.link_url IS 'Optional deep link for banner click action';

ALTER TABLE promotion_banners ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- 2. ENHANCED COUPON MANAGEMENT
-- ============================================================================

-- Add missing columns to existing coupons table
ALTER TABLE coupons
    ADD COLUMN IF NOT EXISTS max_discount DECIMAL(10,2),
    ADD COLUMN IF NOT EXISTS usage_limit INTEGER,
    ADD COLUMN IF NOT EXISTS usage_count INTEGER NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS per_customer_limit INTEGER DEFAULT 1,
    ADD COLUMN IF NOT EXISTS target_segment TEXT,
    ADD COLUMN IF NOT EXISTS issued_by UUID REFERENCES auth.users(id),
    ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT TRUE,
    ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW();

COMMENT ON COLUMN coupons.max_discount IS 'Maximum discount amount for percentage coupons';
COMMENT ON COLUMN coupons.usage_limit IS 'Total usage limit across all customers (NULL = unlimited)';
COMMENT ON COLUMN coupons.usage_count IS 'Current usage count';
COMMENT ON COLUMN coupons.per_customer_limit IS 'Usage limit per customer';
COMMENT ON COLUMN coupons.target_segment IS 'all | vip | new | custom_segment_id';
COMMENT ON COLUMN coupons.issued_by IS 'Admin user who created this coupon';

-- Coupon templates for bulk issuance
CREATE TABLE coupon_templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,

    -- Template details
    name TEXT NOT NULL,
    description TEXT,
    type coupon_type NOT NULL,
    value DECIMAL(10,2) NOT NULL,
    min_order_value DECIMAL(10,2),
    max_discount DECIMAL(10,2),

    -- Generation settings
    code_prefix TEXT NOT NULL,  -- e.g., 'SUMMER24-'
    quantity INTEGER NOT NULL,  -- Number of coupons to generate
    per_customer_limit INTEGER DEFAULT 1,

    -- Validity
    expires_at TIMESTAMPTZ NOT NULL,

    -- Targeting
    target_segment TEXT,

    -- Metadata
    created_by UUID NOT NULL REFERENCES auth.users(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT coupon_templates_name_not_empty CHECK (length(trim(name)) > 0),
    CONSTRAINT coupon_templates_quantity_positive CHECK (quantity > 0),
    CONSTRAINT coupon_templates_value_positive CHECK (value > 0)
);

CREATE INDEX idx_coupon_templates_brand_id ON coupon_templates(brand_id);

COMMENT ON TABLE coupon_templates IS 'Templates for bulk coupon generation';
COMMENT ON COLUMN coupon_templates.code_prefix IS 'Prefix for generated coupon codes';
COMMENT ON COLUMN coupon_templates.quantity IS 'Number of unique coupons to generate';

ALTER TABLE coupon_templates ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- 3. CUSTOMER SEGMENTATION
-- ============================================================================

CREATE TYPE segment_type AS ENUM ('auto', 'manual');

CREATE TABLE customer_segments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,

    -- Segment details
    name TEXT NOT NULL,
    description TEXT,
    type segment_type NOT NULL DEFAULT 'manual',

    -- Conditions for auto segments (JSONB)
    -- Example: [
    --   {"field": "order_count", "operator": ">", "value": 10},
    --   {"field": "total_spent", "operator": ">", "value": 100000}
    -- ]
    conditions JSONB,

    -- Manual segment customer IDs (for manual type)
    customer_ids UUID[],

    -- Cached count (updated via trigger)
    customer_count INTEGER NOT NULL DEFAULT 0,

    -- Metadata
    created_by UUID NOT NULL REFERENCES auth.users(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT customer_segments_name_not_empty CHECK (length(trim(name)) > 0),
    CONSTRAINT customer_segments_auto_has_conditions CHECK (
        type = 'manual' OR (type = 'auto' AND conditions IS NOT NULL)
    )
);

CREATE INDEX idx_customer_segments_brand_id ON customer_segments(brand_id);
CREATE INDEX idx_customer_segments_type ON customer_segments(type);

COMMENT ON TABLE customer_segments IS 'Customer groups for targeted marketing';
COMMENT ON COLUMN customer_segments.conditions IS 'Auto-segment criteria (JSONB array of conditions)';
COMMENT ON COLUMN customer_segments.customer_ids IS 'Manual list of customer UUIDs (for manual segments)';

ALTER TABLE customer_segments ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- 4. NOTIFICATION SYSTEM
-- ============================================================================

-- Use different names to avoid conflict with existing notification_type and notification_status
CREATE TYPE notification_category AS ENUM (
    'order_status',
    'promotion',
    'coupon',
    'loyalty',
    'system'
);

CREATE TYPE notification_target AS ENUM ('all', 'segment', 'individual');
CREATE TYPE notification_campaign_status AS ENUM ('draft', 'scheduled', 'sending', 'sent', 'failed');

CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,

    -- Notification content
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    image_url TEXT,
    link_url TEXT,  -- Deep link
    category notification_category NOT NULL,

    -- Targeting
    target notification_target NOT NULL,
    segment_id UUID REFERENCES customer_segments(id) ON DELETE SET NULL,
    customer_ids UUID[],  -- For individual targeting

    -- Scheduling
    scheduled_at TIMESTAMPTZ,  -- NULL = send immediately
    sent_at TIMESTAMPTZ,
    status notification_campaign_status NOT NULL DEFAULT 'draft',

    -- Statistics
    sent_count INTEGER NOT NULL DEFAULT 0,
    delivered_count INTEGER NOT NULL DEFAULT 0,
    opened_count INTEGER NOT NULL DEFAULT 0,
    clicked_count INTEGER NOT NULL DEFAULT 0,

    -- Metadata
    created_by UUID NOT NULL REFERENCES auth.users(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT notifications_title_not_empty CHECK (length(trim(title)) > 0),
    CONSTRAINT notifications_body_not_empty CHECK (length(trim(body)) > 0),
    CONSTRAINT notifications_segment_target_has_segment CHECK (
        target != 'segment' OR segment_id IS NOT NULL
    ),
    CONSTRAINT notifications_individual_target_has_customers CHECK (
        target != 'individual' OR customer_ids IS NOT NULL
    )
);

CREATE INDEX idx_notifications_brand_id ON notifications(brand_id);
CREATE INDEX idx_notifications_status ON notifications(status);
CREATE INDEX idx_notifications_scheduled_at ON notifications(scheduled_at) WHERE status = 'scheduled';

COMMENT ON TABLE notifications IS 'Push notifications sent to customers';
COMMENT ON COLUMN notifications.link_url IS 'Deep link for notification click action';
COMMENT ON COLUMN notifications.segment_id IS 'Target segment (for segment targeting)';
COMMENT ON COLUMN notifications.customer_ids IS 'Target customer UUIDs (for individual targeting)';

ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Notification templates
CREATE TABLE notification_templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,

    -- Template details
    name TEXT NOT NULL,
    title TEXT NOT NULL,
    body TEXT NOT NULL,  -- Supports variables: {{order_number}}, {{customer_name}}, etc.
    category notification_category NOT NULL,

    -- Metadata
    created_by UUID NOT NULL REFERENCES auth.users(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT notification_templates_name_not_empty CHECK (length(trim(name)) > 0)
);

CREATE INDEX idx_notification_templates_brand_id ON notification_templates(brand_id);
CREATE INDEX idx_notification_templates_category ON notification_templates(category);

COMMENT ON TABLE notification_templates IS 'Reusable notification templates';
COMMENT ON COLUMN notification_templates.body IS 'Template body with variable placeholders';

ALTER TABLE notification_templates ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- 5. RECOMMENDED MENUS CONFIGURATION
-- ============================================================================

CREATE TYPE recommendation_mode AS ENUM ('auto', 'manual', 'time_based');
CREATE TYPE auto_criteria AS ENUM ('popular', 'new', 'seasonal', 'random');

CREATE TABLE recommended_menu_configs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,

    -- Configuration
    mode recommendation_mode NOT NULL DEFAULT 'auto',
    auto_criteria auto_criteria DEFAULT 'popular',

    -- Manual selection (for manual mode)
    manual_item_ids UUID[],

    -- Time-based recommendations (JSONB)
    -- Example: {
    --   "breakfast": ["item_uuid1", "item_uuid2"],  // 06:00-11:00
    --   "lunch": ["item_uuid3", "item_uuid4"],      // 11:00-14:00
    --   "dinner": ["item_uuid5", "item_uuid6"]      // 17:00-21:00
    -- }
    time_based_items JSONB,

    -- Display settings
    max_items INTEGER NOT NULL DEFAULT 6,

    -- Metadata
    updated_by UUID NOT NULL REFERENCES auth.users(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- One config per brand
    CONSTRAINT recommended_menu_configs_unique_brand UNIQUE (brand_id),
    CONSTRAINT recommended_menu_configs_max_items_positive CHECK (max_items > 0)
);

CREATE INDEX idx_recommended_menu_configs_brand_id ON recommended_menu_configs(brand_id);

COMMENT ON TABLE recommended_menu_configs IS 'Configuration for recommended menu display on home screen';
COMMENT ON COLUMN recommended_menu_configs.mode IS 'Recommendation algorithm mode';
COMMENT ON COLUMN recommended_menu_configs.time_based_items IS 'Menu items by time of day (JSONB)';

ALTER TABLE recommended_menu_configs ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- 6. MENU ITEM ENHANCEMENTS
-- ============================================================================

-- Add tags and inventory to menu_items
ALTER TABLE menu_items
    ADD COLUMN IF NOT EXISTS tags TEXT[] DEFAULT '{}',
    ADD COLUMN IF NOT EXISTS inventory_quantity INTEGER,
    ADD COLUMN IF NOT EXISTS inventory_threshold INTEGER,
    ADD COLUMN IF NOT EXISTS auto_disable_on_zero BOOLEAN NOT NULL DEFAULT FALSE,
    ADD COLUMN IF NOT EXISTS display_on_home BOOLEAN NOT NULL DEFAULT FALSE;

CREATE INDEX idx_menu_items_tags ON menu_items USING GIN(tags);
CREATE INDEX idx_menu_items_display_on_home ON menu_items(display_on_home) WHERE display_on_home = TRUE;
CREATE INDEX idx_menu_items_inventory ON menu_items(inventory_quantity) WHERE inventory_tracked = TRUE;

COMMENT ON COLUMN menu_items.tags IS 'Tags for categorization: best, new, seasonal, spicy, vegan, etc.';
COMMENT ON COLUMN menu_items.inventory_quantity IS 'Current inventory (NULL = unlimited)';
COMMENT ON COLUMN menu_items.inventory_threshold IS 'Alert threshold for low inventory';
COMMENT ON COLUMN menu_items.auto_disable_on_zero IS 'Automatically set available=false when inventory reaches 0';
COMMENT ON COLUMN menu_items.display_on_home IS 'Display in home screen recommended section';

-- Menu scheduling
CREATE TABLE menu_schedules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    menu_item_id UUID NOT NULL REFERENCES menu_items(id) ON DELETE CASCADE,

    -- Time availability (JSONB)
    -- Example: [
    --   {"start": "06:00", "end": "11:00"},
    --   {"start": "17:00", "end": "21:00"}
    -- ]
    available_times JSONB,

    -- Day availability (0=Sunday, 6=Saturday)
    available_days INTEGER[] DEFAULT '{0,1,2,3,4,5,6}',

    -- Seasonal availability
    seasonal_start DATE,
    seasonal_end DATE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- One schedule per menu item
    CONSTRAINT menu_schedules_unique_item UNIQUE (menu_item_id)
);

CREATE INDEX idx_menu_schedules_menu_item_id ON menu_schedules(menu_item_id);

COMMENT ON TABLE menu_schedules IS 'Time-based menu item availability';
COMMENT ON COLUMN menu_schedules.available_times IS 'Time ranges when item is available (JSONB)';
COMMENT ON COLUMN menu_schedules.available_days IS 'Days of week when available (0=Sun, 6=Sat)';

ALTER TABLE menu_schedules ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- 7. ANALYTICS & TRACKING
-- ============================================================================

-- Track banner interactions
CREATE TABLE banner_interactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    banner_id UUID NOT NULL REFERENCES promotion_banners(id) ON DELETE CASCADE,
    customer_id UUID REFERENCES customers(id) ON DELETE SET NULL,

    -- Interaction type
    action TEXT NOT NULL,  -- 'view' | 'click'

    -- Context
    user_agent TEXT,
    ip_address INET,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT banner_interactions_action_valid CHECK (action IN ('view', 'click'))
);

CREATE INDEX idx_banner_interactions_banner_id ON banner_interactions(banner_id, created_at DESC);
CREATE INDEX idx_banner_interactions_customer_id ON banner_interactions(customer_id) WHERE customer_id IS NOT NULL;
CREATE INDEX idx_banner_interactions_created_at ON banner_interactions(created_at DESC);

COMMENT ON TABLE banner_interactions IS 'Track banner views and clicks for analytics';

ALTER TABLE banner_interactions ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- 8. FUNCTIONS & TRIGGERS
-- ============================================================================

-- Function: Auto-update banner view/click counts
CREATE OR REPLACE FUNCTION update_banner_stats()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.action = 'view' THEN
        UPDATE promotion_banners
        SET view_count = view_count + 1
        WHERE id = NEW.banner_id;
    ELSIF NEW.action = 'click' THEN
        UPDATE promotion_banners
        SET click_count = click_count + 1
        WHERE id = NEW.banner_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_banner_stats
    AFTER INSERT ON banner_interactions
    FOR EACH ROW
    EXECUTE FUNCTION update_banner_stats();

COMMENT ON FUNCTION update_banner_stats IS 'Auto-increment banner view/click counts';

-- Function: Auto-disable menu item when inventory reaches 0
CREATE OR REPLACE FUNCTION auto_disable_on_zero_inventory()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.auto_disable_on_zero = TRUE
       AND NEW.inventory_tracked = TRUE
       AND NEW.inventory_quantity IS NOT NULL
       AND NEW.inventory_quantity <= 0
       AND NEW.available = TRUE THEN

        NEW.available := FALSE;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_auto_disable_on_zero_inventory
    BEFORE UPDATE ON menu_items
    FOR EACH ROW
    EXECUTE FUNCTION auto_disable_on_zero_inventory();

COMMENT ON FUNCTION auto_disable_on_zero_inventory IS 'Auto-disable menu item when inventory reaches 0';

-- Function: Update coupon usage count
CREATE OR REPLACE FUNCTION increment_coupon_usage()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.used_at IS NOT NULL AND OLD.used_at IS NULL THEN
        UPDATE coupons
        SET usage_count = usage_count + 1
        WHERE id = NEW.id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_increment_coupon_usage
    AFTER UPDATE ON coupons
    FOR EACH ROW
    EXECUTE FUNCTION increment_coupon_usage();

COMMENT ON FUNCTION increment_coupon_usage IS 'Increment coupon usage count when coupon is used';

-- ============================================================================
-- 9. DEFAULT DATA
-- ============================================================================

-- Note: Default data seeding removed - these will be created by admins via UI
-- The created_by and updated_by fields require valid auth.users which may not exist during migration
