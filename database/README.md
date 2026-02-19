# ElectrocityBD MySQL Setup

এই folder-এ backend ছাড়া full database baseline রাখা হয়েছে, যাতে পরে API/Node/Java/PHP যেটা লাগবে সেটার সাথে direct connect করা যায়।

## Included Files

- `01_schema.sql` → production-style normalized schema
- `02_seed.sql` → demo/sample data (products, users, order, payment, banners)
- `docker-compose.yml` → one-command MySQL boot
- `api_contract_openapi.yaml` → backend-ready OpenAPI contract
- `API_CONTRACT.md` → endpoint/module mapping guide

## Database Design (Real-time ecommerce style)

Schema-তে key modules আছে:

- **Auth & Profile:** `users`, `user_addresses`
- **Catalog:** `categories`, `brands`, `products`, `product_images`, `product_specs`, `inventory`
- **Shopping:** `carts`, `cart_items`, `wishlist_items`, `coupons`
- **Checkout & Payments:** `orders`, `order_items`, `payments`, `order_status_history`
- **Homepage/Marketing:** `banners`, `promotions`, `product_promotions`
- **Fast read view:** `v_product_catalog`

## Quick Run (Docker)

`database` folder-এ terminal open করে run করো:

```bash
docker compose up -d
```

Then connect with:

- Host: `127.0.0.1`
- Port: `3306`
- DB: `electrocitybd`
- User: `electrocity`
- Password: `electrocity123`
- Root Password: `root123`

## Manual Run (No Docker)

MySQL server already installed থাকলে:

```sql
SOURCE database/01_schema.sql;
SOURCE database/02_seed.sql;
```

## Notes for Later Backend Integration

- Flutter app-এর local providers (`CartProvider`, `WishlistProvider`, `AuthSession`) পরে API দিয়ে এই table structure-এ map করা যাবে।
- `orders.order_no` unique রাখা হয়েছে (invoice/order tracking-এর জন্য)
- `payments.transaction_id` unique রাখা হয়েছে (bKash/Nagad transaction validation)
- Search/filter performance এর জন্য প্রয়োজনীয় indexes দেওয়া আছে।

## Production Hardening (Later)

Backend করার সময় এগুলো add করা ভালো:

1. Migration tool (`Flyway`/`Liquibase`/`Prisma`)
2. DB user role separation (app user, read-only user)
3. Secrets via env/secret manager (hardcoded password নয়)
4. Automated backup + restore test
5. Query audit/log monitoring
