-- ============================================================
-- ElectrocityBD - Complete MySQL Database Setup
DROP DATABASE IF EXISTS electrocity_db;

-- Create database
CREATE DATABASE IF NOT EXISTS electrobd CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE electrobd;
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
  flash_price DECIMAL(10,2),
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

-- Deals Timer Configuration (Admin can control countdown)
CREATE TABLE IF NOT EXISTS deals_timer (
  timer_id INT AUTO_INCREMENT PRIMARY KEY,
  days INT DEFAULT 3,
  hours INT DEFAULT 11,
  minutes INT DEFAULT 15,
  seconds INT DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- 17. Best sellers / Trending
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS best_sellers (
  product_id INT PRIMARY KEY,
  sales_count INT DEFAULT 0,
  selling_point TEXT,
  sales_strategy VARCHAR(255),
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


-- Payment Methods Table
CREATE TABLE IF NOT EXISTS payment_methods (
  method_id INT AUTO_INCREMENT PRIMARY KEY,
  method_name VARCHAR(100) NOT NULL,
  method_type VARCHAR(50) NOT NULL DEFAULT 'mobile_banking',
  is_enabled TINYINT(1) DEFAULT 1,
  account_number VARCHAR(50),
  display_order INT DEFAULT 0,
  icon_url VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default payment methods
INSERT INTO payment_methods (method_name, method_type, is_enabled, account_number, display_order) VALUES
('bKash', 'mobile_banking', 1, '019-XXXXXXXX', 1),
('Nagad', 'mobile_banking', 0, '019-XXXXXXXX', 2),
('Cash on Delivery', 'cash', 1, '', 3);




-- Password Reset Tokens Table
CREATE TABLE IF NOT EXISTS password_reset_tokens (
  token_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  email VARCHAR(100) NOT NULL,
  token VARCHAR(255) NOT NULL UNIQUE,
  expires_at DATETIME NOT NULL,
  used TINYINT(1) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  INDEX idx_token (token),
  INDEX idx_email (email),
  INDEX idx_expires (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Run this after creating base schema (electrocity_schema.sql or COMPLETE_DATABASE_SETUP.sql)
USE electrobd;

-- Ensure flash_sale_products has pricing and section-image/order support
ALTER TABLE flash_sale_products
  ADD COLUMN IF NOT EXISTS flash_price DECIMAL(10,2) NULL AFTER product_id,
  ADD COLUMN IF NOT EXISTS image_path VARCHAR(255) NULL AFTER flash_price,
  ADD COLUMN IF NOT EXISTS display_order INT DEFAULT 0 AFTER image_path;

-- Ensure trending_products has section-image/order support
ALTER TABLE trending_products
  ADD COLUMN IF NOT EXISTS image_path VARCHAR(255) NULL AFTER trending_score,
  ADD COLUMN IF NOT EXISTS display_order INT DEFAULT 0 AFTER image_path;

-- Optional helpful indexes
CREATE INDEX IF NOT EXISTS idx_flash_sale_products_order ON flash_sale_products(display_order);
CREATE INDEX IF NOT EXISTS idx_trending_products_order ON trending_products(display_order);




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
(1, 'Philips', '/assets/Brand Logo/images (1).png'),
(2, 'Walton', '/assets/Brand Logo/walton.png'),
(3, 'Samsung', '/assets/Brand Logo/images (2).png'),
(4, 'LG', '/assets/Brand Logo/LG.png'),
(5, 'Sony', '/assets/Brand Logo/images (3).png'),
(6, 'Gree', '/assets/Brand Logo/Gree.png'),
(7, 'Jamuna', '/assets/Brand Logo/jamuna.jpg'),
(8, 'Panasonic', '/assets/Brand Logo/panasonnic.png'),
(9, 'Singer', '/assets/Brand Logo/singer.png'),
(10, 'Vision', '/assets/Brand Logo/vision.jpg')
ON DUPLICATE KEY UPDATE brand_name=VALUES(brand_name), brand_logo=VALUES(brand_logo);

-- ---------------------------------------------------------------------------
-- Products (Deals of the Day products with real data)
-- ---------------------------------------------------------------------------
INSERT INTO products (product_id, category_id, brand_id, product_name, description, price, stock_quantity, image_url) VALUES
-- Deals of the Day Products (Products 1-18)
(1, 1, 2, 'Miyako Curry Cooker 5.5L', 'Family Reliable: 5.5L large capacity, non-stick coating, and automatic cooking mode. Best for cooking large portions of curry or rice for big families in one go.', 2500.00, 15, '/assets/Deals of the Day/miyoko.jpg'),
(2, 6, 2, 'Nima 2-in-1 Grinder 400W', 'Budget Friendly: 450W powerful motor, stainless steel blades, suitable for dry and wet grinding. The most popular choice for grinding spices or coffee quickly at a low price.', 1450.00, 25, '/assets/Deals of the Day/nima grinder.jpg'),
(3, 1, 2, 'Miyako Kettle 180 PS 1.8L', 'Quick Solution: 1.8L capacity, auto-shutoff feature (turns off automatically when water boils). The best choice for getting hot water for tea or coffee in just a few minutes.', 1450.00, 30, '/assets/Deals of the Day/miyoko kettle.jpg'),
(4, 2, 3, 'Sokany Hair Dryer HS-3820', 'Perfect Look: 2000-2200W power, hot and cold air options, includes concentrator nozzle. Affordable and durable for achieving a salon-style hair drying experience at home.', 1180.00, 20, '/assets/Deals of the Day/sokany dyer.jpg'),
(5, 3, 2, 'Kennede Charger Fan 2912', 'Load-shedding Master: 12-inch size, rechargeable battery, 5–6 hours backup, and built-in LED light. Your best friend during summer days due to its long-lasting battery backup.', 2200.00, 18, '/assets/Deals of the Day/kennede charger fan.jpg'),
(6, 1, 2, 'Miyako Pink Panther Blender 750W', 'All-in-One: 750W copper motor, 3 stainless steel jars, overload protection. Perfect for everything from making juice to grinding spice pastes.', 4050.00, 12, '/assets/Deals of the Day/pinkPanther blender.jpg'),
(7, 1, 2, 'NOHA Hotel King Blender 1050W', 'For Heavy Users: 1050W high-power motor, heavy-duty blades, anti-jam design. Extremely durable for those who require heavy blending every single day.', 4500.00, 10, '/assets/Deals of the Day/noha hot king.jpg'),
(8, 1, 2, 'AV Sandwich Maker 296', 'Instant Breakfast: Non-stick grill plates, fast heating technology, and easy to clean. An essential for modern kitchens to quickly prepare breakfast or tiffins.', 1400.00, 22, '/assets/Deals of the Day/av sandwich maker.jpg'),
(9, 1, 2, 'Miyako 25L Electric Oven', 'For Baking Lovers: 25L size, timer and temperature control, baking and grilling facilities. The best entry-level oven for baking cakes or making roasted chicken.', 5500.00, 8, '/assets/Deals of the Day/miyoko 25l oven.jpg'),

-- Additional Deals of the Day Products (matching static deals from frontend)
(10, 4, 3, 'Samsung CCTV Camera', 'High-quality security camera with night vision, motion detection, and remote viewing. Perfect for home and office security monitoring.', 8500.00, 12, '/assets/prod/1.png'),
(11, 1, 2, 'Walton Blender 3-in-1 Machine', 'Versatile 3-in-1 blender with multiple jars for blending, grinding, and mixing. Powerful motor for all your kitchen needs.', 5500.00, 18, '/assets/prod/blender.jpg'),
(12, 1, 1, 'Panasonic Cooker 5L', 'Large 5L capacity rice cooker with keep-warm function. Non-stick inner pot and automatic cooking for perfect rice every time.', 8500.00, 10, '/assets/prod/rice_cooker.jpg'),
(13, 3, 2, 'Jamuna Fan', 'High-speed ceiling fan with energy-efficient motor. Provides powerful airflow while consuming less electricity.', 4200.00, 25, '/assets/prod/fan2.jpg'),
(14, 3, 2, 'Walton AC 1.5 Ton', 'Energy-efficient 1.5 ton air conditioner with fast cooling, auto-restart, and sleep mode. Perfect for medium-sized rooms.', 32200.00, 8, '/assets/prod/2.png'),
(15, 3, 2, 'Walton AC 2 Ton', 'Powerful 2 ton air conditioner with turbo cooling, dehumidifier, and smart temperature control. Ideal for large rooms.', 46500.00, 5, '/assets/prod/3.png'),
(16, 1, 1, 'Panasonic Mixer Grinder', 'Multi-purpose mixer grinder with 3 jars and stainless steel blades. Perfect for grinding spices, making chutneys, and mixing batters.', 2800.00, 20, '/assets/prod/grinder.jpg'),
(17, 3, 3, 'Hikvision Air Purifier', 'Advanced air purifier with HEPA filter, removes 99.9% pollutants, dust, and allergens. Quiet operation with multiple fan speeds.', 18500.00, 7, '/assets/prod/4.jpg'),
(18, 2, 5, 'P9 Max Bluetooth Headphones', 'Wireless Bluetooth headphones with noise cancellation, deep bass, and 20-hour battery life. Comfortable over-ear design.', 1850.00, 30, '/assets/prod/5.png'),

-- Additional products for variety
(19, 3, 4, 'LG Table Fan 16"', 'LG Table Fan with 3 speed settings and oscillation. Energy-efficient and quiet operation.', 2200.00, 20, '/assets/prod/hFan3.jpg'),

-- Tech Part Products (20-27)
(20, 4, 3, 'Acer SB220Q bi 21.5 Inches Full HD Monitor', 'Full HD 1920x1080 resolution, IPS panel, ultra-thin design with zero-frame. Perfect for office work and entertainment.', 9400.00, 15, '/assets/prod/6.png'),
(21, 4, 1, 'Intel Core i7 12th Gen Processor', '12th generation Intel Core i7 processor with 12 cores, 20 threads. High performance for gaming and productivity.', 45999.00, 10, '/assets/prod/7.png'),
(22, 4, 3, 'ASUS ROG Strix G15 Gaming Laptop', 'AMD Ryzen 9, RTX 3070, 16GB RAM, 1TB SSD. Ultimate gaming performance with RGB keyboard.', 120000.00, 5, '/assets/prod/8.png'),
(23, 4, 4, 'Logitech MX Master 3 Wireless Mouse', 'Advanced wireless mouse with MagSpeed scroll wheel, ergonomic design, and multi-device connectivity.', 8500.00, 20, '/assets/prod/9.png'),
(24, 4, 3, 'Samsung T7 Portable SSD 1TB', 'Ultra-fast portable SSD with USB 3.2 Gen 2, read speeds up to 1050 MB/s. Compact and durable design.', 12000.00, 18, '/assets/prod/01.png'),
(25, 4, 5, 'Corsair K95 RGB Platinum Mechanical Gaming Keyboard', 'Cherry MX Speed switches, per-key RGB backlighting, dedicated media controls. Premium gaming keyboard.', 18000.00, 12, '/assets/prod/09.png'),
(26, 4, 5, 'Razer DeathAdder V2 Pro Wireless Gaming Mouse', '20K DPI optical sensor, 70-hour battery life, ergonomic design. Professional gaming mouse.', 10500.00, 15, '/assets/prod/99.png'),
(27, 4, 3, 'Dell UltraSharp U2723QE 27 Inch 4K Monitor', '4K UHD resolution, IPS Black technology, USB-C connectivity. Professional-grade color accuracy.', 35000.00, 8, '/assets/prod/1.png'),

-- Kennede & Defender Charger Fan Collection (28-36)
(28, 3, 2, 'Kennede Charger Fan 2412', '12-inch rechargeable fan with LED light, 4-6 hours backup. Compact and portable design for load-shedding.', 1800.00, 20, '/assets/Collections/Kennede & Defender Charger Fan/2412.png'),
(29, 3, 2, 'Kennede Charger Fan 2916', '16-inch powerful rechargeable fan with 6-8 hours backup. High-speed motor with adjustable height.', 2400.00, 18, '/assets/Collections/Kennede & Defender Charger Fan/2916.jpg'),
(30, 3, 2, 'Kennede Charger Fan 2926', '16-inch premium rechargeable fan with remote control, 8-10 hours backup. Multiple speed settings.', 2800.00, 15, '/assets/Collections/Kennede & Defender Charger Fan/2926.jpg'),
(31, 3, 2, 'Kennede Charger Fan 2936S', '16-inch super powerful fan with solar charging option, 10-12 hours backup. Eco-friendly solution.', 3200.00, 12, '/assets/Collections/Kennede & Defender Charger Fan/2936s.jpg'),
(32, 3, 2, 'Kennede Charger Fan 2956P', '16-inch premium plus model with USB charging port, 12-14 hours backup. Can charge mobile phones.', 3500.00, 10, '/assets/Collections/Kennede & Defender Charger Fan/2956p.jpg'),
(33, 3, 2, 'HK Defender Charger Fan 2914', '14-inch defender series with strong build, 6-8 hours backup. Durable for heavy use.', 2100.00, 16, '/assets/Collections/Kennede & Defender Charger Fan/HK Defender 2914.jpg'),
(34, 3, 2, 'HK Defender Charger Fan 2916', '16-inch defender series with metal blades, 8-10 hours backup. Industrial-grade quality.', 2600.00, 14, '/assets/Collections/Kennede & Defender Charger Fan/HK Defender 2916.jpg'),
(35, 3, 2, 'HK Defender Charger Fan 2916 Plus', '16-inch defender plus with enhanced motor, 10-12 hours backup. Maximum airflow performance.', 2900.00, 12, '/assets/Collections/Kennede & Defender Charger Fan/HK Defender 2916_1.jpg'),
(36, 3, 2, 'Kennede Charger Fan 2912 (Deal Model)', '12-inch rechargeable fan, same as product 5 but different image. Popular deal model.', 2200.00, 18, '/assets/Collections/Kennede & Defender Charger Fan/2912.jpg'),

-- Flash Sale Products (37-39)
(37, 1, 2, 'AV Sandwich Maker 560', 'Non-stick grill plates, fast heating, easy to clean. Perfect for students and small families for quick breakfast.', 1850.00, 25, '/assets/flash/av.jpg'),
(38, 2, 2, 'Scarlet Hand Mixer HE-133', 'Powerful hand mixer for cake making and whisking eggs. Lightweight and easy to use. Budget-friendly kitchen essential.', 750.00, 30, '/assets/flash/handmixxer.jpg'),
(39, 3, 2, 'Kennede Charger Fan 2912 Flash', '12-inch rechargeable fan with LED light, 5-6 hours backup. Summer season hot item with special flash price.', 3500.00, 20, '/assets/flash/kennede.jpg'),

-- Best Sellers Product (40)
(40, 1, 1, 'Prestige Rice Cooker 1.8L', 'Known for durability and perfectly cooked rice every time. Non-stick inner pot, keep-warm function. The perfect rice cooker for daily use.', 2800.00, 22, '/assets/bestSale/prestige.jpg')
ON DUPLICATE KEY UPDATE product_name=VALUES(product_name), price=VALUES(price), stock_quantity=VALUES(stock_quantity);

-- ---------------------------------------------------------------------------
-- Admin User (password: 1234@# - hashed with bcrypt)
-- Note: Use backend API to create users with proper password hashing
-- ---------------------------------------------------------------------------
INSERT INTO users (user_id, full_name, last_name, email, password, role) VALUES
(1, 'Admin', 'User', 'admin@electrocitybd.com', '$2y$10$3rljKMaaNeyPT9V88FXyDO2UVgf9qf6j.yesYOAd95ux8hN975wpi', 'admin')
ON DUPLICATE KEY UPDATE
  full_name=VALUES(full_name),
  last_name=VALUES(last_name),
  email=VALUES(email),
  password=VALUES(password),
  role=VALUES(role);

-- ---------------------------------------------------------------------------
-- Sample Promotions (for Offers Up to 90% section)
-- ---------------------------------------------------------------------------
INSERT INTO promotions (title, description, discount_percent, start_date, end_date, active) VALUES
('Mega Smartphone Sale', 'Up to 90% off on smartphones', 90.00, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY), TRUE),
('Laptop Clearance', 'Huge discounts on laptops', 85.00, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY), TRUE),
('Home Appliances', 'Save big on home appliances', 80.00, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY), TRUE),
('Fashion Deals', 'Fashion items at unbeatable prices', 75.00, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY), TRUE),
('Winter Sale', 'Up to 20% off on lighting products', 20.00, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY), TRUE),
('Tools Discount', '10% off on all tools', 10.00, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 60 DAY), TRUE)
ON DUPLICATE KEY UPDATE title=VALUES(title);

