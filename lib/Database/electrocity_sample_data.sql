-- ============================================================
-- ElectrocityBD - Sample Data
-- Run after electrocity_schema.sql
-- Admin user: create via backend "npm run db:init" (password is hashed with bcrypt)
-- ============================================================

USE electrocity_db;

-- ---------------------------------------------------------------------------
-- Categories
-- ---------------------------------------------------------------------------
INSERT IGNORE INTO categories (category_name, category_image) VALUES
('Kitchen Appliances', 'kitchen.png'),
('Personal Care & Lifestyle', 'personalcare.png'),
('Home Comfort & Utility', 'homecomfort.png'),
('Lighting', 'lighting.png'),
('Wiring', 'wiring.png'),
('Tools', 'tools.png');

-- ---------------------------------------------------------------------------
-- Brands
-- ---------------------------------------------------------------------------
INSERT IGNORE INTO brands (brand_name, brand_logo) VALUES
('Philips', 'philips_logo.png'),
('Walton', 'walton_logo.png'),
('Samsung', 'samsung_logo.png');

-- ---------------------------------------------------------------------------
-- Products (category_id, brand_id, product_name, description, price, stock, image_url)
-- ---------------------------------------------------------------------------
INSERT IGNORE INTO products (category_id, brand_id, product_name, description, price, stock_quantity, image_url) VALUES
(1, 1, 'LED Bulb', 'Energy saving LED bulb', 150.00, 100, 'led_bulb.png'),
(1, 1, 'Tube Light', 'Bright tube light', 250.00, 50, 'tube_light.png'),
(5, 2, 'Copper Wire', 'High quality copper wire', 500.00, 200, 'copper_wire.png'),
(6, 2, 'Screwdriver Set', 'Multi-purpose screwdriver set', 350.00, 75, 'screwdriver_set.png'),
(1, 3, 'Smart LED Strip', 'RGB Smart LED Strip 5m', 1200.00, 30, 'led_strip.png'),
(3, 2, 'Electric Iron', 'Walton Electric Iron', 1500.00, 40, 'electric_iron.png');

-- ---------------------------------------------------------------------------
-- Sample customer (plain password for dev only - use backend for bcrypt in production)
-- Optional: INSERT INTO users (full_name, last_name, email, password, role) VALUES
--   ('Test', 'User', 'customer@test.com', '<bcrypt_hash_from_backend>', 'customer');
-- ---------------------------------------------------------------------------

-- ---------------------------------------------------------------------------
-- Sample promotions
-- ---------------------------------------------------------------------------
INSERT IGNORE INTO promotions (title, description, discount_percent, start_date, end_date, active) VALUES
('Winter Sale', 'Up to 20% off on lighting', 20.00, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY), TRUE),
('Tools Discount', '10% off on tools', 10.00, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 60 DAY), TRUE);

-- ---------------------------------------------------------------------------
-- Sample flash sale
-- ---------------------------------------------------------------------------
INSERT IGNORE INTO flash_sales (title, start_time, end_time, active) VALUES
('Flash Sale', NOW(), DATE_ADD(NOW(), INTERVAL 12 HOUR), TRUE);

INSERT IGNORE INTO flash_sale_products (flash_sale_id, product_id) VALUES
(1, 1), (1, 2);

-- ---------------------------------------------------------------------------
-- Sample collection
-- ---------------------------------------------------------------------------
INSERT IGNORE INTO collections (name, description, image_url) VALUES
('Home Essentials', 'Must-have products for every home', 'home_essentials.png');

INSERT IGNORE INTO collection_products (collection_id, product_id) VALUES
(1, 1), (1, 4);

-- ---------------------------------------------------------------------------
-- Deals of the day / Best sellers / Trending (optional)
-- ---------------------------------------------------------------------------
INSERT IGNORE INTO deals_of_the_day (product_id, deal_price, start_date, end_date) VALUES
(1, 120.00, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY));

INSERT IGNORE INTO best_sellers (product_id, sales_count) VALUES (1, 50);
INSERT IGNORE INTO trending_products (product_id, trending_score) VALUES (2, 80);
