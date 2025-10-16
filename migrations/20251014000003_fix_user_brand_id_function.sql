-- Fix user_brand_id() function to read from correct JWT path
-- Migration: 20251014000003_fix_user_brand_id_function
-- The brand_id is stored in app_metadata, not at the root level

-- Simply replace the function with the correct implementation
CREATE OR REPLACE FUNCTION public.user_brand_id()
RETURNS UUID
LANGUAGE SQL
STABLE
SECURITY DEFINER
AS $$
  SELECT COALESCE(
    (auth.jwt() -> 'app_metadata' ->> 'brand_id')::UUID,
    NULL
  );
$$;

COMMENT ON FUNCTION public.user_brand_id IS 'Get current user brand_id from JWT app_metadata claims';
