# Jumun - Supabase Database Infrastructure

This repository contains the Supabase database schema, migrations, and configuration for the Jumun multi-tenant ordering platform.

## 📋 Overview

Jumun uses Supabase as its primary backend infrastructure, providing:
- **PostgreSQL Database** with PostgREST API
- **Row Level Security (RLS)** for multi-tenant data isolation
- **Real-time subscriptions** for order updates
- **Authentication** with phone and social login
- **Storage** for menu item images and brand assets

## 🏗️ Architecture

### Tech Stack
- **Database**: PostgreSQL 17
- **API**: Supabase PostgREST (auto-generated REST API)
- **Real-time**: Supabase Realtime (WebSocket)
- **Auth**: Supabase Auth (JWT-based)

### Extensions
- `uuid-ossp` - UUID generation
- `pgcrypto` - Cryptographic functions
- `pg_trgm` - Full-text search
- `postgis` - Geospatial data

## 📁 Repository Structure

```
supabase/
├── migrations/           # Database migration files
│   ├── 20250101000001_enable_extensions.sql
│   ├── 20250101000002_core_tables.sql
│   ├── 20250101000003_menu_system.sql
│   ├── 20250101000004_order_system.sql
│   ├── 20250101000005_pickup_scheduling.sql
│   ├── 20250101000006_app_configuration.sql
│   ├── 20250101000007_promotions_loyalty.sql
│   ├── 20250101000008_notifications.sql
│   ├── 20250101000009_rls_policies.sql
│   ├── 20250101000010_functions_triggers.sql
│   ├── 20250101000011_app_builder_functions.sql
│   ├── 20251013000012_test_rls_policies.sql
│   ├── 20251013000013_add_is_online_to_stores.sql
│   ├── 20251013000014_enable_realtime.sql
│   ├── 20251014000001_add_store_business_info.sql
│   ├── 20251014000002_add_stores_insert_policy.sql
│   ├── 20251014000003_fix_user_brand_id_function.sql
│   ├── 20251014043526_add_manager_id_to_stores.sql
│   ├── 20251015000001_loyalty_system_configuration.sql
│   ├── 20251015000002_loyalty_rls_policies.sql
│   └── 20251015000003_add_total_amount_to_orders.sql
├── config.toml          # Supabase local development config
├── seed.sql            # Initial data (optional)
└── README.md           # This file
```

## 🗄️ Database Schema

### Core Tables
- `brands` - Franchise brands
- `subscriptions` - Brand subscription plans
- `stores` - Individual store locations
- `users` - Staff and admins
- `customers` - End customers

### Menu System
- `menu_categories` - Menu categories (e.g., Burgers, Drinks)
- `menu_items` - Individual menu items
- `menu_item_modifiers` - Items and their modifier groups
- `modifier_groups` - Modifier group definitions
- `modifier_options` - Individual modifier options

### Order System
- `orders` - Customer orders
- `order_items` - Items in each order
- `order_item_modifiers` - Modifiers applied to order items
- `pickup_time_slots` - Available pickup times

### Promotions & Loyalty
- `promotions` - Active promotions
- `loyalty_programs` - Brand loyalty programs
- `loyalty_tiers` - Loyalty tier definitions
- `loyalty_transactions` - Point transactions

### Configuration
- `app_configs` - White-label app configurations
- `notifications` - Push notification queue

## 🔐 Security (RLS Policies)

All tables use Row Level Security to enforce multi-tenant data isolation:

### Public Access (No Auth Required)
- View brand basic info
- View menu categories and available items
- View active promotions
- Create orders for test store (guest checkout)

### Authenticated Users
- View own orders
- View own loyalty info

### Store Staff
- View/update orders for their store
- View store configuration

### Brand Admins
- Full access to their brand's data
- Manage stores, menus, promotions
- View analytics

### Super Admins
- Full access to all data

## 🚀 Getting Started