-- ---------------------------------------------------------------------------
-- Flash Sale (7 Hot Items)
-- ---------------------------------------------------------------------------
INSERT INTO flash_sales (flash_sale_id, title, start_time, end_time, active) VALUES
(1, 'Flash Sale - Hot Items', NOW(), DATE_ADD(NOW(), INTERVAL 12 HOUR), TRUE)
ON DUPLICATE KEY UPDATE title=VALUES(title);

-- Flash Sale Products: 7 items with special prices
-- Using existing product IDs: 2 (Nima Grinder), 3 (Miyako Kettle), 4 (Sokany Dryer), 6 (Pink Panther Blender)
-- Using new product IDs: 37 (AV Sandwich Maker), 38 (Scarlet Hand Mixer), 39 (Kennede Fan Flash)
INSERT INTO flash_sale_products (flash_sale_id, product_id, flash_price) VALUES
(1, 2, 1250.00),   -- Nima Grinder: Regular 1,450 → Flash 1,250 BDT (Hot Item)
(1, 3, 1299.00),   -- Miyako Kettle: Regular 1,450 → Flash 1,299 BDT (Daily Essential)
(1, 4, 990.00),    -- Sokany Hair Dryer: Regular 1,180 → Flash 990 BDT (Under 1000!)
(1, 6, 3750.00),   -- Pink Panther Blender: Regular 4,050 → Flash 3,750 BDT (300 BDT Off)
(1, 39, 3150.00),  -- Kennede Fan Flash: Regular 3,500 → Flash 3,150 BDT (Summer Hot Item)
(1, 37, 1650.00),  -- AV Sandwich Maker: Regular 1,850 → Flash 1,650 BDT (Quick Breakfast)
(1, 38, 599.00)    -- Scarlet Hand Mixer: Regular 750 → Flash 599 BDT (Incredibly Cheap!)
ON DUPLICATE KEY UPDATE flash_price=VALUES(flash_price);

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
(1, 5), (1, 13), (1, 19), (1, 28), (1, 29), (1, 30), (1, 31), (1, 32), (1, 33), (1, 34), (1, 35), (1, 36),  -- Fans collection (12 products)
(2, 1), (2, 7), (2, 8), (2, 12), -- Cookers collection
(3, 6), (3, 11), (3, 16) -- Blenders collection
ON DUPLICATE KEY UPDATE collection_id=VALUES(collection_id);

