-- Migration: Add is_recommended flag to menu_items for home page display
-- Created: 2025-10-20
-- Description: Adds is_recommended column to menu_items table to mark items for recommended section on home page

-- Add is_recommended column to menu_items
ALTER TABLE menu_items
ADD COLUMN IF NOT EXISTS is_recommended BOOLEAN DEFAULT false;

-- Add comment to column
COMMENT ON COLUMN menu_items.is_recommended IS 'Flag to mark menu items for display in recommended section on home page';

-- Create index for performance when querying recommended items
CREATE INDEX IF NOT EXISTS idx_menu_items_recommended
ON menu_items(brand_id, is_recommended)
WHERE is_recommended = true AND available = true;

-- Update some existing items to be recommended (sample data)
-- Note: This will be adjusted based on actual menu items in the database
UPDATE menu_items
SET is_recommended = true
WHERE id IN (
  SELECT id
  FROM menu_items
  WHERE available = true
  ORDER BY created_at DESC
  LIMIT 6
);
