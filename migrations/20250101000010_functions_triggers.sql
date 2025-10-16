-- Database Functions & Triggers
-- Migration: 20250101000010_functions_triggers

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

-- Update updated_at timestamp automatically
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION update_updated_at_column IS 'Automatically update updated_at column on row update';

-- ============================================================================
-- UPDATED_AT TRIGGERS
-- ============================================================================

-- Apply to all tables with updated_at column
CREATE TRIGGER update_brands_updated_at
  BEFORE UPDATE ON brands
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_subscriptions_updated_at
  BEFORE UPDATE ON subscriptions
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_stores_updated_at
  BEFORE UPDATE ON stores
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_staff_updated_at
  BEFORE UPDATE ON staff
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_customers_updated_at
  BEFORE UPDATE ON customers
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_menu_categories_updated_at
  BEFORE UPDATE ON menu_categories
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_menu_items_updated_at
  BEFORE UPDATE ON menu_items
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_menu_modifiers_updated_at
  BEFORE UPDATE ON menu_modifiers
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_orders_updated_at
  BEFORE UPDATE ON orders
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_pickup_slots_updated_at
  BEFORE UPDATE ON pickup_slots
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_app_configs_updated_at
  BEFORE UPDATE ON app_configs
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- INVENTORY AUTO-DISABLE TRIGGER
-- ============================================================================

-- Auto-disable menu items when inventory reaches 0
CREATE OR REPLACE FUNCTION auto_disable_out_of_stock_items()
RETURNS TRIGGER AS $$
BEGIN
  -- If quantity drops to 0, disable the item
  IF NEW.quantity = 0 AND OLD.quantity > 0 THEN
    UPDATE menu_items
    SET available = FALSE
    WHERE id = NEW.item_id AND inventory_tracked = TRUE;
  END IF;

  -- If quantity increases from 0, re-enable the item
  IF NEW.quantity > 0 AND OLD.quantity = 0 THEN
    UPDATE menu_items
    SET available = TRUE
    WHERE id = NEW.item_id AND inventory_tracked = TRUE;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_auto_disable_out_of_stock
  AFTER UPDATE ON inventory
  FOR EACH ROW
  EXECUTE FUNCTION auto_disable_out_of_stock_items();

COMMENT ON FUNCTION auto_disable_out_of_stock_items IS 'Auto-disable menu items when inventory reaches 0';

-- ============================================================================
-- ORDER STATUS HISTORY TRIGGER
-- ============================================================================

-- Automatically log order status changes
CREATE OR REPLACE FUNCTION log_order_status_change()
RETURNS TRIGGER AS $$
BEGIN
  -- Only log if status actually changed
  IF NEW.status != OLD.status THEN
    INSERT INTO order_status_history (order_id, from_status, to_status)
    VALUES (NEW.id, OLD.status, NEW.status);
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_log_order_status_change
  AFTER UPDATE ON orders
  FOR EACH ROW
  EXECUTE FUNCTION log_order_status_change();

COMMENT ON FUNCTION log_order_status_change IS 'Automatically log order status changes to order_status_history';

-- ============================================================================
-- LOYALTY POINTS TRIGGER
-- ============================================================================

-- Award loyalty points when order is completed
CREATE OR REPLACE FUNCTION award_loyalty_points()
RETURNS TRIGGER AS $$
DECLARE
  points_to_award INTEGER;
  current_balance INTEGER;
BEGIN
  -- Only award points when order transitions to 'completed'
  IF NEW.status = 'completed' AND OLD.status != 'completed' THEN
    -- Calculate points (1 point per dollar spent, rounded down)
    points_to_award := FLOOR(NEW.total);

    -- Get current balance
    SELECT loyalty_points INTO current_balance
    FROM customers
    WHERE id = NEW.customer_id;

    -- Insert loyalty transaction
    INSERT INTO loyalty_transactions (
      customer_id,
      order_id,
      points_earned,
      balance
    ) VALUES (
      NEW.customer_id,
      NEW.id,
      points_to_award,
      COALESCE(current_balance, 0) + points_to_award
    );

    -- Update customer's loyalty points
    UPDATE customers
    SET loyalty_points = loyalty_points + points_to_award
    WHERE id = NEW.customer_id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_award_loyalty_points
  AFTER UPDATE ON orders
  FOR EACH ROW
  EXECUTE FUNCTION award_loyalty_points();

