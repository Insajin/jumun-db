-- Add is_online column to stores table
-- This column tracks real-time connectivity status of the store dashboard

ALTER TABLE stores
ADD COLUMN is_online BOOLEAN DEFAULT true NOT NULL;

-- Add comment
COMMENT ON COLUMN stores.is_online IS 'Real-time connectivity status of store dashboard';
