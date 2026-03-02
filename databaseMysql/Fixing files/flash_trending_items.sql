-- ============================================
-- Complete Flash Sale & Trending Products Setup
-- ============================================
USE electrobd;

DROP TABLE IF EXISTS flash_sale_products;
DROP TABLE IF EXISTS flash_sales;
DROP TABLE IF EXISTS trending_products;

SELECT 'Old tables dropped successfully!' as Status;

-- ============================================
-- STEP 1: CREATE TABLES
-- ============================================

-- Create flash_sales table
CREATE TABLE flash_sales (
    flash_sale_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    active TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create flash_sale_products table
CREATE TABLE flash_sale_products (
    flash_sale_product_id INT PRIMARY KEY AUTO_INCREMENT,
    flash_sale_id INT NOT NULL,
    product_id INT NOT NULL,
    flash_price DECIMAL(10,2) NOT NULL,
    image_path VARCHAR(255) NULL,
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (flash_sale_id) REFERENCES flash_sales(flash_sale_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    UNIQUE KEY unique_flash_product (flash_sale_id, product_id)
);

-- Create trending_products table
CREATE TABLE trending_products (
    trending_product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    trending_score INT DEFAULT 0,
    image_path VARCHAR(255) NULL,
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    UNIQUE KEY unique_trending_product (product_id)
);

-- Add indexes for better performance
CREATE INDEX idx_flash_sale_products_order ON flash_sale_products(display_order);
CREATE INDEX idx_trending_products_order ON trending_products(display_order);
CREATE INDEX idx_flash_sales_active ON flash_sales(active, end_time);
CREATE INDEX idx_trending_products_score ON trending_products(trending_score DESC);

SELECT 'Tables created successfully!' as Status;

-- ============================================
-- STEP 2: INSERT FLASH SALE PRODUCTS
-- ============================================

DROP TEMPORARY TABLE IF EXISTS tmp_flash_products;
CREATE TEMPORARY TABLE tmp_flash_products (
  product_name VARCHAR(150) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  category_name VARCHAR(100) NOT NULL,
  brand_name VARCHAR(100) NOT NULL,
  image_path VARCHAR(255) NOT NULL,
  stock_quantity INT NOT NULL,
  display_order INT NOT NULL
);

INSERT INTO tmp_flash_products (product_name, price, category_name, brand_name, image_path, stock_quantity, display_order) VALUES
('AV Sandwich Maker', 1850, 'Kitchen Appliances', 'Singer', 'assets/flash/av.jpg', 50, 0),
('Hair Dryer Professional', 2200, 'Personal Care', 'Philips', 'assets/flash/dryer.jpg', 35, 1),
('Hair Dryer Compact', 1950, 'Personal Care', 'Panasonic', 'assets/flash/dyrer.jpg', 40, 2),
('Hand Mixer', 1650, 'Kitchen Appliances', 'Walton', 'assets/flash/handmixxer.jpg', 45, 3),
('Iron Master', 2100, 'Home Appliances', 'Vision', 'assets/flash/ironma.jpg', 60, 4),
('JY Mini Rice Cooker 1880', 3200, 'Kitchen Appliances', 'Jamuna', 'assets/flash/jy mini 1880.jpg', 30, 5),
('Kennede Charger Fan', 2800, 'Electronics', 'LG', 'assets/flash/kennede.jpg', 55, 6),
('LR2018 Blender', 4500, 'Kitchen Appliances', 'Samsung', 'assets/flash/lr2018.jpg', 25, 7),
('Miyoko Electric Kettle', 1750, 'Kitchen Appliances', 'Gree', 'assets/flash/miyoko_kettle.jpg', 70, 8),
('Nima Grinder 400W', 3800, 'Kitchen Appliances', 'Walton', 'assets/flash/nima_grinder.jpg', 40, 9),
('Pink Leather Iron', 2300, 'Home Appliances', 'Singer', 'assets/flash/pink.jpg', 50, 10),
('Scarlet Hand Mixer', 1900, 'Kitchen Appliances', 'Philips', 'assets/flash/scarlet handmixer.jpg', 45, 11),
('WD Mini Fan', 1200, 'Electronics', 'Vision', 'assets/flash/wd minifan.jpg', 80, 12),
('YG Mini Cooker 717', 2900, 'Kitchen Appliances', 'Jamuna', 'assets/flash/yg mini 717.jpg', 35, 13);

-- Ensure categories exist
INSERT INTO categories (category_name)
SELECT DISTINCT t.category_name
FROM tmp_flash_products t
LEFT JOIN categories c ON c.category_name = t.category_name
WHERE c.category_id IS NULL;

-- Ensure brands exist
INSERT INTO brands (brand_name)
SELECT DISTINCT t.brand_name
FROM tmp_flash_products t
LEFT JOIN brands b ON b.brand_name = t.brand_name
WHERE b.brand_id IS NULL;

-- Insert missing products
INSERT INTO products (category_id, brand_id, product_name, description, price, stock_quantity, image_url)
SELECT
  c.category_id,
  b.brand_id,
  t.product_name,
  CONCAT('High quality ', t.product_name, ' from ', t.brand_name, '. Perfect for your home needs.'),
  t.price,
  t.stock_quantity,
  t.image_path
FROM tmp_flash_products t
JOIN categories c ON c.category_name = t.category_name
JOIN brands b ON b.brand_name = t.brand_name
LEFT JOIN products p ON p.product_name = t.product_name
WHERE p.product_id IS NULL;

-- Keep existing products in sync with this dataset
UPDATE products p
JOIN tmp_flash_products t ON t.product_name = p.product_name
JOIN categories c ON c.category_name = t.category_name
JOIN brands b ON b.brand_name = t.brand_name
SET
  p.category_id = c.category_id,
  p.brand_id = b.brand_id,
  p.price = t.price,
  p.stock_quantity = t.stock_quantity,
  p.image_url = t.image_path;

-- Ensure one active flash sale exists for this dataset
SET @flash_sale_id := (
  SELECT flash_sale_id
  FROM flash_sales
  WHERE title = 'Flash Sale 2026'
  ORDER BY flash_sale_id DESC
  LIMIT 1
);

INSERT INTO flash_sales (title, start_time, end_time, active)
SELECT 'Flash Sale 2026', NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY), 1
WHERE @flash_sale_id IS NULL;

SET @flash_sale_id := (
  SELECT flash_sale_id
  FROM flash_sales
  WHERE title = 'Flash Sale 2026'
  ORDER BY flash_sale_id DESC
  LIMIT 1
);

-- Insert or update flash section entries
INSERT INTO flash_sale_products (flash_sale_id, product_id, flash_price, image_path, display_order)
SELECT
  @flash_sale_id,
  p.product_id,
  ROUND(t.price * 0.85, 2),
  t.image_path,
  t.display_order
FROM tmp_flash_products t
JOIN products p ON p.product_name = t.product_name
ON DUPLICATE KEY UPDATE
  flash_price = VALUES(flash_price),
  image_path = VALUES(image_path),
  display_order = VALUES(display_order);

DROP TEMPORARY TABLE IF EXISTS tmp_flash_products;

SELECT 'Flash Sale products inserted!' as Status;

-- ============================================
-- STEP 3: INSERT TRENDING PRODUCTS
-- ============================================

DROP TEMPORARY TABLE IF EXISTS tmp_trending_products;
CREATE TEMPORARY TABLE tmp_trending_products (
  product_name VARCHAR(150) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  category_name VARCHAR(100) NOT NULL,
  brand_name VARCHAR(100) NOT NULL,
  image_path VARCHAR(255) NOT NULL,
  stock_quantity INT NOT NULL,
  trending_score INT NOT NULL,
  display_order INT NOT NULL
);

INSERT INTO tmp_trending_products (product_name, price, category_name, brand_name, image_path, stock_quantity, trending_score, display_order) VALUES
('Air Fryer Digital', 7200, 'Kitchen Appliances', 'Philips', 'assets/trends/air_fryer.jpg', 40, 95, 0),
('AV Sandwich Maker', 1850, 'Kitchen Appliances', 'Singer', 'assets/trends/av sandwich maker.jpg', 60, 88, 1),
('AV Multi Cooker', 3200, 'Kitchen Appliances', 'Singer', 'assets/trends/av.jpg', 35, 82, 2),
('Blender Pro 2000', 4500, 'Kitchen Appliances', 'Walton', 'assets/trends/blender.jpg', 50, 90, 3),
('Electric Kettle', 1750, 'Kitchen Appliances', 'Gree', 'assets/trends/catllee.jpg', 80, 85, 4),
('Charger Fan Portable', 2200, 'Electronics', 'LG', 'assets/trends/chargerfan.jpg', 70, 78, 5),
('Electric Stove Single', 1250, 'Kitchen Appliances', 'Vision', 'assets/trends/elec_stove.jpg', 55, 75, 6),
('Hair Dryer Professional', 3200, 'Personal Care', 'Panasonic', 'assets/trends/hair_drier.jpg', 45, 87, 7),
('Hand Blender 3-in-1', 2800, 'Kitchen Appliances', 'Samsung', 'assets/trends/hand_blender.jpg', 50, 83, 8),
('Head Massager Electric', 3800, 'Personal Care', 'Sony', 'assets/trends/head_massager.jpg', 30, 80, 9),
('Kennede Rechargeable Fan', 2900, 'Electronics', 'LG', 'assets/trends/kennede.jpg', 65, 86, 10),
('Mini Cooker Compact', 2500, 'Kitchen Appliances', 'Jamuna', 'assets/trends/mini_cooker.jpg', 40, 79, 11),
('Mini Cooker Deluxe', 3100, 'Kitchen Appliances', 'Jamuna', 'assets/trends/mini2cokker.jpg', 35, 81, 12),
('Mini Hand Blender', 1900, 'Kitchen Appliances', 'Walton', 'assets/trends/minihand.jpg', 55, 76, 13),
('Miyoko Oven 25L', 8500, 'Kitchen Appliances', 'Gree', 'assets/trends/miyoko 25l oven.jpg', 25, 92, 14),
('Miyoko Electric Kettle', 1650, 'Kitchen Appliances', 'Gree', 'assets/trends/miyoko.jpg', 75, 84, 15),
('Noha Hot King Cooker', 4200, 'Kitchen Appliances', 'Vision', 'assets/trends/noha hot king.jpg', 30, 88, 16),
('Pink Leather Iron', 2300, 'Home Appliances', 'Singer', 'assets/trends/pink.jpg', 60, 77, 17),
('Rice Cooker 1.8L', 3500, 'Kitchen Appliances', 'Walton', 'assets/trends/rice_cooker.jpg', 50, 89, 18),
('Hair Styling Tool', 2700, 'Personal Care', 'Philips', 'assets/trends/tele_sett.jpg', 40, 82, 19);

-- Ensure categories exist
INSERT INTO categories (category_name)
SELECT DISTINCT t.category_name
FROM tmp_trending_products t
LEFT JOIN categories c ON c.category_name = t.category_name
WHERE c.category_id IS NULL;

-- Ensure brands exist
INSERT INTO brands (brand_name)
SELECT DISTINCT t.brand_name
FROM tmp_trending_products t
LEFT JOIN brands b ON b.brand_name = t.brand_name
WHERE b.brand_id IS NULL;

-- Insert missing products
INSERT INTO products (category_id, brand_id, product_name, description, price, stock_quantity, image_url)
SELECT
  c.category_id,
  b.brand_id,
  t.product_name,
  CONCAT('Trending ', t.product_name, ' from ', t.brand_name, '. High demand product with excellent features.'),
  t.price,
  t.stock_quantity,
  t.image_path
FROM tmp_trending_products t
JOIN categories c ON c.category_name = t.category_name
JOIN brands b ON b.brand_name = t.brand_name
LEFT JOIN products p ON p.product_name = t.product_name
WHERE p.product_id IS NULL;

-- Keep existing products in sync with this dataset
UPDATE products p
JOIN tmp_trending_products t ON t.product_name = p.product_name
JOIN categories c ON c.category_name = t.category_name
JOIN brands b ON b.brand_name = t.brand_name
SET
  p.category_id = c.category_id,
  p.brand_id = b.brand_id,
  p.price = t.price,
  p.stock_quantity = t.stock_quantity,
  p.image_url = t.image_path;

-- Insert or update trending section entries
INSERT INTO trending_products (product_id, trending_score, image_path, display_order)
SELECT
  p.product_id,
  t.trending_score,
  t.image_path,
  t.display_order
FROM tmp_trending_products t
JOIN products p ON p.product_name = t.product_name
ON DUPLICATE KEY UPDATE
  trending_score = VALUES(trending_score),
  image_path = VALUES(image_path),
  display_order = VALUES(display_order);

DROP TEMPORARY TABLE IF EXISTS tmp_trending_products;

SELECT 'Trending products inserted!' as Status;

-- ============================================
-- VERIFICATION
-- ============================================

SELECT '============================================' as '';
SELECT 'Setup Complete!' as Status;
SELECT '============================================' as '';
SELECT COUNT(*) as 'Flash Sale Products' FROM flash_sale_products;
SELECT COUNT(*) as 'Trending Products' FROM trending_products;
SELECT '============================================' as '';