COMMENT ON FUNCTION award_loyalty_points IS 'Award loyalty points when order is completed';

-- ============================================================================
-- CASCADE MASTER MENU UPDATES
-- ============================================================================

-- Propagate brand-level menu changes to store-level menus
CREATE OR REPLACE FUNCTION cascade_master_menu_updates()
RETURNS TRIGGER AS $$
BEGIN
  -- When a brand-level menu item's price changes, update store-level overrides
  IF NEW.store_id IS NULL AND NEW.price != OLD.price THEN
    UPDATE menu_items
    SET price = NEW.price
    WHERE brand_id = NEW.brand_id
      AND store_id IS NOT NULL
      AND id = NEW.id;
  END IF;

  -- When a brand-level item's availability changes
  IF NEW.store_id IS NULL AND NEW.available != OLD.available THEN
    UPDATE menu_items
    SET available = NEW.available
    WHERE brand_id = NEW.brand_id
      AND store_id IS NOT NULL
      AND id = NEW.id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_cascade_master_menu
  AFTER UPDATE ON menu_items
  FOR EACH ROW
  WHEN (NEW.store_id IS NULL)
  EXECUTE FUNCTION cascade_master_menu_updates();

COMMENT ON FUNCTION cascade_master_menu_updates IS 'Cascade brand-level menu changes to store overrides';

-- ============================================================================
-- DELETE EXPIRED PICKUP RESERVATIONS
-- ============================================================================

-- Function to delete expired pickup reservations
CREATE OR REPLACE FUNCTION delete_expired_reservations()
RETURNS INTEGER AS $$
DECLARE
  deleted_count INTEGER;
BEGIN
  DELETE FROM pickup_reservations
  WHERE expires_at < NOW();

  GET DIAGNOSTICS deleted_count = ROW_COUNT;
  RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION delete_expired_reservations IS 'Delete expired pickup reservations (>2 minutes old). Call from background job.';

-- ============================================================================
-- AUTO-CANCEL PAYMENT ISSUE ORDERS
-- ============================================================================

-- Function to auto-cancel orders in "payment_issue" status for >10 minutes
CREATE OR REPLACE FUNCTION auto_cancel_payment_issue_orders()
RETURNS INTEGER AS $$
DECLARE
  cancelled_count INTEGER;
BEGIN
  UPDATE orders
  SET
    status = 'cancelled',
    updated_at = NOW()
  WHERE
    status = 'payment_issue' AND
    updated_at < NOW() - INTERVAL '10 minutes';

  GET DIAGNOSTICS cancelled_count = ROW_COUNT;

  -- Log status changes
  INSERT INTO order_status_history (order_id, from_status, to_status, reason)
  SELECT id, 'payment_issue', 'cancelled', 'Auto-cancelled: payment not resolved within 10 minutes'
  FROM orders
  WHERE status = 'cancelled' AND updated_at = NOW();

  RETURN cancelled_count;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION auto_cancel_payment_issue_orders IS 'Auto-cancel orders in payment_issue status for >10 minutes. Call from background job.';

-- ============================================================================
-- CHECK PICKUP SLOT CAPACITY
-- ============================================================================

-- Function to check if pickup slot has capacity
CREATE OR REPLACE FUNCTION check_pickup_slot_capacity(
  p_store_id UUID,
  p_pickup_time TIMESTAMPTZ
)
RETURNS BOOLEAN AS $$
DECLARE
  slot_capacity INTEGER;
  current_count INTEGER;
  day_of_week INTEGER;
