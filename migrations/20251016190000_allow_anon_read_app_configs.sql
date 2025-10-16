-- Allow anonymous users to read app configurations
-- Migration: 20251016190000_allow_anon_read_app_configs

-- This is needed for the customer-web app to load brand-specific configurations
-- Customer-facing apps need to be able to look up app configs to customize the UI

CREATE POLICY "Anyone can view app configs"
ON app_configs FOR SELECT
TO anon, authenticated
USING (true);

-- Add comment explaining the policy
COMMENT ON POLICY "Anyone can view app configs" ON app_configs IS
'Allows anonymous and authenticated users to view app configurations. This is needed for the customer-facing web app to load brand-specific theming and feature toggles.';
