-- Order system: orders, order_status_history, refunds
-- Migration: 20250101000004_order_system

-- ============================================================================
-- ENUMS
-- ============================================================================

-- Order status
CREATE TYPE order_status AS ENUM (
    'pending',          -- Initial state (cart/checkout)
    'waiting',          -- Payment confirmed, awaiting store acknowledgment
    'preparing',        -- Store is preparing the order
    'ready',            -- Order ready for pickup
    'completed',        -- Customer picked up
    'cancelled',        -- Cancelled by customer or staff
    'payment_issue'     -- Payment failed after confirmation
);

-- Payment method
CREATE TYPE payment_method AS ENUM (
    'toss',
    'kakaopay',
    'naverpay',
    'stripe',
    'cash'
);

-- Payment status
CREATE TYPE payment_status AS ENUM (
    'pending',
    'authorized',
    'captured',
    'failed',
    'refunded',
    'partially_refunded'
);

-- Cancellation reason
CREATE TYPE cancellation_reason AS ENUM (
    'customer_request',
    'out_of_stock',
    'store_closed',
    'payment_failed',
    'other'
);

-- Refund status
CREATE TYPE refund_status AS ENUM (
    'pending',
    'processing',
    'completed',
    'failed'
);

-- ============================================================================
-- ORDERS TABLE
-- ============================================================================

CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
    store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,

    -- Order items (JSONB)
    -- Example: [{"item_id": "uuid", "name": "Coffee", "quantity": 2, "price": 5.00, "modifiers": [...]}]
    items JSONB NOT NULL DEFAULT '[]',

    -- Pricing
    subtotal DECIMAL(10,2) NOT NULL,
    tax DECIMAL(10,2) NOT NULL DEFAULT 0,
    discount DECIMAL(10,2) NOT NULL DEFAULT 0,
    total DECIMAL(10,2) NOT NULL,

    -- Pickup window
    pickup_window_start TIMESTAMPTZ NOT NULL,
    pickup_window_end TIMESTAMPTZ NOT NULL,

    -- Status
    status order_status NOT NULL DEFAULT 'pending',

    -- Payment
    payment_method payment_method,
    payment_status payment_status NOT NULL DEFAULT 'pending',
    payment_id TEXT,  -- External payment gateway transaction ID
    payment_metadata JSONB,  -- Additional payment details

    -- Customer info (snapshot at order time)
    customer_name TEXT,
    customer_phone TEXT,

    -- Special instructions
    notes TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT orders_subtotal_positive CHECK (subtotal >= 0),
    CONSTRAINT orders_total_positive CHECK (total >= 0),
    CONSTRAINT orders_pickup_window_valid CHECK (pickup_window_start < pickup_window_end)
);

CREATE INDEX idx_orders_brand_id ON orders(brand_id);
CREATE INDEX idx_orders_store_id ON orders(store_id);
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_payment_status ON orders(payment_status);
CREATE INDEX idx_orders_created_at ON orders(created_at DESC);
CREATE INDEX idx_orders_pickup_window ON orders(pickup_window_start, pickup_window_end);

-- Index for active orders (used by staff dashboard)
CREATE INDEX idx_orders_active ON orders(store_id, status)
WHERE status IN ('waiting', 'preparing', 'ready');

COMMENT ON TABLE orders IS 'Customer orders';
COMMENT ON COLUMN orders.items IS 'Order line items with modifiers (JSONB)';
COMMENT ON COLUMN orders.payment_metadata IS 'Payment gateway metadata (JSONB)';

-- ============================================================================
-- ORDER_STATUS_HISTORY TABLE
-- ============================================================================

CREATE TABLE order_status_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    from_status order_status,
    to_status order_status NOT NULL,
    changed_by UUID REFERENCES auth.users(id),  -- NULL for system changes
    reason TEXT,
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_order_status_history_order_id ON order_status_history(order_id, timestamp DESC);
CREATE INDEX idx_order_status_history_changed_by ON order_status_history(changed_by);

COMMENT ON TABLE order_status_history IS 'Audit trail for order status changes';
COMMENT ON COLUMN order_status_history.changed_by IS 'User who changed the status (NULL for automated changes)';

-- ============================================================================
-- REFUNDS TABLE
-- ============================================================================

CREATE TABLE refunds (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    amount DECIMAL(10,2) NOT NULL,
    reason cancellation_reason NOT NULL,
    reason_notes TEXT,
    status refund_status NOT NULL DEFAULT 'pending',
    refund_id TEXT,  -- External payment gateway refund ID
    processed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT refunds_amount_positive CHECK (amount > 0)
);

CREATE INDEX idx_refunds_order_id ON refunds(order_id);
CREATE INDEX idx_refunds_status ON refunds(status);
CREATE INDEX idx_refunds_created_at ON refunds(created_at DESC);

COMMENT ON TABLE refunds IS 'Order refunds';
COMMENT ON COLUMN refunds.refund_id IS 'Payment gateway refund transaction ID';

-- ============================================================================
-- ENABLE ROW LEVEL SECURITY
-- ============================================================================

ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_status_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE refunds ENABLE ROW LEVEL SECURITY;

-- Note: RLS policies will be defined in a separate migration (00009_rls_policies.sql)
