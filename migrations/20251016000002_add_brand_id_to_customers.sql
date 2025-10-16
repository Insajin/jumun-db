-- Add brand_id to customers table for white-label isolation
-- Migration: 20251016000002_add_brand_id_to_customers

-- Add brand_id column to customers table
ALTER TABLE customers
ADD COLUMN brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE;

-- Create index for brand-based queries
CREATE INDEX idx_customers_brand_id ON customers(brand_id);

-- Update unique constraint: user_id is unique per brand, not globally
-- This allows the same email to sign up for different brand apps
ALTER TABLE customers DROP CONSTRAINT customers_user_id_key;
ALTER TABLE customers ADD CONSTRAINT customers_unique_user_brand UNIQUE(user_id, brand_id);

COMMENT ON COLUMN customers.brand_id IS 'Brand that this customer belongs to (for white-label app isolation)';
