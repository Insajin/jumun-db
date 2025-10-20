-- ============================================================================
-- Truncate All Data from Staging Database
-- ============================================================================
-- WARNING: This will DELETE ALL DATA from the database
-- Make sure you have a backup before running this!
-- ============================================================================

-- Disable triggers temporarily to avoid cascade issues
SET session_replication_role = 'replica';

-- Truncate all tables in dependency order (reverse of creation)
TRUNCATE TABLE notification_logs CASCADE;
TRUNCATE TABLE loyalty_transactions CASCADE;
TRUNCATE TABLE coupons CASCADE;
TRUNCATE TABLE promotions CASCADE;
TRUNCATE TABLE app_builds CASCADE;
TRUNCATE TABLE app_configs CASCADE;
TRUNCATE TABLE pickup_reservations CASCADE;
TRUNCATE TABLE pickup_slots CASCADE;
TRUNCATE TABLE refunds CASCADE;
TRUNCATE TABLE order_status_history CASCADE;
TRUNCATE TABLE orders CASCADE;
TRUNCATE TABLE inventory CASCADE;
TRUNCATE TABLE menu_modifiers CASCADE;
TRUNCATE TABLE menu_items CASCADE;
TRUNCATE TABLE menu_categories CASCADE;
TRUNCATE TABLE customers CASCADE;
TRUNCATE TABLE staff CASCADE;
TRUNCATE TABLE stores CASCADE;
TRUNCATE TABLE subscriptions CASCADE;
TRUNCATE TABLE brands CASCADE;

-- Re-enable triggers
SET session_replication_role = 'origin';

-- Verify all tables are empty
SELECT
    'brands' as table_name, COUNT(*) as row_count FROM brands
UNION ALL
SELECT 'subscriptions', COUNT(*) FROM subscriptions
UNION ALL
SELECT 'stores', COUNT(*) FROM stores
UNION ALL
SELECT 'staff', COUNT(*) FROM staff
UNION ALL
SELECT 'customers', COUNT(*) FROM customers
UNION ALL
SELECT 'menu_categories', COUNT(*) FROM menu_categories
UNION ALL
SELECT 'menu_items', COUNT(*) FROM menu_items
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'app_configs', COUNT(*) FROM app_configs;
