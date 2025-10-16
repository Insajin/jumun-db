-- Make user_id nullable for guest/phone-only customers
-- Migration: 20251016200000_make_customers_user_id_nullable

-- This allows customers to be created without full authentication
-- Useful for phone-based registration without password

ALTER TABLE customers
ALTER COLUMN user_id DROP NOT NULL;

-- Update the unique constraint to handle NULL user_ids
ALTER TABLE customers DROP CONSTRAINT IF EXISTS customers_unique_user_brand;

-- Add comment explaining the nullable user_id
COMMENT ON COLUMN customers.user_id IS 'Optional reference to auth.users. NULL for guest/phone-only customers who have not completed full authentication.';

-- Add index for phone + brand_id uniqueness (for phone-only customers)
CREATE UNIQUE INDEX customers_unique_phone_brand
ON customers (phone, brand_id)
WHERE phone IS NOT NULL;

COMMENT ON INDEX customers_unique_phone_brand IS 'Ensures one customer record per phone number per brand, for phone-based registration.';