-- ---------------------------------------------------------------------------
-- Deals of the Day (18 products with deal prices)
-- ---------------------------------------------------------------------------
INSERT INTO deals_of_the_day (product_id, deal_price, start_date, end_date) VALUES
(1, 2200.00, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),   -- Miyako Curry Cooker (12% off)
(2, 1000.00, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),   -- Nima Grinder (17% off)
(3, 1300.00, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),   -- Miyako Kettle (13% off)
(4, 1600.00, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),   -- Sokany Hair Dryer (11% off)
(5, 1900.00, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),   -- Kennede Charger Fan (14% off)
(6, 3200.00, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),   -- Pink Panther Blender (9% off)
(7, 4200.00, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),   -- NOHA Hotel King Blender (7% off)
(8, 1200.00, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),   -- AV Sandwich Maker (14% off)
(9, 5200.00, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),   -- Miyako 25L Oven (5% off)
(10, 7500.00, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),  -- Samsung CCTV Camera (12% off)
(11, 4800.00, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),  -- Walton Blender 3-in-1 (13% off)
(12, 7500.00, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),  -- Panasonic Cooker 5L (12% off)
(13, 3800.00, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),  -- Jamuna Fan (10% off)
(14, 29500.00, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)), -- Walton AC 1.5 Ton (8% off)
(15, 42800.00, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)), -- Walton AC 2 Ton (8% off)
(16, 2500.00, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),  -- Panasonic Mixer Grinder (11% off)
(17, 16800.00, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)), -- Hikvision Air Purifier (9% off)
(18, 1650.00, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY))   -- P9 Max Headphones (11% off)
ON DUPLICATE KEY UPDATE deal_price=VALUES(deal_price);

