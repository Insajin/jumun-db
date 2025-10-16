-- App Builder RPC Functions
-- Migration: 20250101000011_app_builder_functions

-- ============================================================================
-- RPC: get_app_config
-- Get app configuration by ID for build pipeline
-- ============================================================================

CREATE OR REPLACE FUNCTION get_app_config(config_id UUID)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    result JSON;
BEGIN
    SELECT json_build_object(
        'id', ac.id,
        'brand_id', ac.brand_id,
        'app_name', ac.app_name,
        'logo_url', ac.logo_url,
        'primary_color', ac.primary_color,
        'feature_toggles', ac.feature_toggles,
        'build_version', ac.build_version
    )
    INTO result
    FROM app_configs ac
    WHERE ac.id = config_id;

    RETURN result;
END;
$$;

COMMENT ON FUNCTION get_app_config(UUID) IS 'Fetch app configuration for build pipeline';

-- ============================================================================
-- RPC: trigger_app_build
-- Trigger a new app build (to be called from Admin Dashboard)
-- ============================================================================

CREATE OR REPLACE FUNCTION trigger_app_build(
    p_app_config_id UUID,
    p_github_token TEXT DEFAULT NULL
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_brand_id UUID;
    v_app_name TEXT;
    result JSON;
BEGIN
    -- Get brand_id from app_config
    SELECT brand_id, app_name
    INTO v_brand_id, v_app_name
    FROM app_configs
    WHERE id = p_app_config_id;

    IF v_brand_id IS NULL THEN
        RAISE EXCEPTION 'App configuration not found';
    END IF;

    -- Return payload for GitHub repository dispatch
    result := json_build_object(
        'event_type', 'build_brand_app',
        'client_payload', json_build_object(
            'brand_id', v_brand_id,
            'app_config_id', p_app_config_id,
            'app_name', v_app_name
        )
    );

    RETURN result;
END;
$$;

COMMENT ON FUNCTION trigger_app_build(UUID, TEXT) IS 'Generate payload for GitHub repository dispatch to trigger app build';

-- ============================================================================
-- RPC: get_build_status
-- Get build status for an app configuration
-- ============================================================================

CREATE OR REPLACE FUNCTION get_build_status(p_app_config_id UUID)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    result JSON;
BEGIN
    SELECT json_agg(
        json_build_object(
            'id', ab.id,
            'platform', ab.platform,
            'status', ab.status,
            'build_number', ab.build_number,
            'download_url', ab.download_url,
            'error_message', ab.error_message,
            'started_at', ab.started_at,
            'completed_at', ab.completed_at
        )
        ORDER BY ab.started_at DESC
    )
    INTO result
    FROM app_builds ab
    WHERE ab.app_config_id = p_app_config_id;

    RETURN COALESCE(result, '[]'::json);
END;
$$;

COMMENT ON FUNCTION get_build_status(UUID) IS 'Get build status history for an app configuration';
