-- Enable required PostgreSQL extensions
-- Migration: 20250101000001_enable_extensions

-- UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Cryptographic functions
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Full-text search
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- PostGIS (for location-based features)
CREATE EXTENSION IF NOT EXISTS "postgis";

-- Comments
COMMENT ON EXTENSION "uuid-ossp" IS 'UUID generation functions';
COMMENT ON EXTENSION "pgcrypto" IS 'Cryptographic functions';
COMMENT ON EXTENSION "pg_trgm" IS 'Trigram matching for full-text search';
COMMENT ON EXTENSION "postgis" IS 'Geographic objects and spatial queries';
