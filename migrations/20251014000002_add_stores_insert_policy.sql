-- Add missing INSERT policy for stores table
-- Migration: 20251014000002_add_stores_insert_policy
-- This allows brand admins to create stores for their brand

-- Brand admins can create stores for their brand
CREATE POLICY "Brand admins can create stores"
ON stores FOR INSERT
TO authenticated
WITH CHECK (brand_id = public.user_brand_id());

COMMENT ON POLICY "Brand admins can create stores" ON stores IS 'Allows brand admins to create new stores for their brand';
