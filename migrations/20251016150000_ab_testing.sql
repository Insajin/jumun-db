-- A/B Testing for Banners and Coupons
-- Migration: 20251016150000_ab_testing

-- ============================================================================
-- AB_TESTS TABLE
-- ============================================================================
CREATE TABLE ab_tests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,

    -- Test metadata
    name TEXT NOT NULL,
    description TEXT,
    test_type TEXT NOT NULL CHECK (test_type IN ('banner', 'coupon', 'promotion')),

    -- Test status
    status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'running', 'paused', 'completed')),

    -- Test configuration
    traffic_split JSONB NOT NULL DEFAULT '{"variant_a": 50, "variant_b": 50}',
    -- Example: {"variant_a": 50, "variant_b": 50} means 50/50 split

    -- Target audience
    target_segment_id UUID REFERENCES customer_segments(id) ON DELETE SET NULL,
    -- If NULL, test runs for all customers

    -- Test period
    start_date TIMESTAMPTZ NOT NULL,
    end_date TIMESTAMPTZ,

    -- Winner selection
    winner_variant TEXT CHECK (winner_variant IN ('variant_a', 'variant_b', 'no_winner')),
    auto_select_winner BOOLEAN NOT NULL DEFAULT false,
    confidence_threshold DECIMAL(5, 2) DEFAULT 95.0,
    -- Auto-select winner when confidence reaches this threshold

    -- Metadata
    created_by UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_ab_tests_brand_id ON ab_tests(brand_id);
CREATE INDEX idx_ab_tests_status ON ab_tests(status);
CREATE INDEX idx_ab_tests_dates ON ab_tests(start_date, end_date);

COMMENT ON TABLE ab_tests IS 'A/B test configurations';
COMMENT ON COLUMN ab_tests.traffic_split IS 'Percentage split between variants (JSONB)';
COMMENT ON COLUMN ab_tests.confidence_threshold IS 'Minimum confidence level to auto-select winner';

-- ============================================================================
-- AB_TEST_VARIANTS TABLE
-- ============================================================================
CREATE TABLE ab_test_variants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    test_id UUID NOT NULL REFERENCES ab_tests(id) ON DELETE CASCADE,

    -- Variant info
    variant_key TEXT NOT NULL CHECK (variant_key IN ('variant_a', 'variant_b')),

    -- Reference to actual content
    banner_id UUID REFERENCES promotion_banners(id) ON DELETE CASCADE,
    coupon_template_id UUID REFERENCES coupon_templates(id) ON DELETE CASCADE,

    -- Ensure only one content type is set
    CONSTRAINT ab_test_variants_content_check CHECK (
        (banner_id IS NOT NULL AND coupon_template_id IS NULL) OR
        (banner_id IS NULL AND coupon_template_id IS NOT NULL)
    ),

    -- Metadata
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    UNIQUE(test_id, variant_key)
);

CREATE INDEX idx_ab_test_variants_test_id ON ab_test_variants(test_id);

COMMENT ON TABLE ab_test_variants IS 'A/B test variant configurations (links to actual content)';

-- ============================================================================
-- AB_TEST_EXPOSURES TABLE
-- ============================================================================
CREATE TABLE ab_test_exposures (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    test_id UUID NOT NULL REFERENCES ab_tests(id) ON DELETE CASCADE,
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,

    -- Which variant was shown
    variant_key TEXT NOT NULL CHECK (variant_key IN ('variant_a', 'variant_b')),

    -- Exposure metadata
    exposed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    session_id TEXT,

    UNIQUE(test_id, customer_id)
);

CREATE INDEX idx_ab_test_exposures_test_id ON ab_test_exposures(test_id);
CREATE INDEX idx_ab_test_exposures_customer_id ON ab_test_exposures(customer_id);

COMMENT ON TABLE ab_test_exposures IS 'Records which variant each customer saw';

-- ============================================================================
-- AB_TEST_CONVERSIONS TABLE
-- ============================================================================
CREATE TABLE ab_test_conversions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    test_id UUID NOT NULL REFERENCES ab_tests(id) ON DELETE CASCADE,
    exposure_id UUID NOT NULL REFERENCES ab_test_exposures(id) ON DELETE CASCADE,
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,

    -- Conversion details
    variant_key TEXT NOT NULL CHECK (variant_key IN ('variant_a', 'variant_b')),

    -- Conversion type and value
    conversion_type TEXT NOT NULL CHECK (conversion_type IN ('click', 'view', 'order', 'coupon_usage')),
    conversion_value DECIMAL(12, 2) DEFAULT 0,
    -- For 'order' type, this is order total; for others, it's 0 or custom metric

    -- Related entities
    order_id UUID REFERENCES orders(id) ON DELETE SET NULL,
    coupon_id UUID REFERENCES coupons(id) ON DELETE SET NULL,

    -- Metadata
    converted_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_ab_test_conversions_test_id ON ab_test_conversions(test_id);
CREATE INDEX idx_ab_test_conversions_exposure_id ON ab_test_conversions(exposure_id);
CREATE INDEX idx_ab_test_conversions_variant_key ON ab_test_conversions(variant_key);

COMMENT ON TABLE ab_test_conversions IS 'Conversion events for A/B tests';
COMMENT ON COLUMN ab_test_conversions.conversion_value IS 'Monetary value of conversion (e.g., order total)';

-- ============================================================================
-- ROW LEVEL SECURITY
-- ============================================================================
ALTER TABLE ab_tests ENABLE ROW LEVEL SECURITY;
ALTER TABLE ab_test_variants ENABLE ROW LEVEL SECURITY;
ALTER TABLE ab_test_exposures ENABLE ROW LEVEL SECURITY;
ALTER TABLE ab_test_conversions ENABLE ROW LEVEL SECURITY;

-- AB Tests policies
CREATE POLICY "Brand admins can view own ab_tests"
    ON ab_tests FOR SELECT
    USING (brand_id = public.user_brand_id());

CREATE POLICY "Brand admins can create ab_tests"
    ON ab_tests FOR INSERT
    WITH CHECK (brand_id = public.user_brand_id());

CREATE POLICY "Brand admins can update own ab_tests"
    ON ab_tests FOR UPDATE
    USING (brand_id = public.user_brand_id());

CREATE POLICY "Brand admins can delete own ab_tests"
    ON ab_tests FOR DELETE
    USING (brand_id = public.user_brand_id());

-- AB Test Variants policies
CREATE POLICY "Brand admins can manage variants"
    ON ab_test_variants FOR ALL
    USING (
        test_id IN (
            SELECT id FROM ab_tests WHERE brand_id = public.user_brand_id()
        )
    );

-- AB Test Exposures policies
CREATE POLICY "Anyone can view exposures for brand tests"
    ON ab_test_exposures FOR SELECT
    USING (
        test_id IN (
            SELECT id FROM ab_tests WHERE brand_id = public.user_brand_id()
        )
    );

CREATE POLICY "Customers can create exposures"
    ON ab_test_exposures FOR INSERT
    WITH CHECK (customer_id = auth.uid());

-- AB Test Conversions policies
CREATE POLICY "Brand admins can view conversions"
    ON ab_test_conversions FOR SELECT
    USING (
        test_id IN (
            SELECT id FROM ab_tests WHERE brand_id = public.user_brand_id()
        )
    );

CREATE POLICY "Customers can create conversions"
    ON ab_test_conversions FOR INSERT
    WITH CHECK (customer_id = auth.uid());

-- ============================================================================
-- TRIGGER: Update updated_at
-- ============================================================================
CREATE TRIGGER ab_tests_updated_at
    BEFORE UPDATE ON ab_tests
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
