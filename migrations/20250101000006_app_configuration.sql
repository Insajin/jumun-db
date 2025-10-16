-- App configuration: app_configs, app_builds
-- Migration: 20250101000006_app_configuration

-- ============================================================================
-- ENUMS
-- ============================================================================

-- Build platform
CREATE TYPE build_platform AS ENUM ('ios', 'android');

-- Build status
CREATE TYPE build_status AS ENUM ('in_progress', 'completed', 'failed');

-- ============================================================================
-- APP_CONFIGS TABLE
-- ============================================================================

CREATE TABLE app_configs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE UNIQUE,

    -- App branding
    app_name TEXT NOT NULL,
    logo_url TEXT,
    splash_screen_url TEXT,
    app_icon_url TEXT,
    primary_color TEXT NOT NULL DEFAULT '#6366F1',  -- Hex color

    -- Feature toggles (JSONB)
    -- Example: {"loyalty": true, "promotions": true, "multi_language": false}
    feature_toggles JSONB NOT NULL DEFAULT '{}',

    -- Current build version
    build_version TEXT,

    -- Publication
    published_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT app_configs_app_name_not_empty CHECK (length(trim(app_name)) > 0),
    CONSTRAINT app_configs_primary_color_valid CHECK (primary_color ~ '^#[0-9A-Fa-f]{6}$')
);

CREATE INDEX idx_app_configs_brand_id ON app_configs(brand_id);

COMMENT ON TABLE app_configs IS 'White-label app configuration per brand';
COMMENT ON COLUMN app_configs.feature_toggles IS 'Enabled/disabled features (JSONB)';
COMMENT ON COLUMN app_configs.primary_color IS 'Brand primary color (hex format)';

-- ============================================================================
-- APP_BUILDS TABLE
-- ============================================================================

CREATE TABLE app_builds (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    app_config_id UUID NOT NULL REFERENCES app_configs(id) ON DELETE CASCADE,
    platform build_platform NOT NULL,
    status build_status NOT NULL DEFAULT 'in_progress',
    build_number TEXT,
    download_url TEXT,
    error_message TEXT,
    started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMPTZ,

    CONSTRAINT app_builds_completed_has_download CHECK (
        status != 'completed' OR download_url IS NOT NULL
    )
);

CREATE INDEX idx_app_builds_app_config_id ON app_builds(app_config_id);
CREATE INDEX idx_app_builds_platform ON app_builds(platform);
CREATE INDEX idx_app_builds_status ON app_builds(status);
CREATE INDEX idx_app_builds_started_at ON app_builds(started_at DESC);

COMMENT ON TABLE app_builds IS 'App build pipeline tracking (iOS/Android)';
COMMENT ON COLUMN app_builds.download_url IS 'URL to download built app (APK/IPA)';

-- ============================================================================
-- ENABLE ROW LEVEL SECURITY
-- ============================================================================

ALTER TABLE app_configs ENABLE ROW LEVEL SECURITY;
ALTER TABLE app_builds ENABLE ROW LEVEL SECURITY;
