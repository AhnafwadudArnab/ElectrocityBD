-- ============================================================
-- ElectrocityBD - Complete MySQL Database Setup
-- This file creates the database, schema, and sample data
-- 
-- Usage:
--   mysql -u root -p < COMPLETE_DATABASE_SETUP.sql
-- 
-- Or in MySQL command line:
--   source /path/to/COMPLETE_DATABASE_SETUP.sql
-- 
-- Architecture: Flutter → PHP Backend (port 8000) → MySQL (port 3306)
-- Database: electrocity_db
-- ============================================================

-- Drop existing database if you want a fresh start (CAUTION: This deletes all data!)
-- DROP DATABASE IF EXISTS electrocity_db;

-- Create database
CREATE DATABASE IF NOT EXISTS electrocity_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE electrocity_db;

-- ============================================================
-- SCHEMA CREATION
-- ============================================================

-- ---------------------------------------------------------------------------
-- 1. Users (customers + admin)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(50) NOT NULL DEFAULT '',
  email VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  phone_number VARCHAR(20),
  address TEXT,
  gender VARCHAR(10) DEFAULT 'Male',
  role ENUM('admin','customer') DEFAULT 'customer',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- 2. User profile (synced with users; used in orders)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS user_profile (
  user_id INT PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(50) NOT NULL DEFAULT '',
  phone_number VARCHAR(20),
  address TEXT,
  gender VARCHAR(10) DEFAULT 'Male',
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- 3. Brands
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS brands (
  brand_id INT AUTO_INCREMENT PRIMARY KEY,
  brand_name VARCHAR(100) NOT NULL,
  brand_logo VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- 4. Categories
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS categories (
  category_id INT AUTO_INCREMENT PRIMARY KEY,
  category_name VARCHAR(50) NOT NULL,
  category_image VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- 5. Products
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS products (
  product_id INT AUTO_INCREMENT PRIMARY KEY,
  category_id INT,
  brand_id INT,
  product_name VARCHAR(150) NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  stock_quantity INT DEFAULT 0,
  image_url VARCHAR(255),
  specs_json TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL,
  FOREIGN KEY (brand_id) REFERENCES brands(brand_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- 6. Product Reviews
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS reviews (
  review_id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT NOT NULL,
  user_id INT,
  rating INT CHECK (rating >= 1 AND rating <= 5),
  review_text TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- 7. Discounts
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS discounts (
  discount_id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT,
  discount_percent DECIMAL(5,2),
  valid_from DATE,
  valid_to DATE,
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- 8. Cart
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS cart (
  cart_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  product_id INT,
  quantity INT DEFAULT 1,
  added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- 9. Orders
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS orders (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  total_amount DECIMAL(10,2) NOT NULL,
  order_status ENUM('pending','processing','shipped','delivered','cancelled') DEFAULT 'pending',
  payment_method VARCHAR(50) DEFAULT 'Cash on Delivery',
  payment_status ENUM('unpaid','paid') DEFAULT 'unpaid',
  delivery_address TEXT,
  transaction_id VARCHAR(100),
  estimated_delivery VARCHAR(50),
  order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- 10. Order items
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS order_items (
  order_item_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT,
  product_id INT,
  product_name VARCHAR(150),
  quantity INT NOT NULL,
  price_at_purchase DECIMAL(10,2) NOT NULL,
  color VARCHAR(50) DEFAULT '',
  image_url VARCHAR(255),
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- 11. Wishlists
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS wishlists (
  wishlist_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  product_id INT,
  added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- 12. Customer support
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS customer_support (
  ticket_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  subject VARCHAR(150) NOT NULL,
  message TEXT NOT NULL,
  status ENUM('open','in_progress','resolved','closed') DEFAULT 'open',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  resolved_by INT NULL,
  resolved_at TIMESTAMP NULL,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
  FOREIGN KEY (resolved_by) REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- 13. Promotions
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS promotions (
  promotion_id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(100) NOT NULL,
  description TEXT,
  discount_percent DECIMAL(5,2),
  start_date DATE,
  end_date DATE,
  active BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- 14. Flash sales
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS flash_sales (
  flash_sale_id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(100),
  start_time DATETIME,
  end_time DATETIME,
  active BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS flash_sale_products (
  flash_sale_id INT,
  product_id INT,
  PRIMARY KEY (flash_sale_id, product_id),
  FOREIGN KEY (flash_sale_id) REFERENCES flash_sales(flash_sale_id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- 15. Collections (Admin can manage collections like Fans, Cookers, Blenders)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS collections (
  collection_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  slug VARCHAR(100) UNIQUE NOT NULL,
  description TEXT,
  icon VARCHAR(50),
  image_url VARCHAR(255),
  item_count INT DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  display_order INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Collection items/categories (e.g., Fans -> Charger Fan, Mini Hand Fan)
CREATE TABLE IF NOT EXISTS collection_items (
  item_id INT AUTO_INCREMENT PRIMARY KEY,
  collection_id INT NOT NULL,
  item_name VARCHAR(100) NOT NULL,
  display_order INT DEFAULT 0,
  FOREIGN KEY (collection_id) REFERENCES collections(collection_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Products in collections
CREATE TABLE IF NOT EXISTS collection_products (
  collection_id INT,
  product_id INT,
  added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (collection_id, product_id),
  FOREIGN KEY (collection_id) REFERENCES collections(collection_id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- 16. Deals of the day
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS deals_of_the_day (
  deal_id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT,
  deal_price DECIMAL(10,2),
  start_date DATETIME,
  end_date DATETIME,
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- 17. Best sellers / Trending
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS best_sellers (
  product_id INT PRIMARY KEY,
  sales_count INT DEFAULT 0,
  last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS trending_products (
  product_id INT PRIMARY KEY,
  trending_score INT DEFAULT 0,
  last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- 18. Tech Part (homepage section)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tech_part_products (
  product_id INT PRIMARY KEY,
  display_order INT DEFAULT 0,
  added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- 19. Banners (Hero, Mid, Sidebar banners for homepage)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS banners (
  banner_id INT AUTO_INCREMENT PRIMARY KEY,
  banner_type ENUM('hero','mid','sidebar') NOT NULL,
  image_url VARCHAR(255) NOT NULL,
  link_url VARCHAR(255),
  title VARCHAR(100),
  description TEXT,
  button_text VARCHAR(50),
  display_order INT DEFAULT 0,
  active BOOLEAN DEFAULT TRUE,
  start_date DATE,
  end_date DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- 20. Payments
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS payments (
  payment_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT,
  payment_method VARCHAR(50),
  transaction_id VARCHAR(100),
  amount DECIMAL(10,2),
  payment_status ENUM('pending','completed','failed') DEFAULT 'pending',
  payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- 21. Admin reports
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS reports (
  report_id INT AUTO_INCREMENT PRIMARY KEY,
  admin_id INT,
  report_type VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  details TEXT,
  FOREIGN KEY (admin_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- 22. Site Settings
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS site_settings (
  setting_key VARCHAR(100) PRIMARY KEY,
  setting_value TEXT,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- 23. Search History (for search suggestions and analytics)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS search_history (
  search_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NULL,
  search_query VARCHAR(255) NOT NULL,
  results_count INT DEFAULT 0,
  searched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
  INDEX idx_search_query (search_query),
  INDEX idx_searched_at (searched_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- 24. Product Specifications (for detailed product specs)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS product_specifications (
  spec_id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT NOT NULL,
  spec_key VARCHAR(100) NOT NULL,
  spec_value TEXT NOT NULL,
  display_order INT DEFAULT 0,
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
  INDEX idx_product_specs (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- Indexes for performance
-- ---------------------------------------------------------------------------
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_brand ON products(brand_id);
CREATE INDEX idx_products_name ON products(product_name);
CREATE INDEX idx_cart_user ON cart(user_id);
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_orders_status ON orders(order_status);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_wishlists_user ON wishlists(user_id);
CREATE INDEX idx_customer_support_user ON customer_support(user_id);
CREATE INDEX idx_customer_support_status ON customer_support(status);
CREATE INDEX idx_reviews_product ON reviews(product_id);
CREATE INDEX idx_reviews_user ON reviews(user_id);

-- ============================================================
-- SAMPLE DATA INSERTION
-- ============================================================

-- ---------------------------------------------------------------------------
-- Categories
-- ---------------------------------------------------------------------------
INSERT INTO categories (category_id, category_name, category_image) VALUES
(1, 'Kitchen Appliances', '/assets/categories/kitchen.png'),
(2, 'Personal Care & Lifestyle', '/assets/categories/personalcare.png'),
(3, 'Home Comfort & Utility', '/assets/categories/homecomfort.png'),
(4, 'Lighting', '/assets/categories/lighting.png'),
(5, 'Wiring', '/assets/categories/wiring.png'),
(6, 'Tools', '/assets/categories/tools.png')
ON DUPLICATE KEY UPDATE category_name=VALUES(category_name);

-- ---------------------------------------------------------------------------
-- Brands
-- ---------------------------------------------------------------------------
INSERT INTO brands (brand_id, brand_name, brand_logo) VALUES
(1, 'Philips', '/assets/brands/philips_logo.png'),
(2, 'Walton', '/assets/brands/walton_logo.png'),
(3, 'Samsung', '/assets/brands/samsung_logo.png'),
(4, 'LG', '/assets/brands/lg_logo.png'),
(5, 'Sony', '/assets/brands/sony_logo.png')
ON DUPLICATE KEY UPDATE brand_name=VALUES(brand_name);

-- ---------------------------------------------------------------------------
-- Products
-- ---------------------------------------------------------------------------
INSERT INTO products (product_id, category_id, brand_id, product_name, description, price, stock_quantity, image_url) VALUES
(1, 4, 1, 'LED Bulb 9W', 'Energy saving LED bulb with 9W power', 150.00, 100, '/assets/products/led_bulb.png'),
(2, 4, 1, 'Tube Light 20W', 'Bright tube light for home and office', 250.00, 50, '/assets/products/tube_light.png'),
(3, 5, 2, 'Copper Wire 2.5mm', 'High quality copper wire for electrical wiring', 500.00, 200, '/assets/products/copper_wire.png'),
(4, 6, 2, 'Screwdriver Set', 'Multi-purpose screwdriver set with 6 pieces', 350.00, 75, '/assets/products/screwdriver_set.png'),
(5, 4, 3, 'Smart LED Strip 5m', 'RGB Smart LED Strip with remote control', 1200.00, 30, '/assets/products/led_strip.png'),
(6, 3, 2, 'Electric Iron', 'Walton Electric Iron with temperature control', 1500.00, 40, '/assets/products/electric_iron.png'),
(7, 1, 1, 'Rice Cooker 1.8L', 'Philips Rice Cooker with keep warm function', 2500.00, 25, '/assets/products/rice_cooker.png'),
(8, 1, 2, 'Blender 500W', 'Walton Blender with 3 speed settings', 1800.00, 35, '/assets/products/blender.png'),
(9, 2, 3, 'Hair Dryer', 'Samsung Hair Dryer with cool shot button', 1200.00, 45, '/assets/products/hair_dryer.png'),
(10, 3, 4, 'Table Fan 16"', 'LG Table Fan with 3 speed settings', 2200.00, 20, '/assets/products/table_fan.png')
ON DUPLICATE KEY UPDATE product_name=VALUES(product_name), price=VALUES(price), stock_quantity=VALUES(stock_quantity);

-- ---------------------------------------------------------------------------
-- Admin User (password: admin123 - hashed with bcrypt)
-- Note: Use backend API to create users with proper password hashing
-- ---------------------------------------------------------------------------
INSERT INTO users (user_id, full_name, last_name, email, password, role) VALUES
(1, 'Admin', 'User', 'admin@electrocitybd.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin')
ON DUPLICATE KEY UPDATE email=VALUES(email);

-- ---------------------------------------------------------------------------
-- Sample Promotions
-- ---------------------------------------------------------------------------
INSERT INTO promotions (title, description, discount_percent, start_date, end_date, active) VALUES
('Winter Sale', 'Up to 20% off on lighting products', 20.00, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY), TRUE),
('Tools Discount', '10% off on all tools', 10.00, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 60 DAY), TRUE)
ON DUPLICATE KEY UPDATE title=VALUES(title);

-- ---------------------------------------------------------------------------
-- Sample Flash Sale
-- ---------------------------------------------------------------------------
INSERT INTO flash_sales (flash_sale_id, title, start_time, end_time, active) VALUES
(1, 'Flash Sale - Electronics', NOW(), DATE_ADD(NOW(), INTERVAL 12 HOUR), TRUE)
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO flash_sale_products (flash_sale_id, product_id) VALUES
(1, 1), (1, 2), (1, 5)
ON DUPLICATE KEY UPDATE flash_sale_id=VALUES(flash_sale_id);

-- ---------------------------------------------------------------------------
-- Sample Collections (matching the app's collections)
-- ---------------------------------------------------------------------------
INSERT INTO collections (collection_id, name, slug, description, icon, item_count, is_active, display_order) VALUES
(1, 'Fans', 'fans', 'Cooling solutions for your home', 'air', 20, TRUE, 1),
(2, 'Cookers', 'cookers', 'Kitchen cooking appliances', 'soup_kitchen', 46, TRUE, 2),
(3, 'Blenders', 'blenders', 'Blending and mixing solutions', 'blender', 38, TRUE, 3),
(4, 'Phone Related', 'phone-related', 'Phone accessories and devices', 'phone', 14, TRUE, 4),
(5, 'Massager Items', 'massager-items', 'Relaxation and massage products', 'spa', 18, TRUE, 5),
(6, 'Trimmer', 'trimmer', 'Personal grooming tools', 'content_cut', 15, TRUE, 6),
(7, 'Electric Chula', 'electric-chula', 'Electric cooking stoves', 'local_fire_department', 10, TRUE, 7),
(8, 'Iron', 'iron', 'Ironing solutions', 'iron', 18, TRUE, 8),
(9, 'Chopper', 'chopper', 'Food chopping tools', 'cut', 12, TRUE, 9),
(10, 'Grinder', 'grinder', 'Grinding appliances', 'settings', 10, TRUE, 10),
(11, 'Kettle', 'kettle', 'Water boiling solutions', 'coffee_maker', 25, TRUE, 11),
(12, 'Hair Dryer', 'hair-dryer', 'Hair drying tools', 'air', 14, TRUE, 12),
(13, 'Oven', 'oven', 'Baking and cooking ovens', 'microwave', 8, TRUE, 13),
(14, 'Air Fryer', 'air-fryer', 'Healthy frying solutions', 'kitchen', 18, TRUE, 14)
ON DUPLICATE KEY UPDATE name=VALUES(name), item_count=VALUES(item_count);

-- Collection items/categories
INSERT INTO collection_items (collection_id, item_name, display_order) VALUES
-- Fans
(1, 'Charger Fan', 1),
(1, 'Mini Hand Fan', 2),
-- Cookers
(2, 'Rice Cooker', 1),
(2, 'Mini Cooker', 2),
(2, 'Curry Cooker', 3),
-- Blenders
(3, 'Hand Blender', 1),
(3, 'Blender', 2),
-- Phone Related
(4, 'Telephone Set', 1),
(4, 'Sim Telephone', 2),
-- Massager Items
(5, 'Massage Gun', 1),
(5, 'Head Massage', 2)
ON DUPLICATE KEY UPDATE item_name=VALUES(item_name);

INSERT INTO collection_products (collection_id, product_id) VALUES
(1, 10), -- Fans collection
(2, 7), (2, 8), -- Cookers collection
(3, 8) -- Blenders collection
ON DUPLICATE KEY UPDATE collection_id=VALUES(collection_id);

-- ---------------------------------------------------------------------------
-- Deals of the Day
-- ---------------------------------------------------------------------------
INSERT INTO deals_of_the_day (product_id, deal_price, start_date, end_date) VALUES
(1, 120.00, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),
(2, 200.00, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),
(5, 1000.00, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY))
ON DUPLICATE KEY UPDATE deal_price=VALUES(deal_price);

-- ---------------------------------------------------------------------------
-- Best Sellers
-- ---------------------------------------------------------------------------
INSERT INTO best_sellers (product_id, sales_count) VALUES 
(1, 150), (2, 120), (3, 100), (7, 90), (8, 85), (10, 80)
ON DUPLICATE KEY UPDATE sales_count=VALUES(sales_count);

-- ---------------------------------------------------------------------------
-- Trending Products
-- ---------------------------------------------------------------------------
INSERT INTO trending_products (product_id, trending_score) VALUES 
(1, 95), (5, 90), (7, 85), (8, 80), (9, 75), (10, 70)
ON DUPLICATE KEY UPDATE trending_score=VALUES(trending_score);

-- ---------------------------------------------------------------------------
-- Tech Part Products
-- ---------------------------------------------------------------------------
INSERT INTO tech_part_products (product_id, display_order) VALUES 
(5, 1), (9, 2), (10, 3), (7, 4)
ON DUPLICATE KEY UPDATE display_order=VALUES(display_order);

-- ---------------------------------------------------------------------------
-- Sample Banners (Hero, Mid, Sidebar)
-- ---------------------------------------------------------------------------
INSERT INTO banners (banner_type, image_url, link_url, title, description, button_text, display_order, active, start_date, end_date) VALUES
-- Hero Banners
('hero', '/uploads/banners/hero_kitchen_sale.jpg', '/collections/cookers', 'Kitchen Appliances Sale', 'Up to 30% off on all kitchen items', 'Shop Now', 1, TRUE, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY)),
('hero', '/uploads/banners/hero_smart_home.jpg', '/collections/fans', 'Smart Home Solutions', 'Transform your home with smart appliances', 'Explore', 2, TRUE, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY)),
('hero', '/uploads/banners/hero_personal_care.jpg', '/collections/hair-dryer', 'Personal Care Essentials', 'Grooming products for everyone', 'Discover', 3, TRUE, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY)),

-- Mid Banners
('mid', '/uploads/banners/mid_daily_deals.jpg', '/deals', 'Daily Deals', 'Check out today\'s amazing deals', 'View Deals', 1, TRUE, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY)),
('mid', '/uploads/banners/mid_new_arrivals.jpg', '/products?sort=newest', 'New Arrivals', 'Latest products just for you', 'See New', 2, TRUE, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 15 DAY)),

-- Sidebar Banners
('sidebar', '/uploads/banners/sidebar_flash_sale.jpg', '/flash-sale', 'Flash Sale', 'Limited time offer - Hurry up!', 'Buy Now', 1, TRUE, NOW(), DATE_ADD(NOW(), INTERVAL 12 HOUR)),
('sidebar', '/uploads/banners/sidebar_free_shipping.jpg', '/info/shipping', 'Free Shipping', 'On orders above ৳1000', 'Learn More', 2, TRUE, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 60 DAY))
ON DUPLICATE KEY UPDATE title=VALUES(title), active=VALUES(active);

-- ---------------------------------------------------------------------------
-- Site Settings
-- ---------------------------------------------------------------------------
INSERT INTO site_settings (setting_key, setting_value) VALUES 
('section_filter_best_sellers', '{"limit": 10, "sort": "sales_desc"}'),
('section_filter_trending', '{"limit": 10, "sort": "score_desc"}'),
('section_filter_deals', '{"limit": 10, "sort": "newest"}'),
('section_filter_flash_sale', '{"limit": 10, "sort": "newest"}'),
('section_filter_tech_part', '{"limit": 10, "sort": "display_order"}'),
('site_name', 'ElectrocityBD'),
('site_email', 'info@electrocitybd.com'),
('site_phone', '+880 1234-567890'),
('currency', 'BDT'),
('tax_rate', '0.00')
ON DUPLICATE KEY UPDATE setting_value=VALUES(setting_value);

-- ============================================================
-- SETUP COMPLETE
-- ============================================================

SELECT 'Database setup completed successfully!' AS Status;
SELECT COUNT(*) AS 'Total Products' FROM products;
SELECT COUNT(*) AS 'Total Categories' FROM categories;
SELECT COUNT(*) AS 'Total Brands' FROM brands;
SELECT COUNT(*) AS 'Total Collections' FROM collections;
SELECT COUNT(*) AS 'Total Collection Items' FROM collection_items;
SELECT COUNT(*) AS 'Total Banners' FROM banners;
SELECT COUNT(*) AS 'Total Users' FROM users;

-- Show connection info
SELECT 
    'electrocity_db' AS 'Database Name',
    '24 tables created' AS 'Tables',
    '127.0.0.1:3306' AS 'MySQL Server',
    'http://localhost:8000/api' AS 'Backend API',
    'Ready to connect!' AS 'Status';
