-- Add total_amount column to orders table
-- Migration: 20251015000003_add_total_amount_to_orders
--
-- The loyalty triggers use NEW.total_amount, but the orders table uses 'total'.
-- This migration adds total_amount as an alias for compatibility.

-- Add total_amount column (same as total)
ALTER TABLE orders ADD COLUMN IF NOT EXISTS total_amount NUMERIC(10, 2);

-- Create trigger to auto-sync total_amount with total
CREATE OR REPLACE FUNCTION sync_order_total_amount()
RETURNS TRIGGER AS $$
BEGIN
  NEW.total_amount := NEW.total;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_sync_order_total_amount
  BEFORE INSERT OR UPDATE OF total ON orders
  FOR EACH ROW
  EXECUTE FUNCTION sync_order_total_amount();

-- Backfill existing orders
UPDATE orders SET total_amount = total WHERE total_amount IS NULL;

-- Make total_amount NOT NULL after backfill
ALTER TABLE orders ALTER COLUMN total_amount SET NOT NULL;

COMMENT ON COLUMN orders.total_amount IS 'Copy of total for trigger compatibility';
