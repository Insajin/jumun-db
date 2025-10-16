-- Add brand_id to loyalty_transactions for easier filtering
-- Migration: 20251016140000_add_brand_id_to_loyalty

-- Add brand_id column to loyalty_transactions
ALTER TABLE loyalty_transactions
ADD COLUMN brand_id UUID REFERENCES brands(id) ON DELETE CASCADE;

-- Backfill brand_id from customers
UPDATE loyalty_transactions lt
SET brand_id = c.brand_id
FROM customers c
WHERE lt.customer_id = c.id;

-- Make brand_id NOT NULL after backfill
ALTER TABLE loyalty_transactions
ALTER COLUMN brand_id SET NOT NULL;

-- Add index for brand_id filtering
CREATE INDEX idx_loyalty_transactions_brand_id ON loyalty_transactions(brand_id, created_at DESC);

-- Add transaction_type and notes columns for manual adjustments
ALTER TABLE loyalty_transactions
ADD COLUMN transaction_type TEXT DEFAULT 'order',
ADD COLUMN notes TEXT;

COMMENT ON COLUMN loyalty_transactions.brand_id IS 'Brand this transaction belongs to';
COMMENT ON COLUMN loyalty_transactions.transaction_type IS 'Type: order, manual_adjustment, etc.';
COMMENT ON COLUMN loyalty_transactions.notes IS 'Admin notes for manual adjustments';
