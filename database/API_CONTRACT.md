# ElectrocityBD API Contract (Backend Later Ready)

এই ডকুমেন্ট + `api_contract_openapi.yaml` backend team কে clear contract দেবে, যাতে frontend/backend parallel এ কাজ করতে পারে।

## Contract File

- OpenAPI Spec: `database/api_contract_openapi.yaml`

## DB → API Mapping (Quick)

- `users`, `user_addresses` → `/auth/*`, `/users/me`
- `categories`, `brands`, `products`, `product_images`, `product_specs`, `inventory` → `/categories`, `/products*`
- `carts`, `cart_items` → `/cart*`
- `wishlist_items` → `/wishlist*`
- `coupons` → `/coupons/validate`
- `orders`, `order_items`, `order_status_history` → `/orders*`
- `payments` → `/payments/*`
- `banners`, `promotions`, `product_promotions` → `/banners`, `/promotions/active`

## Suggested Status/Flow

1. User login/register
2. Browse/filter product
3. Cart add/update/remove
4. Coupon validate
5. Order create
6. Payment initiate + verify
7. Order status update + history log

## Backend Start করলে প্রথমে যেটা build করবে

1. Auth middleware (JWT)
2. Catalog read APIs
3. Cart APIs
4. Order + Payment flow
5. Wishlist + profile update

## Optional Tools

- Swagger UI দিয়ে spec দেখতে:
  - Docker: `docker run -p 8081:8080 -e SWAGGER_JSON=/spec/api_contract_openapi.yaml -v ${PWD}/database:/spec swaggerapi/swagger-ui`
  - তারপর browser: `http://localhost:8081`