-- ---------------------------------------------------------------------------
-- Deals Timer Configuration (Admin Control)
-- ---------------------------------------------------------------------------
INSERT INTO deals_timer (timer_id, days, hours, minutes, seconds, is_active) VALUES
(1, 3, 11, 15, 0, TRUE)
ON DUPLICATE KEY UPDATE days=VALUES(days), hours=VALUES(hours), minutes=VALUES(minutes), seconds=VALUES(seconds);

-- ---------------------------------------------------------------------------
-- Best Sellers (7 Top Products with Sales Strategy)
-- ---------------------------------------------------------------------------
INSERT INTO best_sellers (product_id, sales_count, selling_point, sales_strategy) VALUES 
(6, 500, 'The most trusted household name for daily grinding and juice making.', 'The All-rounder Kitchen King'),
(2, 450, 'Extremely affordable and perfect for small families or coffee lovers.', 'Your Daily Spice Partner'),
(5, 420, 'A lifesaver during load-shedding with reliable battery backup.', 'Stay Cool, No Matter the Power Cut'),
(3, 380, 'Essential for every home and office for quick tea/coffee.', 'Hot Water in Minutes'),
(4, 350, 'High power and stylish design at a very competitive price point.', 'Salon-Style Hair at Home'),
(1, 320, 'Huge capacity makes it the go-to choice for cooking for guests.', 'Cook Big, Live Large'),
(40, 300, 'Known for durability and perfectly cooked rice every time.', 'The Perfect Rice, Every Single Meal')
ON DUPLICATE KEY UPDATE sales_count=VALUES(sales_count), selling_point=VALUES(selling_point), sales_strategy=VALUES(sales_strategy);

