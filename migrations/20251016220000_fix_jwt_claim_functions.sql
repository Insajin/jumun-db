-- Fix JWT claim functions to read from app_metadata (2025-10-16)
--
-- Problem: The user_role(), user_brand_id(), and user_store_id() functions
-- were reading from the root level of JWT, but Supabase stores app_metadata
-- in a nested object under 'app_metadata'.
--
-- Solution: Update functions to read from auth.jwt() -> 'app_metadata' -> 'key'

-- Drop and recreate the functions with correct JWT paths

-- Get current user's role from JWT app_metadata
CREATE OR REPLACE FUNCTION public.user_role()
RETURNS TEXT AS $$
  SELECT COALESCE(
    auth.jwt() -> 'app_metadata' ->> 'role',
    'customer'
  )::TEXT;
$$ LANGUAGE SQL STABLE SECURITY DEFINER;

-- Get current user's brand_id from JWT app_metadata
CREATE OR REPLACE FUNCTION public.user_brand_id()
RETURNS UUID AS $$
  SELECT COALESCE(
    (auth.jwt() -> 'app_metadata' ->> 'brand_id')::UUID,
    NULL
  );
$$ LANGUAGE SQL STABLE SECURITY DEFINER;

-- Get current user's store_id from JWT app_metadata
CREATE OR REPLACE FUNCTION public.user_store_id()
RETURNS UUID AS $$
  SELECT COALESCE(
    (auth.jwt() -> 'app_metadata' ->> 'store_id')::UUID,
    NULL
  );
$$ LANGUAGE SQL STABLE SECURITY DEFINER;

-- Update comments
COMMENT ON FUNCTION public.user_role IS 'Get current user role from JWT app_metadata.role';
COMMENT ON FUNCTION public.user_brand_id IS 'Get current user brand_id from JWT app_metadata.brand_id';
COMMENT ON FUNCTION public.user_store_id IS 'Get current user store_id from JWT app_metadata.store_id';
