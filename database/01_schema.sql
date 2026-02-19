-- ElectrocityBD MySQL Schema (Production-style baseline)
-- MySQL 8+

SET NAMES utf8mb4;
SET time_zone = '+06:00';

CREATE DATABASE IF NOT EXISTS electrocitybd
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE electrocitybd;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS order_status_history;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS cart_items;
DROP TABLE IF EXISTS carts;
DROP TABLE IF EXISTS wishlist_items;
DROP TABLE IF EXISTS product_promotions;
DROP TABLE IF EXISTS promotions;
DROP TABLE IF EXISTS banners;
DROP TABLE IF EXISTS coupons;
DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS product_specs;
DROP TABLE IF EXISTS product_images;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS brands;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS user_addresses;
DROP TABLE IF EXISTS users;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE users (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  uuid CHAR(36) NOT NULL UNIQUE,
  first_name VARCHAR(80) NOT NULL,
  last_name VARCHAR(80) NOT NULL,
  email VARCHAR(190) NOT NULL UNIQUE,
  phone VARCHAR(30) NULL,
  gender ENUM('Male', 'Female', 'Other') DEFAULT 'Male',
  password_hash VARCHAR(255) NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  is_email_verified TINYINT(1) NOT NULL DEFAULT 0,
  last_login_at DATETIME NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_users_phone (phone),
  INDEX idx_users_created_at (created_at)
) ENGINE=InnoDB;

CREATE TABLE user_addresses (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT UNSIGNED NOT NULL,
  label VARCHAR(60) NOT NULL DEFAULT 'Home',
  recipient_name VARCHAR(150) NOT NULL,
  phone VARCHAR(30) NOT NULL,
  address_line_1 VARCHAR(255) NOT NULL,
  address_line_2 VARCHAR(255) NULL,
  city VARCHAR(100) NOT NULL,
  area VARCHAR(100) NULL,
  postal_code VARCHAR(20) NULL,
  country VARCHAR(80) NOT NULL DEFAULT 'Bangladesh',
  is_default TINYINT(1) NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_user_addresses_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE,
  INDEX idx_user_addresses_user (user_id),
  INDEX idx_user_addresses_default (user_id, is_default)
) ENGINE=InnoDB;

CREATE TABLE categories (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  parent_id BIGINT UNSIGNED NULL,
  slug VARCHAR(140) NOT NULL UNIQUE,
  name VARCHAR(140) NOT NULL,
  description TEXT NULL,
  image_url VARCHAR(500) NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  sort_order INT NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_categories_parent
    FOREIGN KEY (parent_id) REFERENCES categories(id)
    ON DELETE SET NULL,
  INDEX idx_categories_parent (parent_id),
  INDEX idx_categories_active_sort (is_active, sort_order)
) ENGINE=InnoDB;

CREATE TABLE brands (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  slug VARCHAR(140) NOT NULL UNIQUE,
  name VARCHAR(140) NOT NULL,
  logo_url VARCHAR(500) NULL,
  website_url VARCHAR(300) NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_brands_active (is_active)
) ENGINE=InnoDB;

CREATE TABLE products (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  sku VARCHAR(80) NOT NULL UNIQUE,
  slug VARCHAR(200) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  short_description VARCHAR(500) NULL,
  description TEXT NULL,
  category_id BIGINT UNSIGNED NOT NULL,
  brand_id BIGINT UNSIGNED NULL,
  regular_price DECIMAL(12,2) NOT NULL,
  sale_price DECIMAL(12,2) NULL,
  currency CHAR(3) NOT NULL DEFAULT 'BDT',
  rating_avg DECIMAL(3,2) NOT NULL DEFAULT 0.00,
  rating_count INT UNSIGNED NOT NULL DEFAULT 0,
  is_featured TINYINT(1) NOT NULL DEFAULT 0,
  is_trending TINYINT(1) NOT NULL DEFAULT 0,
  is_flash_sale TINYINT(1) NOT NULL DEFAULT 0,
  status ENUM('draft','active','inactive','archived') NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_products_category
    FOREIGN KEY (category_id) REFERENCES categories(id),
  CONSTRAINT fk_products_brand
    FOREIGN KEY (brand_id) REFERENCES brands(id)
    ON DELETE SET NULL,
  INDEX idx_products_category (category_id),
  INDEX idx_products_brand (brand_id),
  INDEX idx_products_flags (is_featured, is_trending, is_flash_sale),
  INDEX idx_products_status_created (status, created_at),
  FULLTEXT KEY ft_products_search (name, short_description, description)
) ENGINE=InnoDB;

