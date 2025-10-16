-- Make brand_id NOT NULL on customers table
-- Migration: 20251016150000_customers_brand_id_not_null

-- First, ensure all existing customers have a brand_id
-- This should already be done, but we'll add a safety check
-- If any customers are missing brand_id, this will fail and prevent data corruption
DO $$
DECLARE
  null_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO null_count FROM customers WHERE brand_id IS NULL;

  IF null_count > 0 THEN
    RAISE EXCEPTION 'Found % customers without brand_id. Please backfill before applying this migration.', null_count;
  END IF;
END $$;

-- Add NOT NULL constraint
ALTER TABLE customers
ALTER COLUMN brand_id SET NOT NULL;

-- Add comment
COMMENT ON COLUMN customers.brand_id IS 'Brand this customer belongs to (required)';
