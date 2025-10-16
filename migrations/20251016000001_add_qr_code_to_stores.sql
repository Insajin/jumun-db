-- Add QR code column to stores table
-- Migration: 20251016000001_add_qr_code_to_stores

-- Add qr_code column to stores table
ALTER TABLE stores
ADD COLUMN qr_code TEXT UNIQUE;

-- Add index for qr_code lookups
CREATE INDEX idx_stores_qr_code ON stores(qr_code) WHERE qr_code IS NOT NULL;

-- Add constraint to ensure qr_code format (alphanumeric and hyphens)
ALTER TABLE stores
ADD CONSTRAINT stores_qr_code_format CHECK (qr_code IS NULL OR qr_code ~ '^[A-Z0-9-]+$');

COMMENT ON COLUMN stores.qr_code IS 'Unique QR code for customer orders';