CREATE TABLE product_images (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  product_id BIGINT UNSIGNED NOT NULL,
  image_url VARCHAR(500) NOT NULL,
  alt_text VARCHAR(255) NULL,
  is_primary TINYINT(1) NOT NULL DEFAULT 0,
  sort_order INT NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_product_images_product
    FOREIGN KEY (product_id) REFERENCES products(id)
    ON DELETE CASCADE,
  INDEX idx_product_images_product (product_id),
  INDEX idx_product_images_primary (product_id, is_primary)
) ENGINE=InnoDB;

CREATE TABLE product_specs (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  product_id BIGINT UNSIGNED NOT NULL,
  spec_key VARCHAR(120) NOT NULL,
  spec_value VARCHAR(255) NOT NULL,
  sort_order INT NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_product_specs_product
    FOREIGN KEY (product_id) REFERENCES products(id)
    ON DELETE CASCADE,
  INDEX idx_product_specs_product (product_id),
  INDEX idx_product_specs_key (spec_key)
) ENGINE=InnoDB;

CREATE TABLE inventory (
  product_id BIGINT UNSIGNED PRIMARY KEY,
  stock_qty INT NOT NULL DEFAULT 0,
  low_stock_threshold INT NOT NULL DEFAULT 5,
  reserved_qty INT NOT NULL DEFAULT 0,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_inventory_product
    FOREIGN KEY (product_id) REFERENCES products(id)
    ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE coupons (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  code VARCHAR(50) NOT NULL UNIQUE,
  discount_type ENUM('percent','fixed') NOT NULL,
  discount_value DECIMAL(10,2) NOT NULL,
  min_order_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
  max_discount_amount DECIMAL(12,2) NULL,
  usage_limit INT NULL,
  used_count INT NOT NULL DEFAULT 0,
  starts_at DATETIME NULL,
  expires_at DATETIME NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_coupons_active (is_active),
  INDEX idx_coupons_window (starts_at, expires_at)
) ENGINE=InnoDB;

CREATE TABLE carts (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT UNSIGNED NULL,
  session_key VARCHAR(120) NULL UNIQUE,
  status ENUM('active','converted','abandoned') NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_carts_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE SET NULL,
  INDEX idx_carts_user_status (user_id, status)
) ENGINE=InnoDB;

CREATE TABLE cart_items (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  cart_id BIGINT UNSIGNED NOT NULL,
  product_id BIGINT UNSIGNED NOT NULL,
  quantity INT UNSIGNED NOT NULL,
  unit_price DECIMAL(12,2) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_cart_items_cart
    FOREIGN KEY (cart_id) REFERENCES carts(id)
    ON DELETE CASCADE,
  CONSTRAINT fk_cart_items_product
    FOREIGN KEY (product_id) REFERENCES products(id),
  CONSTRAINT uq_cart_items_unique UNIQUE (cart_id, product_id),
  INDEX idx_cart_items_cart (cart_id),
  INDEX idx_cart_items_product (product_id)
) ENGINE=InnoDB;

CREATE TABLE wishlist_items (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT UNSIGNED NOT NULL,
  product_id BIGINT UNSIGNED NOT NULL,
  date_added DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_wishlist_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE,
  CONSTRAINT fk_wishlist_product
    FOREIGN KEY (product_id) REFERENCES products(id)
    ON DELETE CASCADE,
  CONSTRAINT uq_wishlist_user_product UNIQUE (user_id, product_id),
  INDEX idx_wishlist_user (user_id),
  INDEX idx_wishlist_product (product_id)
) ENGINE=InnoDB;

CREATE TABLE orders (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  order_no VARCHAR(40) NOT NULL UNIQUE,
  user_id BIGINT UNSIGNED NOT NULL,
  address_id BIGINT UNSIGNED NULL,
  coupon_id BIGINT UNSIGNED NULL,
  subtotal DECIMAL(12,2) NOT NULL,
  discount_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
  shipping_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
  total_amount DECIMAL(12,2) NOT NULL,
  currency CHAR(3) NOT NULL DEFAULT 'BDT',
  payment_status ENUM('pending','paid','failed','refunded') NOT NULL DEFAULT 'pending',
  order_status ENUM('pending','confirmed','processing','shipped','delivered','cancelled') NOT NULL DEFAULT 'pending',
  notes VARCHAR(500) NULL,
  placed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_orders_user
    FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_orders_address
    FOREIGN KEY (address_id) REFERENCES user_addresses(id)
    ON DELETE SET NULL,
  CONSTRAINT fk_orders_coupon
    FOREIGN KEY (coupon_id) REFERENCES coupons(id)
    ON DELETE SET NULL,
  INDEX idx_orders_user (user_id),
  INDEX idx_orders_status (order_status, payment_status),
  INDEX idx_orders_placed_at (placed_at)
) ENGINE=InnoDB;

CREATE TABLE order_items (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  order_id BIGINT UNSIGNED NOT NULL,
  product_id BIGINT UNSIGNED NOT NULL,
  product_name VARCHAR(255) NOT NULL,
  product_sku VARCHAR(80) NOT NULL,
  quantity INT UNSIGNED NOT NULL,
  unit_price DECIMAL(12,2) NOT NULL,
  line_total DECIMAL(12,2) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_order_items_order
    FOREIGN KEY (order_id) REFERENCES orders(id)
    ON DELETE CASCADE,
  CONSTRAINT fk_order_items_product
    FOREIGN KEY (product_id) REFERENCES products(id),
  INDEX idx_order_items_order (order_id),
  INDEX idx_order_items_product (product_id)
) ENGINE=InnoDB;

CREATE TABLE payments (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  order_id BIGINT UNSIGNED NOT NULL,
  method ENUM('bkash','nagad','cod','card') NOT NULL,
  provider VARCHAR(60) NULL,
  transaction_id VARCHAR(120) NULL,
  payer_phone VARCHAR(30) NULL,
  amount DECIMAL(12,2) NOT NULL,
  status ENUM('initiated','success','failed','cancelled') NOT NULL DEFAULT 'initiated',
  paid_at DATETIME NULL,
  gateway_response JSON NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_payments_order
    FOREIGN KEY (order_id) REFERENCES orders(id)
    ON DELETE CASCADE,
  CONSTRAINT uq_payments_txn UNIQUE (transaction_id),
  INDEX idx_payments_order (order_id),
  INDEX idx_payments_method (method),
  INDEX idx_payments_status (status)
) ENGINE=InnoDB;

CREATE TABLE order_status_history (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  order_id BIGINT UNSIGNED NOT NULL,
  status ENUM('pending','confirmed','processing','shipped','delivered','cancelled') NOT NULL,
  comment VARCHAR(500) NULL,
  changed_by BIGINT UNSIGNED NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_order_status_history_order
    FOREIGN KEY (order_id) REFERENCES orders(id)
    ON DELETE CASCADE,
  CONSTRAINT fk_order_status_history_changed_by
    FOREIGN KEY (changed_by) REFERENCES users(id)
    ON DELETE SET NULL,
  INDEX idx_order_status_history_order (order_id),
  INDEX idx_order_status_history_status (status)
) ENGINE=InnoDB;

CREATE TABLE banners (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  section_key VARCHAR(80) NOT NULL,
  title VARCHAR(180) NULL,
  subtitle VARCHAR(255) NULL,
  image_url VARCHAR(500) NOT NULL,
  cta_text VARCHAR(80) NULL,
  cta_link VARCHAR(300) NULL,
  sort_order INT NOT NULL DEFAULT 0,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  starts_at DATETIME NULL,
  ends_at DATETIME NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_banners_section (section_key, is_active, sort_order),
  INDEX idx_banners_window (starts_at, ends_at)
) ENGINE=InnoDB;

CREATE TABLE promotions (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  promo_type ENUM('flash_sale','deal_of_day','featured','campaign') NOT NULL,
  title VARCHAR(180) NOT NULL,
  description VARCHAR(500) NULL,
  discount_type ENUM('percent','fixed') NOT NULL,
  discount_value DECIMAL(10,2) NOT NULL,
  starts_at DATETIME NOT NULL,
  ends_at DATETIME NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_promotions_type (promo_type),
  INDEX idx_promotions_window (starts_at, ends_at),
  INDEX idx_promotions_active (is_active)
) ENGINE=InnoDB;

CREATE TABLE product_promotions (
  product_id BIGINT UNSIGNED NOT NULL,
  promotion_id BIGINT UNSIGNED NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (product_id, promotion_id),
  CONSTRAINT fk_product_promotions_product
    FOREIGN KEY (product_id) REFERENCES products(id)
    ON DELETE CASCADE,
  CONSTRAINT fk_product_promotions_promotion
    FOREIGN KEY (promotion_id) REFERENCES promotions(id)
    ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE OR REPLACE VIEW v_product_catalog AS
SELECT
  p.id,
  p.sku,
  p.slug,
  p.name,
  p.short_description,
  p.regular_price,
  p.sale_price,
  COALESCE(i.stock_qty, 0) AS stock_qty,
  c.name AS category_name,
  b.name AS brand_name,
  p.is_featured,
  p.is_trending,
  p.is_flash_sale,
  p.status,
  p.updated_at
FROM products p
JOIN categories c ON c.id = p.category_id
LEFT JOIN brands b ON b.id = p.brand_id
LEFT JOIN inventory i ON i.product_id = p.id;
