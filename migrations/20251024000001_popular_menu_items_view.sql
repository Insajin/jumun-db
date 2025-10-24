-- Migration: Create popular menu items materialized view
-- Created: 2025-10-24
-- Purpose: Calculate and cache popular menu items based on order statistics

-- Create materialized view for popular menu items
-- This view ranks menu items by order count within each brand
-- Note: Orders have items stored as JSONB, so we extract and count from the items array
CREATE MATERIALIZED VIEW IF NOT EXISTS popular_menu_items AS
WITH menu_order_counts AS (
  SELECT
    mi.id as menu_item_id,
    COUNT(DISTINCT o.id) as order_count
  FROM menu_items mi
  LEFT JOIN orders o ON o.brand_id = mi.brand_id
    AND o.status != 'cancelled'
    AND EXISTS (
      SELECT 1
      FROM jsonb_array_elements(o.items) AS item
      WHERE (item->>'menu_item_id')::uuid = mi.id
    )
  WHERE mi.available = true
  GROUP BY mi.id
)
SELECT
  mi.id,
  mi.brand_id,
  mi.store_id,
  mi.category_id,
  mi.name,
  mi.description,
  mi.price,
  mi.image_url,
  COALESCE(moc.order_count, 0) as order_count,
  ROW_NUMBER() OVER (
    PARTITION BY mi.brand_id
    ORDER BY COALESCE(moc.order_count, 0) DESC, mi.created_at DESC
  ) as popularity_rank
FROM menu_items mi
LEFT JOIN menu_order_counts moc ON moc.menu_item_id = mi.id
WHERE mi.available = true;

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_popular_menu_items_brand_rank
ON popular_menu_items(brand_id, popularity_rank);

CREATE INDEX IF NOT EXISTS idx_popular_menu_items_store
ON popular_menu_items(store_id)
WHERE store_id IS NOT NULL;

-- Create unique index to enable concurrent refresh
CREATE UNIQUE INDEX IF NOT EXISTS idx_popular_menu_items_id
ON popular_menu_items(id);

-- Create function to refresh the materialized view
CREATE OR REPLACE FUNCTION refresh_popular_menu_items()
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY popular_menu_items;
END;
$$;

-- Create policy for public read access
-- Users should be able to view popular items without authentication
ALTER MATERIALIZED VIEW popular_menu_items OWNER TO postgres;

-- Grant read access to authenticated and anonymous users
GRANT SELECT ON popular_menu_items TO authenticated;
GRANT SELECT ON popular_menu_items TO anon;

-- Add comment explaining the view
COMMENT ON MATERIALIZED VIEW popular_menu_items IS
'Cached view of popular menu items ranked by order count within each brand. Refresh periodically or on-demand.';

COMMENT ON FUNCTION refresh_popular_menu_items() IS
'Refresh the popular_menu_items materialized view. Call this periodically (e.g., every hour) or when menu/order data changes significantly.';