-- ---------------------------------------------------------------------------
-- Trending Products
-- ---------------------------------------------------------------------------
INSERT INTO trending_products (product_id, trending_score) VALUES 
(1, 95), (5, 90), (7, 85), (8, 80), (9, 75), (10, 70), (14, 65), (18, 60)
ON DUPLICATE KEY UPDATE trending_score=VALUES(trending_score);

-- ---------------------------------------------------------------------------
-- Tech Part Products
-- ---------------------------------------------------------------------------
INSERT INTO tech_part_products (product_id, display_order) VALUES 
(20, 1), (21, 2), (22, 3), (23, 4), (24, 5), (25, 6), (26, 7), (27, 8)
ON DUPLICATE KEY UPDATE display_order=VALUES(display_order);

-- ---------------------------------------------------------------------------
-- Sample Banners (Hero, Mid, Sidebar)
-- ---------------------------------------------------------------------------
INSERT INTO banners (banner_type, image_url, link_url, title, description, button_text, display_order, active, start_date, end_date) VALUES
-- Hero Banners
('hero', '/uploads/banners/hero_kitchen_sale.jpg', '/collections/cookers', 'Kitchen Appliances Sale', 'Up to 30% off on all kitchen items', 'Shop Now', 1, TRUE, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY)),
('hero', '/uploads/banners/hero_smart_home.jpg', '/collections/fans', 'Smart Home Solutions', 'Transform your home with smart appliances', 'Explore', 2, TRUE, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY)),
('hero', '/uploads/banners/hero_personal_care.jpg', '/collections/hair-dryer', 'Personal Care Essentials', 'Grooming products for everyone', 'Discover', 3, TRUE, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY)),