### Prerequisites
- [Supabase CLI](https://supabase.com/docs/guides/cli) installed
- PostgreSQL 17+ (for local development)

### Local Development

1. **Start Supabase locally:**
   ```bash
   supabase start
   ```

2. **View local Studio:**
   ```bash
   # Open http://localhost:54323
   ```

3. **Apply migrations:**
   ```bash
   supabase db reset
   ```

### Connecting to Cloud

1. **Link to cloud project:**
   ```bash
   supabase link --project-ref <project-ref>
   ```

2. **Push migrations:**
   ```bash
   supabase db push
   ```

3. **Pull remote changes:**
   ```bash
   supabase db pull
   ```

## 📝 Creating Migrations

1. **Make schema changes in local Supabase Studio** (http://localhost:54323)

2. **Generate migration:**
   ```bash
   supabase db diff --schema public -f <migration_name>
   ```

3. **Or create manually:**
   ```bash
   # Create new migration file
   touch migrations/$(date +%Y%m%d%H%M%S)_<description>.sql
   ```

4. **Test locally:**
   ```bash
   supabase db reset
   ```

5. **Commit and push to GitHub**

6. **Apply to staging:**
   ```bash
   supabase link --project-ref <staging-ref>
   supabase db push
   ```

7. **Apply to production:**
   ```bash
   supabase link --project-ref <production-ref>
   supabase db push
   ```

## 🌍 Environments

### Local Development
- **URL**: http://localhost:54321
- **Studio**: http://localhost:54323
- **Database**: localhost:54322

### Staging
- **Project**: jumun-staging
- **Region**: Northeast Asia (Seoul)
- Used for testing before production deployment

### Production
- **Project**: jumun-production
- **Region**: Northeast Asia (Seoul)
- Live customer data

## 🔧 Configuration

### config.toml
Local Supabase configuration including:
- API settings (port, schemas)
- Database settings (port, version)
- Auth settings (JWT, email, SMS)
- Realtime settings
- Storage settings

See `config.toml` for full configuration.

## 📊 Monitoring

### Local Development
- **Studio**: http://localhost:54323
- **API Logs**: `supabase logs`
- **DB Logs**: `supabase db logs`

### Cloud (Staging/Production)
- **Dashboard**: https://supabase.com/dashboard
- **Table Editor**: View and edit data
- **SQL Editor**: Run queries
- **Auth**: Manage users
- **Logs**: Real-time logging
- **Metrics**: Performance monitoring

## 🆘 Troubleshooting

### Common Issues

**Migration fails with "already exists":**
```sql
-- Use IF NOT EXISTS
CREATE TABLE IF NOT EXISTS table_name ...
```

**Function not found:**
```sql
-- Check schema, extensions are in 'extensions' schema
CREATE OR REPLACE FUNCTION public.function_name()
RETURNS type
AS 'SELECT extensions.function_name(...)'
LANGUAGE SQL;
```

**RLS policy blocking query:**
- Check if RLS is enabled: `ALTER TABLE table_name ENABLE ROW LEVEL SECURITY;`
- Verify policies match your auth context
- Test with service_role key (bypasses RLS)

**Cannot connect to local Supabase:**
```bash
# Stop and restart
supabase stop
supabase start
```

## 📚 Documentation

- [Supabase Documentation](https://supabase.com/docs)
- [PostgREST API](https://postgrest.org/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

## 🔗 Related Repositories

- [Jumun Customer Web](https://github.com/Insajin/Jumun_customer_web) - Next.js customer web app
- [Jumun Admin](https://github.com/Insajin/Jumun_admin) - Next.js brand admin dashboard
- [Jumun Store Dashboard](https://github.com/Insajin/Jumun_store_dashboard) - Next.js store staff dashboard
- [Jumun API](https://github.com/Insajin/Jumun_api) - Go API for payments and notifications

## 📄 License

Private - All Rights Reserved

---

**Last Updated**: 2025-10-15
