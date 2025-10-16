-- Push Tokens Table for Push Notifications
-- Migration: 20251016130000_push_tokens_table

-- ============================================================================
-- PUSH TOKENS TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS push_tokens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    token TEXT NOT NULL,
    platform TEXT NOT NULL CHECK (platform IN ('ios', 'android', 'web')),
    active BOOLEAN NOT NULL DEFAULT TRUE,
    device_info JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    last_used_at TIMESTAMPTZ,

    -- Ensure one token per device
    UNIQUE(customer_id, token)
);

-- Indexes
CREATE INDEX idx_push_tokens_customer_id ON push_tokens(customer_id);
CREATE INDEX idx_push_tokens_active ON push_tokens(active) WHERE active = TRUE;
CREATE INDEX idx_push_tokens_platform ON push_tokens(platform);

-- RLS Policies
ALTER TABLE push_tokens ENABLE ROW LEVEL SECURITY;

-- Customers can manage their own push tokens
CREATE POLICY "Customers can view own push tokens"
    ON push_tokens FOR SELECT
    USING (
        customer_id IN (
            SELECT id FROM customers WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Customers can insert own push tokens"
    ON push_tokens FOR INSERT
    WITH CHECK (
        customer_id IN (
            SELECT id FROM customers WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Customers can update own push tokens"
    ON push_tokens FOR UPDATE
    USING (
        customer_id IN (
            SELECT id FROM customers WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Customers can delete own push tokens"
    ON push_tokens FOR DELETE
    USING (
        customer_id IN (
            SELECT id FROM customers WHERE user_id = auth.uid()
        )
    );

-- Brand admins can view push tokens for their customers (for analytics)
CREATE POLICY "Brand admins can view customer push tokens"
    ON push_tokens FOR SELECT
    USING (
        customer_id IN (
            SELECT c.id FROM customers c
            WHERE c.brand_id = public.user_brand_id()
        )
    );

COMMENT ON TABLE push_tokens IS 'Stores push notification tokens for customers';
COMMENT ON COLUMN push_tokens.token IS 'FCM/APNs device token';
COMMENT ON COLUMN push_tokens.platform IS 'Device platform: ios, android, or web';
COMMENT ON COLUMN push_tokens.device_info IS 'Additional device information (model, OS version, etc.)';