-- Mid Banners (3 banners for mid_banner_row)
('mid', '/assets/1.png', '/deals', 'Special Offers', 'Check out our amazing deals', 'View Deals', 1, TRUE, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY)),
('mid', '/assets/2.png', '/collections', 'New Collections', 'Explore our latest collections', 'Browse', 2, TRUE, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY)),
('mid', '/assets/3.png', '/products', 'Featured Products', 'Discover trending products', 'Shop Now', 3, TRUE, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY)),

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

-- ---------------------------------------------------------------------------
-- Product Specifications (for Deals of the Day products)
-- ---------------------------------------------------------------------------
INSERT INTO product_specifications (product_id, spec_key, spec_value, display_order) VALUES
-- Miyako Curry Cooker
(1, 'Capacity', '5.5 Liters', 1),
(1, 'Coating', 'Non-stick', 2),
(1, 'Cooking Mode', 'Automatic', 3),
(1, 'USP', 'Family Reliable - Best for large families', 4),

-- Nima Grinder
(2, 'Power', '450W', 1),
(2, 'Motor Type', 'Powerful Motor', 2),
(2, 'Blade Material', 'Stainless Steel', 3),
(2, 'Grinding Type', 'Dry and Wet', 4),
(2, 'USP', 'Budget Friendly - Quick grinding at low price', 5),

-- Miyako Kettle
(3, 'Capacity', '1.8 Liters', 1),
(3, 'Model', '180 PS', 2),
(3, 'Safety Feature', 'Auto-shutoff when water boils', 3),
(3, 'USP', 'Quick Solution - Hot water in minutes', 4),

-- Sokany Hair Dryer
(4, 'Model', 'HS-3820', 1),
(4, 'Power', '2000-2200W', 2),
(4, 'Air Options', 'Hot and Cold', 3),
(4, 'Accessories', 'Concentrator Nozzle', 4),
(4, 'USP', 'Perfect Look - Salon-style at home', 5),

-- Kennede Charger Fan
(5, 'Model', '2912', 1),
(5, 'Size', '12 inch', 2),
(5, 'Battery Type', 'Rechargeable', 3),
(5, 'Backup Time', '5-6 hours', 4),
(5, 'Extra Feature', 'Built-in LED light', 5),
(5, 'USP', 'Load-shedding Master - Long battery backup', 6),

-- Miyako Pink Panther Blender
(6, 'Power', '750W', 1),
(6, 'Motor Type', 'Copper Motor', 2),
(6, 'Jars', '3 Stainless Steel Jars', 3),
(6, 'Safety', 'Overload Protection', 4),
(6, 'USP', 'All-in-One - Juice to spice grinding', 5),

-- NOHA Hotel King Blender
(7, 'Power', '1050W', 1),
(7, 'Motor Type', 'High-power Motor', 2),
(7, 'Blade Type', 'Heavy-duty Blades', 3),
(7, 'Design', 'Anti-jam Design', 4),
(7, 'USP', 'For Heavy Users - Extremely durable', 5),

-- AV Sandwich Maker
(8, 'Model', '296', 1),
(8, 'Plates', 'Non-stick Grill Plates', 2),
(8, 'Heating', 'Fast Heating Technology', 3),
(8, 'Maintenance', 'Easy to Clean', 4),
(8, 'USP', 'Instant Breakfast - Quick tiffin preparation', 5),

-- Miyako 25L Electric Oven
(9, 'Capacity', '25 Liters', 1),
(9, 'Controls', 'Timer and Temperature Control', 2),
(9, 'Functions', 'Baking and Grilling', 3),
(9, 'USP', 'For Baking Lovers - Entry-level oven', 4),

-- Samsung CCTV Camera
(10, 'Brand', 'Samsung', 1),
(10, 'Features', 'Night Vision, Motion Detection', 2),
(10, 'Connectivity', 'Remote Viewing', 3),
(10, 'USP', 'High-quality security monitoring', 4),

-- Walton Blender 3-in-1
(11, 'Brand', 'Walton', 1),
(11, 'Type', '3-in-1 Machine', 2),
(11, 'Functions', 'Blending, Grinding, Mixing', 3),
(11, 'USP', 'Versatile kitchen companion', 4),

