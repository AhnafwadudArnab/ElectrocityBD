# ElectrocityBD – Database (MySQL)

This folder holds **MySQL schema and sample data** for the ElectrocityBD e-commerce app. The schema is aligned with the **Node.js backend** in `backend/`.

## Files

| File | Purpose |
|------|--------|
| **electrocity_schema.sql** | CREATE DATABASE, all tables, indexes. No data. |
| **electrocity_sample_data.sql** | Sample categories, brands, products, promotions, flash sales, etc. Run after schema. |
| **electrocity_assets_products.sql** | Category-wise products from app assets (image_url = `asset:assets/...`). Run after sample_data. |
| **All_db.sql** | One-file setup: schema + sample data (no admin user). |

## Backend link

- **Backend folder:** `backend/`
- **DB config:** `backend/config/db.js` (uses `.env`: `DB_NAME=electrocity_db`)
- **Init script:** `backend/config/init_db.js` creates the same tables and seeds an **admin user** with a bcrypt-hashed password.

So you can either:

1. **Use the backend (recommended):**  
   `cd backend && npm run db:init`  
   This creates the database, all tables, and the admin user (email: `ahnaf@electrocitybd.com`, password: `1234@`).

2. **Use MySQL only:**  
   - Run `electrocity_schema.sql` then `electrocity_sample_data.sql` (or run `All_db.sql` for schema + sample data).  
   - Create the admin user via the backend once (e.g. run `npm run db:init`), or add a user manually with a bcrypt hash.

## Quick import (MySQL CLI)

```bash
mysql -u root -p < lib/Database/electrocity_schema.sql
mysql -u root -p electrocity_db < lib/Database/electrocity_sample_data.sql
```

Or single file:

```bash
mysql -u root -p < lib/Database/All_db.sql
```

## Tables (same as backend)

- **users** – customers and admin (password hashed in backend)
- **brands**, **categories**, **products** – catalog
- **discounts** – product discounts
- **cart** – per-user cart items
- **orders**, **order_items** – orders and line items
- **wishlists** – user wishlists
- **customer_support** – support tickets
- **promotions**, **flash_sales**, **flash_sale_products** – promotions and flash sales
- **collections**, **collection_products** – product collections
- **deals_of_the_day**, **best_sellers**, **trending_products**, **tech_part_products** – homepage sections (which products show where)
- **reports** – admin reports

## How product images work (real-website flow)

1. **Upload:** Admin adds a product in the app and uploads an image → backend saves the file in `backend/uploads/` and stores the path (e.g. `/uploads/1234567890-photo.jpg`) in `products.image_url`.
2. **Show on site:** All product lists (Best Selling, Flash Sale, Trending, Deals of the Day, Tech Part) load from the API. The API returns `image_url`; the app shows the image from **base URL + image_url** (e.g. `http://localhost:3000/uploads/1234567890-photo.jpg`).
3. **Sections:** A product appears on a homepage section only if it is listed in the right table: `best_sellers`, `flash_sale_products`, `trending_products`, `deals_of_the_day`, or `tech_part_products`. Admin can assign products to sections via the Products page (or section APIs).

4. **Asset products (category-wise):** Run `electrocity_assets_products.sql` after sample_data to load all app asset images into DB as products with `image_url = 'asset:assets/prod/...'` (or `asset:assets/flash/...`, etc.). The app shows these from Flutter assets; new uploads from Admin use `/uploads/...` and load from network. Category pages (Kitchen, Personal Care, Home Comfort) load products from API by `category_id`, so DB products and new ones join together.
