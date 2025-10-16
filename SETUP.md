# Supabase Setup Guide

This guide explains how to set up Supabase for the Jumun platform, including staging and production environments.

## 📋 Prerequisites

- Supabase account (https://supabase.com)
- Supabase CLI installed (`npm install -g supabase`)
- PostgreSQL 17+ for local development

## 🚀 Environment Setup

### Local Development

1. **Start local Supabase:**
   ```bash
   supabase start
   ```

2. **Credentials:**
   - API URL: http://localhost:54321
   - Anon Key: (check console output)
   - Service Role Key: (check console output)
   - Studio: http://localhost:54323

### Cloud Setup (Staging/Production)

1. **Create Supabase Project:**
   - Go to https://supabase.com/dashboard
   - Click "New Project"
   - Project Name: `jumun-staging` or `jumun-production`
   - Database Password: (strong password)
   - Region: Northeast Asia (Seoul)
   - Pricing Plan: Free (staging) or Pro (production)

2. **Note Project Details:**
   ```
   Project ID: [your-project-id]
   Project URL: https://[project-id].supabase.co
   Publishable Key: sb_publishable_...
   Secret Key: sb_secret_...
   ```

3. **Link Local to Cloud:**
   ```bash
   supabase link --project-ref [project-id]
   ```

4. **Push Migrations:**
   ```bash
   supabase db push
   ```

## 🗄️ Database Schema

The database consists of 20+ migrations covering:

### Core Tables (20250101000002)
- brands
- subscriptions
- stores
- users
- customers

### Menu System (20250101000003)
- menu_categories
- menu_items
- menu_item_modifiers
- modifier_groups
- modifier_options

### Order System (20250101000004)
- orders
- order_items
- order_item_modifiers

### Additional Features
- Pickup scheduling
- App configuration
- Promotions & loyalty
- Notifications
- RLS policies
- Functions & triggers

## 🔐 Security Configuration

### Row Level Security (RLS)

All tables use RLS policies to enforce multi-tenant data isolation:

#### Public Access
- View brand info
- View available menu items
- View active promotions
- Create test orders (guest checkout)

#### Authenticated Users
- View own orders
- Manage loyalty points

#### Store Staff
- View/update store orders
- View store config

#### Brand Admins
- Manage brand data
- Manage stores
- Manage menus

#### Super Admins
- Full system access

### API Keys

**Publishable Key (sb_publishable_...):**
- Safe to use in frontend applications
- Enforces RLS policies
- Limited to authenticated user's data

**Secret Key (sb_secret_...):**
- NEVER expose in frontend
- Bypasses RLS policies
- Use only in backend/admin operations

## 📝 Migration Workflow

### Creating New Migrations

1. **Make changes in local Supabase Studio:**
   - http://localhost:54323

2. **Generate migration:**
   ```bash
   supabase db diff --schema public -f add_feature_name
   ```

3. **Review generated SQL:**
   ```bash
   cat migrations/[timestamp]_add_feature_name.sql
   ```

4. **Test locally:**
   ```bash
   supabase db reset
   ```

5. **Commit to Git:**
   ```bash
   git add migrations/
   git commit -m "feat: add feature_name to database"
   git push
   ```

### Deploying Migrations

**To Staging:**
```bash
supabase link --project-ref [staging-project-id]
supabase db push
```

**To Production:**
```bash
supabase link --project-ref [production-project-id]
supabase db push
```

## 🔧 Common Operations

### View Database Status
```bash
supabase status
```

### Reset Local Database
```bash
supabase db reset
```

### Pull Remote Schema
```bash
supabase db pull
```

### Generate Types (TypeScript)
```bash
supabase gen types typescript --project-id [project-id] > types/supabase.ts
```

### View Logs
```bash
supabase logs -f  # Follow logs
```

## 🐛 Troubleshooting

### Issue: "Type already exists"

**Problem:** Supabase Cloud has pre-existing types from initialization

**Solution:** Initialize public schema via SQL Editor:
```sql
DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres, anon, authenticated, service_role;
```

### Issue: "Function does not exist"

**Problem:** Extensions installed in `extensions` schema, not accessible from `public`

**Solution:** Create wrapper functions:
```sql
-- UUID wrapper
CREATE OR REPLACE FUNCTION public.uuid_generate_v4()
RETURNS uuid AS 'SELECT extensions.uuid_generate_v4()'
LANGUAGE SQL VOLATILE;

-- PostGIS wrapper
CREATE OR REPLACE FUNCTION public.st_makepoint(double precision, double precision)
RETURNS geometry AS 'SELECT extensions.st_makepoint($1, $2)'
LANGUAGE SQL IMMUTABLE STRICT PARALLEL SAFE;
```

### Issue: RLS Policy Blocking Query

**Debug:**
1. Check if RLS is enabled: `\d+ table_name` in psql
2. Verify user role and context
3. Test with service_role key (bypasses RLS)

**Fix:** Update policy or use correct authentication

### Issue: Cannot Connect to Local Supabase

**Solution:**
```bash
supabase stop
supabase start
```

## 📊 Monitoring

### Local Development
- **Studio UI**: http://localhost:54323
- **Table Editor**: View/edit data
- **SQL Editor**: Run queries
- **Database Logs**: Check for errors

### Cloud (Dashboard)
- **Logs**: Real-time application logs
- **Metrics**: Database performance
- **Query Performance**: Slow query analysis
- **API Analytics**: Endpoint usage

## 🔗 Integration

### Frontend (Next.js/Flutter)

```typescript
// Initialize Supabase client
import { createClient } from '@supabase/supabase-js'

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
)
```

### Backend (Go API)

```go
// Use service_role key for admin operations
supabaseURL := os.Getenv("SUPABASE_URL")
serviceKey := os.Getenv("SUPABASE_SERVICE_KEY")
```

## 📚 Resources

- [Supabase Documentation](https://supabase.com/docs)
- [PostgREST API Reference](https://postgrest.org/)
- [Row Level Security Guide](https://supabase.com/docs/guides/auth/row-level-security)
- [CLI Reference](https://supabase.com/docs/reference/cli)

---

**Last Updated**: 2025-10-15
