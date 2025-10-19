-- Grant INSERT and UPDATE privileges on customers table to anon and authenticated roles
-- Migration: 20251019000001_grant_customers_insert_update
--
-- Issue: Anonymous users couldn't create customer accounts due to missing INSERT privilege
-- Error: "permission denied for table customers" (code: 42501)
--
-- Root Cause:
-- RLS policies existed but anon/authenticated roles lacked table-level GRANT privileges
-- for INSERT and UPDATE operations on customers table
--
-- Solution: Grant INSERT and UPDATE to anon and authenticated roles

GRANT INSERT, UPDATE ON customers TO anon, authenticated;

COMMENT ON TABLE customers IS
'Customers table with INSERT/UPDATE grants for anon/authenticated roles.
RLS policies control row-level access. Table grants allow operation types.';
