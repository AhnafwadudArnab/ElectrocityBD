# ElectrocityBD Database Files

## Overview
This folder contains all the MySQL database setup and fix files for the ElectrocityBD e-commerce platform.

## Main Files

### 1. COMPLETE_DATABASE_SETUP.sql (67,689 bytes)
**Complete database setup file** - This is the main file that contains everything you need to set up the entire database from scratch.

**Contents:**
- All table schemas (24 tables)
- Sample data for products, categories, brands
- Admin user setup
- Collections, deals, flash sales
- Stock management system
- Payment methods
- Product specifications
- Banners and promotions
- All indexes and foreign keys
- Triggers and stored procedures
- Views for reporting

**Usage:**
```bash
mysql -u root -p < DatabaseMysql/COMPLETE_DATABASE_SETUP.sql
```

### 2. fix_part.sql (18,870 bytes)
**Database fixes and improvements** - Apply this file after running COMPLETE_DATABASE_SETUP.sql or to fix existing databases.

**Contents:**
- **Critical Fixes:**
  - Unique email constraint
  - Product ratings table
  - Product reviews system with triggers
  - Performance indexes
  - CSRF tokens table
  - API rate limiting table

- **Order Issue Fixes:**
  - last_updated columns for best_sellers and trending_products
  - Fixes order placement issues for regular users

- **Created_at Columns:**
  - Adds created_at to all section tables
  - Enables sorting by newest products first
  - Indexes for better performance

- **Search Improvements:**
  - FULLTEXT indexes for fast search
  - Search suggestions table
  - Auto-update triggers for suggestions
  - Search ranking stored procedure
  - Popular and trending search views
  - Search analytics table

**Usage:**
```bash
mysql -u root -p electrobd < DatabaseMysql/fix_part.sql
```

## Other Files

### electrocity_schema.sql (11,546 bytes)
Basic schema without data - useful for understanding table structure.

### electrocity_sample_data.sql (4,328 bytes)
Sample data only - can be used to populate an existing schema.

### complete_db.sql (67,689 bytes)
Duplicate of COMPLETE_DATABASE_SETUP.sql for compatibility with older setup instructions.

## Setup Instructions

### Fresh Installation:
1. Create database and import complete setup:
   ```bash
  mysql -u root -p < DatabaseMysql/COMPLETE_DATABASE_SETUP.sql
   ```

2. Apply fixes and improvements:
   ```bash
   mysql -u root -p electrobd < DatabaseMysql/fix_part.sql
   ```

### Existing Database:
If you already have the database set up, just apply the fixes:
```bash
mysql -u root -p electrobd < DatabaseMysql/fix_part.sql
```

## Database Details

- **Database Name:** electrobd
- **Character Set:** utf8mb4
- **Collation:** utf8mb4_unicode_ci
- **Total Tables:** 24+
- **Default Admin:**
  - Email: admin@electrocitybd.com
  - Password: 1234@# (hashed with bcrypt)

## Key Features

1. **User Management:** Customers and admin roles
2. **Product Catalog:** 40+ sample products with specifications
3. **Collections:** 14 product collections (Fans, Cookers, Blenders, etc.)
4. **Shopping Features:** Cart, wishlist, orders
5. **Promotions:** Flash sales, deals of the day, best sellers, trending
6. **Stock Management:** Complete stock tracking with movements and alerts
7. **Search System:** Advanced search with suggestions and analytics
8. **Reviews & Ratings:** Product review system with automatic rating calculation
9. **Payment Methods:** Multiple payment options including bKash, Nagad, COD
10. **Security:** CSRF tokens, rate limiting, password reset tokens

## Fixing Files Folder

The `Fixing files/` folder contains individual fix scripts that have been combined into `fix_part.sql`:
- FIX_CRITICAL_ISSUES.sql
- FIX_ORDER_ISSUE.sql
- SEARCH_IMPROVEMENTS.sql
- add_created_at_columns.sql
- And more...

These are kept for reference but you should use `fix_part.sql` instead.

## Notes

- All tables use InnoDB engine for transaction support
- Foreign keys are properly set up with CASCADE options
- Indexes are optimized for common queries
- Triggers automatically maintain data consistency
- Views provide easy access to complex queries
- Stored procedures handle atomic operations

## Support

For issues or questions, refer to the main project documentation or contact the development team.
