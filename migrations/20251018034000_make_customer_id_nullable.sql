-- Allow guest orders without customer account
-- Migration: 20251018034000_make_customer_id_nullable

ALTER TABLE orders
ALTER COLUMN customer_id DROP NOT NULL;

COMMENT ON COLUMN orders.customer_id IS 'Optional reference to customers.id. NULL for guest checkout orders.';
