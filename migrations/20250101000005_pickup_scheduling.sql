-- Pickup scheduling: slots and reservations
-- Migration: 20250101000005_pickup_scheduling

-- ============================================================================
-- PICKUP_SLOTS TABLE
-- ============================================================================

CREATE TABLE pickup_slots (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,

    -- Day of week (0 = Sunday, 6 = Saturday)
    day_of_week INTEGER NOT NULL,

    -- Slot duration in minutes (e.g., 15, 30, 60)
    slot_duration_minutes INTEGER NOT NULL DEFAULT 30,

    -- Lead time in minutes (how far in advance customers must order)
    lead_time_minutes INTEGER NOT NULL DEFAULT 20,

    -- Capacity per slot (max concurrent orders)
    capacity_per_slot INTEGER NOT NULL DEFAULT 5,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT pickup_slots_day_of_week_valid CHECK (day_of_week >= 0 AND day_of_week <= 6),
    CONSTRAINT pickup_slots_duration_positive CHECK (slot_duration_minutes > 0),
    CONSTRAINT pickup_slots_lead_time_non_negative CHECK (lead_time_minutes >= 0),
    CONSTRAINT pickup_slots_capacity_positive CHECK (capacity_per_slot > 0),
    CONSTRAINT pickup_slots_unique_store_day UNIQUE(store_id, day_of_week)
);

CREATE INDEX idx_pickup_slots_store_id ON pickup_slots(store_id);

COMMENT ON TABLE pickup_slots IS 'Pickup slot configuration per store and day of week';
COMMENT ON COLUMN pickup_slots.day_of_week IS '0=Sunday, 1=Monday, ..., 6=Saturday';
COMMENT ON COLUMN pickup_slots.lead_time_minutes IS 'Minimum time between order placement and pickup';

-- ============================================================================
-- PICKUP_RESERVATIONS TABLE
-- ============================================================================

CREATE TABLE pickup_reservations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    pickup_time TIMESTAMPTZ NOT NULL,
    reserved_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    expires_at TIMESTAMPTZ NOT NULL,  -- Expires after 2 minutes

    CONSTRAINT pickup_reservations_expires_after_reserved CHECK (expires_at > reserved_at)
);

CREATE INDEX idx_pickup_reservations_store_id ON pickup_reservations(store_id);
CREATE INDEX idx_pickup_reservations_customer_id ON pickup_reservations(customer_id);
CREATE INDEX idx_pickup_reservations_pickup_time ON pickup_reservations(store_id, pickup_time);
CREATE INDEX idx_pickup_reservations_expires_at ON pickup_reservations(expires_at);

COMMENT ON TABLE pickup_reservations IS 'Temporary pickup slot reservations (held for 2 minutes during checkout)';
COMMENT ON COLUMN pickup_reservations.expires_at IS 'Reservation expires and is auto-deleted after this time';

-- ============================================================================
-- ENABLE ROW LEVEL SECURITY
-- ============================================================================

ALTER TABLE pickup_slots ENABLE ROW LEVEL SECURITY;
ALTER TABLE pickup_reservations ENABLE ROW LEVEL SECURITY;

-- Note: RLS policies will be defined in a separate migration (00009_rls_policies.sql)
