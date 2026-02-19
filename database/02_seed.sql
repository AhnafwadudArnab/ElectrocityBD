USE electrocitybd;

-- Users
INSERT INTO users (uuid, first_name, last_name, email, phone, gender, is_email_verified)
VALUES
  (UUID(), 'Demo', 'User', 'demo@electrocitybd.com', '+8801700000000', 'Male', 1),
  (UUID(), 'Ahana', 'Customer', 'ahana@electrocitybd.com', '+8801800000000', 'Female', 1);

-- Addresses
INSERT INTO user_addresses (user_id, label, recipient_name, phone, address_line_1, city, area, postal_code, is_default)
VALUES
  (1, 'Home', 'Demo User', '+8801700000000', 'House 12, Road 4, Dhanmondi', 'Dhaka', 'Dhanmondi', '1209', 1),
  (2, 'Office', 'Ahana Customer', '+8801800000000', 'Level 5, Agrabad Commercial Area', 'Chattogram', 'Agrabad', '4100', 1);

-- Categories
INSERT INTO categories (slug, name, description, sort_order) VALUES
  ('electronics', 'Electronics', 'General electronic products', 1),
  ('audio', 'Audio', 'Headphones and speakers', 2),
  ('television', 'Television', 'Smart TV and accessories', 3),
  ('peripherals', 'Peripherals', 'Computer input devices', 4),
  ('kitchen-appliances', 'Kitchen Appliances', 'Kitchen essentials', 5),
  ('personal-care', 'Personal Care', 'Personal care products', 6);

-- Brands
INSERT INTO brands (slug, name, logo_url) VALUES
  ('electrocitybd', 'ElectrocityBD', 'assets/Brand Logo/1.png'),
  ('generic-tech', 'Generic Tech', 'assets/Brand Logo/2.png');

-- Products
INSERT INTO products (
  sku, slug, name, short_description, description,
  category_id, brand_id, regular_price, sale_price, is_featured, is_trending, is_flash_sale, status
)
VALUES
  ('EC-HP-0001', 'premium-wireless-headphones', 'Premium Wireless Headphones', 'Noise cancelling wireless headphones',
   'High-quality wireless headphones with strong battery life and clear sound.',
   2, 1, 1250.00, 1099.00, 1, 1, 1, 'active'),

  ('EC-TV-0043', 'smart-led-tv-43', 'Smart LED TV 43 inch', '4K UHD Smart TV',
   'Ultra HD smart TV with streaming app support.',
   3, 1, 1850.00, 1699.00, 1, 0, 0, 'active'),

  ('EC-KB-0100', 'gaming-mechanical-keyboard', 'Gaming Mechanical Keyboard', 'RGB mechanical keyboard',
   'Mechanical keyboard with tactile switches and RGB backlight.',
   4, 2, 850.00, 799.00, 0, 1, 0, 'active'),

  ('EC-MS-2001', 'wireless-gaming-mouse', 'Wireless Gaming Mouse', 'Ergonomic wireless mouse',
   'Gaming mouse with adjustable DPI and rechargeable battery.',
   4, 2, 650.00, 599.00, 0, 1, 1, 'active');

-- Product Images
INSERT INTO product_images (product_id, image_url, alt_text, is_primary, sort_order) VALUES
  (1, 'assets/Products/1.png', 'Premium Wireless Headphones', 1, 1),
  (1, 'assets/Products/2.jpg', 'Headphones alternate image', 0, 2),
  (2, 'assets/Products/3.jpg', 'Smart LED TV 43 inch', 1, 1),
  (3, 'assets/Products/4.jpg', 'Gaming Mechanical Keyboard', 1, 1),
  (4, 'assets/Products/5.jpg', 'Wireless Gaming Mouse', 1, 1);

-- Product Specs
INSERT INTO product_specs (product_id, spec_key, spec_value, sort_order) VALUES
  (1, 'Connectivity', 'Bluetooth 5.0', 1),
  (1, 'Battery Life', '30 hours', 2),
  (1, 'Warranty', '1 year', 3),
  (2, 'Resolution', '4K UHD', 1),
  (2, 'Screen Size', '43 inches', 2),
  (3, 'Switch Type', 'Mechanical Blue', 1),
  (3, 'Backlight', 'RGB', 2),
  (4, 'DPI', '16000', 1),
  (4, 'Warranty', '1 year', 2);