-- Panasonic Cooker 5L
(12, 'Brand', 'Panasonic', 1),
(12, 'Capacity', '5 Liters', 2),
(12, 'Coating', 'Non-stick Inner Pot', 3),
(12, 'Features', 'Keep-warm Function, Automatic Cooking', 4),
(12, 'USP', 'Perfect rice every time', 5),

-- Jamuna Fan
(13, 'Brand', 'Jamuna', 1),
(13, 'Type', 'Ceiling Fan', 2),
(13, 'Motor', 'Energy-efficient', 3),
(13, 'USP', 'Powerful airflow, low electricity consumption', 4),

-- Walton AC 1.5 Ton
(14, 'Brand', 'Walton', 1),
(14, 'Capacity', '1.5 Ton', 2),
(14, 'Features', 'Fast Cooling, Auto-restart, Sleep Mode', 3),
(14, 'Energy', 'Energy-efficient', 4),
(14, 'USP', 'Perfect for medium-sized rooms', 5),

-- Walton AC 2 Ton
(15, 'Brand', 'Walton', 1),
(15, 'Capacity', '2 Ton', 2),
(15, 'Features', 'Turbo Cooling, Dehumidifier, Smart Control', 3),
(15, 'USP', 'Ideal for large rooms', 4),

-- Panasonic Mixer Grinder
(16, 'Brand', 'Panasonic', 1),
(16, 'Jars', '3 Jars', 2),
(16, 'Blade Material', 'Stainless Steel', 3),
(16, 'Functions', 'Grinding Spices, Making Chutneys, Mixing Batters', 4),
(16, 'USP', 'Multi-purpose kitchen tool', 5),

-- Hikvision Air Purifier
(17, 'Brand', 'Hikvision', 1),
(17, 'Filter Type', 'HEPA Filter', 2),
(17, 'Efficiency', 'Removes 99.9% Pollutants', 3),
(17, 'Operation', 'Quiet with Multiple Fan Speeds', 4),
(17, 'USP', 'Advanced air purification', 5),

-- P9 Max Bluetooth Headphones
(18, 'Brand', 'P9 Max', 1),
(18, 'Type', 'Wireless Bluetooth', 2),
(18, 'Features', 'Noise Cancellation, Deep Bass', 3),
(18, 'Battery Life', '20 Hours', 4),
(18, 'Design', 'Comfortable Over-ear', 5),
(18, 'USP', 'Premium audio experience', 6),

-- Tech Part Products Specifications (20-27)
-- Acer Monitor
(20, 'Screen Size', '21.5 Inches', 1),
(20, 'Resolution', 'Full HD 1920x1080', 2),
(20, 'Panel Type', 'IPS', 3),
(20, 'Design', 'Ultra-thin Zero-frame', 4),
(20, 'Rating', '5', 5),

-- Intel Core i7
(21, 'Generation', '12th Gen', 1),
(21, 'Cores', '12 Cores', 2),
(21, 'Threads', '20 Threads', 3),
(21, 'Performance', 'High Performance Gaming & Productivity', 4),
(21, 'Rating', '5', 5),

-- ASUS ROG Laptop
(22, 'Processor', 'AMD Ryzen 9', 1),
(22, 'Graphics', 'RTX 3070', 2),
(22, 'RAM', '16GB', 3),
(22, 'Storage', '1TB SSD', 4),
(22, 'Features', 'RGB Keyboard', 5),
(22, 'Rating', '4', 6),

-- Logitech Mouse
(23, 'Model', 'MX Master 3', 1),
(23, 'Type', 'Wireless', 2),
(23, 'Features', 'MagSpeed Scroll Wheel, Ergonomic Design', 3),
(23, 'Connectivity', 'Multi-device', 4),
(23, 'Rating', '4', 5),

-- Samsung SSD
(24, 'Capacity', '1TB', 1),
(24, 'Interface', 'USB 3.2 Gen 2', 2),
(24, 'Speed', 'Up to 1050 MB/s', 3),
(24, 'Design', 'Compact and Durable', 4),
(24, 'Rating', '5', 5),

-- Corsair Keyboard
(25, 'Switch Type', 'Cherry MX Speed', 1),
(25, 'Lighting', 'Per-key RGB', 2),
(25, 'Controls', 'Dedicated Media Controls', 3),
(25, 'Type', 'Mechanical Gaming Keyboard', 4),
(25, 'Rating', '4', 5),

-- Razer Mouse
(26, 'Sensor', '20K DPI Optical', 1),
(26, 'Battery', '70-hour Battery Life', 2),
(26, 'Design', 'Ergonomic', 3),
(26, 'Type', 'Wireless Gaming Mouse', 4),
(26, 'Rating', '4', 5),