BEGIN
  -- Get day of week from pickup time (0 = Sunday)
  day_of_week := EXTRACT(DOW FROM p_pickup_time);

  -- Get capacity for this day
  SELECT capacity_per_slot INTO slot_capacity
  FROM pickup_slots
  WHERE store_id = p_store_id AND day_of_week = day_of_week;

  -- If no slot configuration found, default to allowing
  IF slot_capacity IS NULL THEN
    RETURN TRUE;
  END IF;

  -- Count existing orders + reservations for this slot
  SELECT COUNT(*) INTO current_count
  FROM (
    SELECT 1 FROM orders
    WHERE store_id = p_store_id
      AND pickup_window_start = p_pickup_time
      AND status NOT IN ('cancelled', 'completed')
    UNION ALL
    SELECT 1 FROM pickup_reservations
    WHERE store_id = p_store_id
      AND pickup_time = p_pickup_time
      AND expires_at > NOW()
  ) AS combined;

  -- Return TRUE if capacity available
  RETURN current_count < slot_capacity;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION check_pickup_slot_capacity IS 'Check if pickup slot has available capacity';

-- ============================================================================
-- VALIDATE PICKUP SLOT RESERVATION
-- ============================================================================

-- Trigger to validate pickup slot capacity before creating reservation
CREATE OR REPLACE FUNCTION validate_pickup_reservation()
RETURNS TRIGGER AS $$
BEGIN
  IF NOT check_pickup_slot_capacity(NEW.store_id, NEW.pickup_time) THEN
    RAISE EXCEPTION 'Pickup slot is full. Please select a different time.';
  END IF;

  -- Set expiration to 2 minutes from now
  NEW.expires_at := NOW() + INTERVAL '2 minutes';

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validate_pickup_reservation
  BEFORE INSERT ON pickup_reservations
  FOR EACH ROW
  EXECUTE FUNCTION validate_pickup_reservation();

COMMENT ON FUNCTION validate_pickup_reservation IS 'Validate pickup slot capacity before creating reservation';

-- ============================================================================
-- UPDATE INVENTORY ON ORDER
-- ============================================================================

-- Decrease inventory when order is placed
CREATE OR REPLACE FUNCTION decrease_inventory_on_order()
RETURNS TRIGGER AS $$
DECLARE
  item JSONB;
  item_id UUID;
  item_quantity INTEGER;
BEGIN
  -- Only decrease inventory when order moves to 'waiting' status
  IF NEW.status = 'waiting' AND OLD.status = 'pending' THEN
    -- Loop through order items
    FOR item IN SELECT * FROM jsonb_array_elements(NEW.items)
    LOOP
      item_id := (item->>'item_id')::UUID;
      item_quantity := (item->>'quantity')::INTEGER;

      -- Decrease inventory for items with inventory tracking
      UPDATE inventory
      SET quantity = quantity - item_quantity,
          updated_at = NOW()
      WHERE store_id = NEW.store_id
        AND item_id = item_id
        AND EXISTS (
          SELECT 1 FROM menu_items
          WHERE id = item_id AND inventory_tracked = TRUE
        );
    END LOOP;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_decrease_inventory_on_order
  AFTER UPDATE ON orders
  FOR EACH ROW
  EXECUTE FUNCTION decrease_inventory_on_order();

COMMENT ON FUNCTION decrease_inventory_on_order IS 'Decrease inventory when order is confirmed (pending → waiting)';

-- ============================================================================
-- SUMMARY
-- ============================================================================

-- Create a view to see all triggers
CREATE OR REPLACE VIEW trigger_summary AS
SELECT
  tgname AS trigger_name,
  tgrelid::regclass AS table_name,
  proname AS function_name
FROM pg_trigger
JOIN pg_proc ON pg_trigger.tgfoid = pg_proc.oid
WHERE tgname NOT LIKE 'RI_%'  -- Exclude foreign key triggers
ORDER BY tgrelid::regclass::text, tgname;

COMMENT ON VIEW trigger_summary IS 'Summary of all active triggers';
