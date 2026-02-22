-- ============================================================
-- ElectrocityBD - MySQL Schema
-- Matches backend (Node.js) config/init_db.js
-- Run: mysql -u root -p < electrocity_schema.sql
-- Or create DB first: CREATE DATABASE electrocity_db; USE electrocity_db;
-- ============================================================

CREATE DATABASE IF NOT EXISTS electrocity_db;
USE electrocity_db;

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
);

-- ---------------------------------------------------------------------------
-- 2. Brands
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS brands (
  brand_id INT AUTO_INCREMENT PRIMARY KEY,
  brand_name VARCHAR(100) NOT NULL,
  brand_logo VARCHAR(255)
);

-- ---------------------------------------------------------------------------
-- 3. Categories
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS categories (
  category_id INT AUTO_INCREMENT PRIMARY KEY,
  category_name VARCHAR(50) NOT NULL,
  category_image VARCHAR(255)
);

-- ---------------------------------------------------------------------------
-- 4. Products
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
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL,
  FOREIGN KEY (brand_id) REFERENCES brands(brand_id) ON DELETE SET NULL
);

-- ---------------------------------------------------------------------------
-- 5. Discounts
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS discounts (
  discount_id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT,
  discount_percent DECIMAL(5,2),
  valid_from DATE,
  valid_to DATE,
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- ---------------------------------------------------------------------------
-- 6. Cart
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS cart (
  cart_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  product_id INT,
  quantity INT DEFAULT 1,
  added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- ---------------------------------------------------------------------------
-- 7. Orders
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
);

-- ---------------------------------------------------------------------------
-- 8. Order items
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
);

-- ---------------------------------------------------------------------------
-- 9. Wishlists
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS wishlists (
  wishlist_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  product_id INT,
  added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- ---------------------------------------------------------------------------
-- 10. Customer support
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
);

-- ---------------------------------------------------------------------------
-- 11. Promotions
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS promotions (
  promotion_id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(100) NOT NULL,
  description TEXT,
  discount_percent DECIMAL(5,2),
  start_date DATE,
  end_date DATE,
  active BOOLEAN DEFAULT TRUE
);

-- ---------------------------------------------------------------------------
-- 12. Flash sales
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS flash_sales (
  flash_sale_id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(100),
  start_time DATETIME,
  end_time DATETIME,
  active BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS flash_sale_products (
  flash_sale_id INT,
  product_id INT,
  PRIMARY KEY (flash_sale_id, product_id),
  FOREIGN KEY (flash_sale_id) REFERENCES flash_sales(flash_sale_id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- ---------------------------------------------------------------------------
-- 13. Collections
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS collections (
  collection_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  image_url VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS collection_products (
  collection_id INT,
  product_id INT,
  PRIMARY KEY (collection_id, product_id),
  FOREIGN KEY (collection_id) REFERENCES collections(collection_id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- ---------------------------------------------------------------------------
-- 14. Deals of the day
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS deals_of_the_day (
  deal_id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT,
  deal_price DECIMAL(10,2),
  start_date DATETIME,
  end_date DATETIME,
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- ---------------------------------------------------------------------------
-- 15. Best sellers / Trending
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS best_sellers (
  product_id INT PRIMARY KEY,
  sales_count INT DEFAULT 0,
  last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS trending_products (
  product_id INT PRIMARY KEY,
  trending_score INT DEFAULT 0,
  last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- ---------------------------------------------------------------------------
-- 15b. Tech Part (homepage section)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tech_part_products (
  product_id INT PRIMARY KEY,
  display_order INT DEFAULT 0,
  added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- ---------------------------------------------------------------------------
-- 16. Admin reports
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS reports (
  report_id INT AUTO_INCREMENT PRIMARY KEY,
  admin_id INT,
  report_type VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  details TEXT,
  FOREIGN KEY (admin_id) REFERENCES users(user_id)
);

-- ---------------------------------------------------------------------------
-- Indexes for performance
-- ---------------------------------------------------------------------------
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_brand ON products(brand_id);
CREATE INDEX idx_cart_user ON cart(user_id);
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_wishlists_user ON wishlists(user_id);
CREATE INDEX idx_customer_support_user ON customer_support(user_id);
CREATE INDEX idx_customer_support_status ON customer_support(status);