-- Dell Monitor
(27, 'Screen Size', '27 Inch', 1),
(27, 'Resolution', '4K UHD', 2),
(27, 'Technology', 'IPS Black', 3),
(27, 'Connectivity', 'USB-C', 4),
(27, 'Features', 'Professional Color Accuracy', 5),
(27, 'Rating', '5', 6),

-- Kennede & Defender Charger Fan Specifications (28-36)
-- Kennede 2412
(28, 'Size', '12 inch', 1),
(28, 'Battery Backup', '4-6 hours', 2),
(28, 'Features', 'LED Light, Rechargeable', 3),
(28, 'Design', 'Compact and Portable', 4),

-- Kennede 2916
(29, 'Size', '16 inch', 1),
(29, 'Battery Backup', '6-8 hours', 2),
(29, 'Features', 'High-speed Motor, Adjustable Height', 3),
(29, 'Power', 'Powerful Airflow', 4),

-- Kennede 2926
(30, 'Size', '16 inch', 1),
(30, 'Battery Backup', '8-10 hours', 2),
(30, 'Features', 'Remote Control, Multiple Speed Settings', 3),
(30, 'Type', 'Premium Model', 4),

-- Kennede 2936S
(31, 'Size', '16 inch', 1),
(31, 'Battery Backup', '10-12 hours', 2),
(31, 'Features', 'Solar Charging Option', 3),
(31, 'Type', 'Eco-friendly Solution', 4),
(31, 'Power', 'Super Powerful', 5),

-- Kennede 2956P
(32, 'Size', '16 inch', 1),
(32, 'Battery Backup', '12-14 hours', 2),
(32, 'Features', 'USB Charging Port, Can Charge Phones', 3),
(32, 'Type', 'Premium Plus Model', 4),

-- HK Defender 2914
(33, 'Size', '14 inch', 1),
(33, 'Battery Backup', '6-8 hours', 2),
(33, 'Build', 'Strong and Durable', 3),
(33, 'Series', 'Defender Series', 4),

-- HK Defender 2916
(34, 'Size', '16 inch', 1),
(34, 'Battery Backup', '8-10 hours', 2),
(34, 'Blades', 'Metal Blades', 3),
(34, 'Quality', 'Industrial-grade', 4),
(34, 'Series', 'Defender Series', 5),

-- HK Defender 2916 Plus
(35, 'Size', '16 inch', 1),
(35, 'Battery Backup', '10-12 hours', 2),
(35, 'Motor', 'Enhanced Motor', 3),
(35, 'Performance', 'Maximum Airflow', 4),
(35, 'Series', 'Defender Plus', 5),

-- Kennede 2912 Deal Model
(36, 'Size', '12 inch', 1),
(36, 'Battery Backup', '5-6 hours', 2),
(36, 'Features', 'LED Light, Rechargeable', 3),
(36, 'Type', 'Popular Deal Model', 4),

-- Flash Sale Products Specifications (37-39)
-- AV Sandwich Maker 560
(37, 'Model', '560', 1),
(37, 'Plates', 'Non-stick Grill Plates', 2),
(37, 'Heating', 'Fast Heating', 3),
(37, 'Maintenance', 'Easy to Clean', 4),
(37, 'Best For', 'Students & Small Families', 5),
(37, 'USP', 'Perfect for Quick Breakfast', 6),

-- Scarlet Hand Mixer HE-133
(38, 'Model', 'HE-133', 1),
(38, 'Type', 'Hand Mixer', 2),
(38, 'Power', 'Powerful Motor', 3),
(38, 'Weight', 'Lightweight', 4),
(38, 'Use', 'Cake Making, Whisking Eggs', 5),
(38, 'USP', 'Incredibly Cheap & Effective', 6),

-- Kennede Charger Fan 2912 Flash
(39, 'Model', '2912', 1),
(39, 'Size', '12 inch', 2),
(39, 'Battery Backup', '5-6 hours', 3),
(39, 'Features', 'LED Light, Rechargeable', 4),
(39, 'Season', 'Summer Hot Item', 5),
(39, 'USP', 'Biggest Flash Sale Attraction', 6),

-- Prestige Rice Cooker 1.8L
(40, 'Brand', 'Prestige', 1),
(40, 'Capacity', '1.8 Liters', 2),
(40, 'Coating', 'Non-stick Inner Pot', 3),
(40, 'Features', 'Keep-warm Function', 4),
(40, 'Quality', 'Known for Durability', 5),
(40, 'USP', 'The Perfect Rice, Every Single Meal', 6),
(40, 'Strategy', 'Perfectly Cooked Rice Every Time', 7)
ON DUPLICATE KEY UPDATE spec_value=VALUES(spec_value);

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
