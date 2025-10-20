-- Menu system: categories, items, modifiers, inventory
-- Migration: 20250101000003_menu_system

-- ============================================================================
-- ENUMS
-- ============================================================================

-- Modifier type
CREATE TYPE modifier_type AS ENUM ('single', 'multiple');

-- ============================================================================
-- MENU_CATEGORIES TABLE
-- ============================================================================

CREATE TABLE menu_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
    store_id UUID REFERENCES stores(id) ON DELETE CASCADE,  -- NULL = brand-level category
    parent_id UUID REFERENCES menu_categories(id) ON DELETE CASCADE,  -- For hierarchical categories
    name TEXT NOT NULL,
    description TEXT,
    display_order INTEGER NOT NULL DEFAULT 0,
    image_url TEXT,
    available BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT menu_categories_name_not_empty CHECK (length(trim(name)) > 0),
    -- Prevent circular parent references
    CONSTRAINT menu_categories_no_self_parent CHECK (id != parent_id)
);

CREATE INDEX idx_menu_categories_brand_id ON menu_categories(brand_id);
CREATE INDEX idx_menu_categories_store_id ON menu_categories(store_id);
CREATE INDEX idx_menu_categories_parent_id ON menu_categories(parent_id);
CREATE INDEX idx_menu_categories_display_order ON menu_categories(brand_id, display_order);

COMMENT ON TABLE menu_categories IS 'Menu categories (hierarchical)';
COMMENT ON COLUMN menu_categories.store_id IS 'NULL for brand-level categories';
COMMENT ON COLUMN menu_categories.parent_id IS 'For nested categories (e.g., Coffee > Hot Coffee)';

-- ============================================================================
-- MENU_ITEMS TABLE
-- ============================================================================

CREATE TABLE menu_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
    store_id UUID REFERENCES stores(id) ON DELETE CASCADE,  -- NULL = brand-level item
    category_id UUID REFERENCES menu_categories(id) ON DELETE SET NULL,
    name TEXT NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    image_url TEXT,
    available BOOLEAN NOT NULL DEFAULT TRUE,
    inventory_tracked BOOLEAN NOT NULL DEFAULT FALSE,
    display_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT menu_items_name_not_empty CHECK (length(trim(name)) > 0),
    CONSTRAINT menu_items_price_positive CHECK (price >= 0)
);

CREATE INDEX idx_menu_items_brand_id ON menu_items(brand_id);
CREATE INDEX idx_menu_items_store_id ON menu_items(store_id);
CREATE INDEX idx_menu_items_category_id ON menu_items(category_id);
CREATE INDEX idx_menu_items_available ON menu_items(available);
CREATE INDEX idx_menu_items_display_order ON menu_items(category_id, display_order);

COMMENT ON TABLE menu_items IS 'Menu items (products)';
COMMENT ON COLUMN menu_items.store_id IS 'NULL for brand-level items (can be overridden per store)';
COMMENT ON COLUMN menu_items.inventory_tracked IS 'If true, check inventory table for availability';

-- ============================================================================
-- MENU_MODIFIERS TABLE
-- ============================================================================

CREATE TABLE menu_modifiers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    item_id UUID NOT NULL REFERENCES menu_items(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    type modifier_type NOT NULL DEFAULT 'single',
    required BOOLEAN NOT NULL DEFAULT FALSE,
    min_selections INTEGER,
    max_selections INTEGER,

    -- Options (JSONB array)
    -- Example: [{"name": "Small", "price": 0}, {"name": "Large", "price": 1.50}]
    options JSONB NOT NULL DEFAULT '[]',

    display_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT menu_modifiers_name_not_empty CHECK (length(trim(name)) > 0),
    CONSTRAINT menu_modifiers_selections_valid CHECK (
        (min_selections IS NULL OR min_selections >= 0) AND
        (max_selections IS NULL OR max_selections >= min_selections)
    )
);

CREATE INDEX idx_menu_modifiers_item_id ON menu_modifiers(item_id);
CREATE INDEX idx_menu_modifiers_display_order ON menu_modifiers(item_id, display_order);

COMMENT ON TABLE menu_modifiers IS 'Item modifiers/add-ons (e.g., size, toppings)';
COMMENT ON COLUMN menu_modifiers.type IS 'single = radio buttons, multiple = checkboxes';
COMMENT ON COLUMN menu_modifiers.options IS 'JSONB array of {name, price} objects';

-- ============================================================================
-- INVENTORY TABLE
-- ============================================================================

CREATE TABLE inventory (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
    item_id UUID NOT NULL REFERENCES menu_items(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL DEFAULT 0,
    low_stock_threshold INTEGER NOT NULL DEFAULT 10,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT inventory_unique_store_item UNIQUE(store_id, item_id),
    CONSTRAINT inventory_quantity_non_negative CHECK (quantity >= 0),
    CONSTRAINT inventory_threshold_non_negative CHECK (low_stock_threshold >= 0)
);

CREATE INDEX idx_inventory_store_id ON inventory(store_id);
CREATE INDEX idx_inventory_item_id ON inventory(item_id);
CREATE INDEX idx_inventory_low_stock ON inventory(store_id) WHERE quantity <= low_stock_threshold;

COMMENT ON TABLE inventory IS 'Inventory tracking per store (only for items with inventory_tracked=true)';
COMMENT ON COLUMN inventory.low_stock_threshold IS 'Alert when quantity falls below this value';

-- ============================================================================
-- ENABLE ROW LEVEL SECURITY
-- ============================================================================

ALTER TABLE menu_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_modifiers ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory ENABLE ROW LEVEL SECURITY;

-- Note: RLS policies will be defined in a separate migration (00009_rls_policies.sql)
