-- Notifications: notification_logs
-- Migration: 20250101000008_notifications

-- ============================================================================
-- ENUMS
-- ============================================================================

-- Notification type
CREATE TYPE notification_type AS ENUM (
    'push',
    'sms',
    'kakaotalk',
    'email'
);

-- Notification status
CREATE TYPE notification_status AS ENUM (
    'pending',
    'sent',
    'delivered',
    'failed'
);

-- ============================================================================
-- NOTIFICATION_LOGS TABLE
-- ============================================================================

CREATE TABLE notification_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    order_id UUID REFERENCES orders(id) ON DELETE SET NULL,
    type notification_type NOT NULL,
    status notification_status NOT NULL DEFAULT 'pending',

    -- Content
    subject TEXT,
    message TEXT NOT NULL,

    -- Delivery tracking
    sent_at TIMESTAMPTZ,
    delivered_at TIMESTAMPTZ,
    error_message TEXT,

    -- Retry tracking
    retry_count INTEGER NOT NULL DEFAULT 0,
    next_retry_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT notification_logs_message_not_empty CHECK (length(trim(message)) > 0),
    CONSTRAINT notification_logs_retry_count_non_negative CHECK (retry_count >= 0)
);

CREATE INDEX idx_notification_logs_customer_id ON notification_logs(customer_id, created_at DESC);
CREATE INDEX idx_notification_logs_order_id ON notification_logs(order_id);
CREATE INDEX idx_notification_logs_type ON notification_logs(type);
CREATE INDEX idx_notification_logs_status ON notification_logs(status);
CREATE INDEX idx_notification_logs_next_retry ON notification_logs(next_retry_at) WHERE status = 'failed' AND next_retry_at IS NOT NULL;

COMMENT ON TABLE notification_logs IS 'Notification delivery log and retry queue';
COMMENT ON COLUMN notification_logs.next_retry_at IS 'When to retry failed notifications (exponential backoff)';

-- ============================================================================
-- ENABLE ROW LEVEL SECURITY
-- ============================================================================

ALTER TABLE notification_logs ENABLE ROW LEVEL SECURITY;