-- Inventory
INSERT INTO inventory (product_id, stock_qty, low_stock_threshold, reserved_qty) VALUES
  (1, 20, 5, 0),
  (2, 12, 3, 0),
  (3, 40, 8, 0),
  (4, 32, 8, 0);

-- Coupons (from app SAVE10 / SAVE5)
INSERT INTO coupons (code, discount_type, discount_value, min_order_amount, max_discount_amount, usage_limit, starts_at, expires_at, is_active)
VALUES
  ('SAVE10', 'percent', 10.00, 1000.00, 500.00, 5000, NOW(), DATE_ADD(NOW(), INTERVAL 365 DAY), 1),
  ('SAVE5',  'percent', 5.00,  500.00, 250.00, 5000, NOW(), DATE_ADD(NOW(), INTERVAL 365 DAY), 1);

-- Promotions
INSERT INTO promotions (promo_type, title, description, discount_type, discount_value, starts_at, ends_at, is_active)
VALUES
  ('flash_sale', 'Flash Sale Week', 'Limited time discount for top products', 'percent', 15.00, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY), 1),
  ('deal_of_day', 'Deal of the Day', 'Daily rotating deal', 'percent', 8.00, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY), 1);

INSERT INTO product_promotions (product_id, promotion_id)
VALUES (1, 1), (4, 1), (2, 2);

-- Home banners / hero blocks
INSERT INTO banners (section_key, title, subtitle, image_url, cta_text, cta_link, sort_order, is_active, starts_at, ends_at)
VALUES
  ('hero', 'Mega Electronics Sale', 'Up to 90% OFF', 'assets/Hero banner logos/1.png', 'Shop Now', '/products', 1, 1, NOW(), DATE_ADD(NOW(), INTERVAL 90 DAY)),
  ('deals_of_day', 'Deals of the Day', 'Best deals picked for you', 'assets/Deals of the Day/1.png', 'View Deals', '/deals', 1, 1, NOW(), DATE_ADD(NOW(), INTERVAL 90 DAY)),
  ('flash_sale', 'Flash Sale', 'Limited stock available', 'assets/flash/1.png', 'Grab Fast', '/flash-sale', 1, 1, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY));

-- Wishlist sample
INSERT INTO wishlist_items (user_id, product_id)
VALUES (2, 1), (2, 3);

-- Cart sample
INSERT INTO carts (user_id, session_key, status)
VALUES (2, NULL, 'active');

INSERT INTO cart_items (cart_id, product_id, quantity, unit_price)
VALUES
  (1, 1, 1, 1099.00),
  (1, 4, 2, 599.00);

-- Demo order + payment
INSERT INTO orders (
  order_no, user_id, address_id, coupon_id, subtotal, discount_amount, shipping_amount, total_amount,
  payment_status, order_status, notes, placed_at
)
VALUES
  ('EC-20260219-0001', 2, 2, 1, 2297.00, 229.70, 120.00, 2187.30, 'paid', 'confirmed', 'Demo seeded order', NOW());

INSERT INTO order_items (order_id, product_id, product_name, product_sku, quantity, unit_price, line_total)
VALUES
  (1, 1, 'Premium Wireless Headphones', 'EC-HP-0001', 1, 1099.00, 1099.00),
  (1, 4, 'Wireless Gaming Mouse', 'EC-MS-2001', 2, 599.00, 1198.00);

INSERT INTO payments (order_id, method, provider, transaction_id, payer_phone, amount, status, paid_at, gateway_response)
VALUES
  (1, 'bkash', 'bKash', 'TRX-EC-20260219-0001', '+8801800000000', 2187.30, 'success', NOW(), JSON_OBJECT('source', 'seed', 'message', 'demo payment'));

INSERT INTO order_status_history (order_id, status, comment, changed_by)
VALUES
  (1, 'pending', 'Order created', 2),
  (1, 'confirmed', 'Payment verified', 2);
