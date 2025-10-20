-- Add secondary_color column to app_configs table
ALTER TABLE app_configs
ADD COLUMN IF NOT EXISTS secondary_color TEXT DEFAULT '#1e40af' CHECK (secondary_color ~ '^#[0-9A-Fa-f]{6}$');

COMMENT ON COLUMN app_configs.secondary_color IS 'Brand secondary color (hex format) for web customer app';

-- Set secondary_color to a darker shade of primary_color for existing records
UPDATE app_configs
SET secondary_color = '#1e40af'
WHERE secondary_color IS NULL;
