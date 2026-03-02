# Database Migration Instructions

## Purpose
This migration adds `created_at` columns to section tables so that newly added products from the admin panel appear first in "See All" pages.

## Affected Tables
- `best_sellers` - Added `created_at` column
- `deals_of_the_day` - Added `created_at` column  
- `tech_part_products` - Renamed `added_at` to `created_at` for consistency
- `flash_sale_products` - Already has `created_at` (no changes needed)
- `trending_products` - Already has `created_at` (no changes needed)

## How to Run

### Option 1: Using MySQL Command Line
```bash
mysql -u root -p electrobd < add_created_at_columns.sql
```

### Option 2: Using phpMyAdmin
1. Open phpMyAdmin
2. Select `electrobd` database
3. Go to SQL tab
4. Copy and paste contents of `add_created_at_columns.sql`
5. Click "Go"

### Option 3: Using MySQL Workbench
1. Open MySQL Workbench
2. Connect to your database
3. Open `add_created_at_columns.sql` file
4. Execute the script

## Sorting Behavior After Migration

### Before Migration
Products were sorted by:
- Best Sellers: `sales_count DESC`
- Trending: `display_order ASC, trending_score DESC`
- Flash Sale: `display_order ASC, end_time ASC`
- Deals: `end_date ASC`
- Tech Part: `display_order ASC`

### After Migration
Products are now sorted by:
- Best Sellers: `created_at DESC, sales_count DESC` ✅ **New products first**
- Trending: `created_at DESC, display_order ASC, trending_score DESC` ✅ **New products first**
- Flash Sale: `created_at DESC, display_order ASC, end_time ASC` ✅ **New products first**
- Deals: `created_at DESC, end_date ASC` ✅ **New products first**
- Tech Part: `created_at DESC, display_order ASC` ✅ **New products first**

## Verification

After running the migration, verify the changes:

```sql
-- Check if columns exist
DESCRIBE best_sellers;
DESCRIBE deals_of_the_day;
DESCRIBE tech_part_products;

-- Check if indexes were created
SHOW INDEX FROM best_sellers;
SHOW INDEX FROM deals_of_the_day;
SHOW INDEX FROM tech_part_products;
```

## Backend Changes

The following PHP files were updated to use the new sorting:
- `backend/models/product.php`
  - `getBestSellers()` - Now sorts by `created_at DESC`
  - `getTrending()` - Now sorts by `created_at DESC`
  - `getFlashSale()` - Now sorts by `created_at DESC`
  - `getDealsOfDay()` - Now sorts by `created_at DESC`
  - `getTechPart()` - Now sorts by `created_at DESC`

## Testing

1. Add a new product to any section via Admin Panel
2. Go to the corresponding "See All" page
3. The newly added product should appear at the top of the list

## Rollback (if needed)

If you need to revert the changes:

```sql
-- Remove created_at from best_sellers
ALTER TABLE best_sellers DROP COLUMN created_at;

-- Remove created_at from deals_of_the_day
ALTER TABLE deals_of_the_day DROP COLUMN created_at;

-- Rename back to added_at in tech_part_products
ALTER TABLE tech_part_products CHANGE COLUMN created_at added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Drop indexes
DROP INDEX idx_best_sellers_created ON best_sellers;
DROP INDEX idx_deals_created ON deals_of_the_day;
DROP INDEX idx_techpart_created ON tech_part_products;
```
