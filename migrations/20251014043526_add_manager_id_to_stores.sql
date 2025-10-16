-- Add manager_id column to stores table
ALTER TABLE stores
ADD COLUMN IF NOT EXISTS manager_id UUID REFERENCES auth.users(id) ON DELETE SET NULL;

-- Add comment
COMMENT ON COLUMN stores.manager_id IS 'Reference to the store manager user account in auth.users';

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_stores_manager_id ON stores(manager_id);
