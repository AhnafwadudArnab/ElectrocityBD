-- ============================================================
-- ElectrocityBD - Asset products (category-wise)
-- Run after electrocity_schema.sql and electrocity_sample_data.sql
-- Products use image_url = 'asset:assets/...' so app loads from Flutter assets.
-- New/updated products from Admin use /uploads/... and load from network.
-- Category: 1=Kitchen, 2=Personal Care, 3=Home Comfort, 4=Lighting, 5=Wiring, 6=Tools
-- ============================================================

USE electrocity_db;

-- Kitchen Appliances (category_id = 1)
INSERT INTO products (category_id, brand_id, product_name, description, price, stock_quantity, image_url) VALUES
(1, 1, 'Rice Cooker', 'Auto cook rice cooker', 5500.00, 50, 'asset:assets/prod/rice_cooker.jpg'),
(1, 2, 'Electric Stove', 'Portable electric stove', 4200.00, 40, 'asset:assets/prod/elec_stove.jpg'),
(1, 3, 'Hand Blender', 'Corded hand blender', 3200.00, 35, 'asset:assets/prod/hand_blender.jpg'),
(1, 1, 'Chopper', 'Electric chopper', 2500.00, 45, 'asset:assets/prod/chopper.jpg'),
(1, 2, 'Grinder', 'Variable speed grinder', 4500.00, 30, 'asset:assets/prod/grinder.jpg'),
(1, 3, 'Blender', 'Multi-speed blender', 3800.00, 40, 'asset:assets/prod/blender.jpg'),
(1, 1, 'Kettle', 'Electric kettle', 2200.00, 60, 'asset:assets/prod/catllee.jpg'),
(1, 2, 'Oven', 'Convection oven', 15000.00, 20, 'asset:assets/prod/oven.jpg'),
(1, 3, 'Air Fryer', 'Digital air fryer', 8500.00, 25, 'asset:assets/prod/air_fryer.jpg'),
(1, 1, 'Curry Cooker', 'Non-stick curry cooker', 3800.00, 35, 'asset:assets/prod/curry_cooker.jpg'),
(1, 2, 'Coffee Maker', 'Auto brew coffee maker', 6500.00, 25, 'asset:assets/prod/catllee.jpg'),
(1, 3, 'Induction Stove', 'Fast heating induction', 8500.00, 20, 'asset:assets/prod/induction_stove.jpg'),
(1, 1, 'Mini Cooker', 'Compact mini cooker', 3500.00, 40, 'asset:assets/prod/mini_cooker.jpg'),
(1, 2, 'Mini Cooker Deluxe', 'Multi-function mini cooker', 4200.00, 30, 'asset:assets/prod/mini2cokker.jpg'),
(1, 3, 'Mini Hand Blender', 'Lightweight hand blender', 2500.00, 50, 'asset:assets/prod/minihand.jpg'),
(1, 1, 'Rice Cooker Pro', 'Digital rice cooker', 7800.00, 25, 'asset:assets/prod/riceCooker2.jpg'),
(1, 2, 'Hand Blender Pro', 'Powerful hand blender', 7200.00, 20, 'asset:assets/prod/hand_blender23.jpg');

-- Personal Care & Lifestyle (category_id = 2)
INSERT INTO products (category_id, brand_id, product_name, description, price, stock_quantity, image_url) VALUES
(2, 1, 'Hair Dryer', 'Multiple heat hair dryer', 3200.00, 30, 'asset:assets/prod/hair_drier.jpg'),
(2, 2, 'Trimmer', 'Compact electric trimmer', 2800.00, 45, 'asset:assets/prod/trimmer.jpg'),
(2, 3, 'Trimmer Pro', 'Rechargeable trimmer', 4500.00, 25, 'asset:assets/prod/trimmeer2.jpg'),
(2, 1, 'Head Massager', 'Vibration head massager', 3800.00, 35, 'asset:assets/prod/head_massager.jpg'),
(2, 2, 'Massage Gun', 'Portable massage gun', 6200.00, 20, 'asset:assets/prod/massage_gun.jpg'),
(2, 3, 'Hair Styling Tool', 'Ceramic hair styler', 3200.00, 30, 'asset:assets/prod/tele_sett.jpg');

-- Home Comfort & Utility (category_id = 3) – Fan, Iron, Charger Fan, Portable Fan
INSERT INTO products (category_id, brand_id, product_name, description, price, stock_quantity, image_url) VALUES
(3, 1, 'Iron', 'Steam electric iron', 2800.00, 40, 'asset:assets/prod/iron.jpg'),
(3, 2, 'Charger Fan', 'USB charging fan', 2200.00, 50, 'asset:assets/prod/chargerfan.jpg'),
(3, 3, 'Portable Fan', 'USB powered portable fan', 4200.00, 35, 'asset:assets/prod/hFan3.jpg'),
(3, 1, 'Fan', 'Variable speed fan', 13500.00, 25, 'asset:assets/prod/fan2.jpg');

-- Tools (category_id = 6) – Power tools from assets/flash
INSERT INTO products (category_id, brand_id, product_name, description, price, stock_quantity, image_url) VALUES
(6, 1, 'Circular Saw', 'Laser guide circular saw', 7200.00, 15, 'asset:assets/flash/Circular Saw.jpg'),
(6, 2, 'Orbital Sander', 'LED orbital sander', 3800.00, 20, 'asset:assets/flash/Orbital Sander.jpg'),
(6, 3, 'Rotary Hammer Drill', 'Heavy-duty hammer drill', 6500.00, 18, 'asset:assets/flash/Rotary Hammer Drill.jpg');

-- Tech / Electronics style (category_id = 3, assets/Products)
INSERT INTO products (category_id, brand_id, product_name, description, price, stock_quantity, image_url) VALUES
(3, 1, 'Acer SB220Q Monitor', '21.5 Inches Full HD', 9400.00, 20, 'asset:assets/Products/1.png'),
(3, 2, 'Intel Core i7 12th Gen', 'Desktop processor', 45999.00, 10, 'asset:assets/Products/1.png'),
(3, 3, 'ASUS ROG Strix G15', 'Gaming laptop', 120000.00, 8, 'asset:assets/Products/2.jpg'),
(3, 1, 'Logitech MX Master 3', 'Wireless mouse', 8500.00, 25, 'asset:assets/Products/3.jpg'),
(3, 2, 'Samsung T7 Portable SSD', '1TB portable SSD', 12000.00, 15, 'asset:assets/Products/4.jpg'),
(3, 3, 'Corsair K95 RGB Keyboard', 'Mechanical gaming keyboard', 18000.00, 12, 'asset:assets/Products/5.jpg'),
(3, 1, 'Razer DeathAdder V2 Pro', 'Wireless gaming mouse', 10500.00, 18, 'asset:assets/Products/6.jpg'),
(3, 2, 'Dell UltraSharp U2723QE', '27 Inch 4K Monitor', 35000.00, 10, 'asset:assets/Products/7.png');

-- Deals of the Day (category_id by product type)
INSERT INTO products (category_id, brand_id, product_name, description, price, stock_quantity, image_url) VALUES
(3, 2, 'CCTV Camera', 'Samsung CCTV camera', 8500.00, 20, 'asset:assets/Deals of the Day/2.png'),
(1, 2, 'Blender 3-in-1 Machine', 'Walton 3-in-1 blender', 5500.00, 30, 'asset:assets/Deals of the Day/9.png'),
(1, 1, 'Cooker 5L', 'Panasonic 5L cooker', 8500.00, 25, 'asset:assets/Deals of the Day/3.png'),
(3, 1, 'Fan', 'Jamuna fan', 4200.00, 40, 'asset:assets/Deals of the Day/5.png'),
(3, 2, 'AC 1.5 Ton', 'Walton 1.5 ton AC', 32200.00, 12, 'asset:assets/Deals of the Day/6.png'),
(3, 2, 'AC 2 Ton', 'Walton 2 ton AC', 46500.00, 10, 'asset:assets/Deals of the Day/6.png'),
(1, 1, 'Mixer Grinder', 'Panasonic mixer grinder', 2800.00, 50, 'asset:assets/Deals of the Day/09.png'),
(3, 3, 'Air Purifier', 'Hikvision air purifier', 18500.00, 15, 'asset:assets/Deals of the Day/7.png'),
(3, 1, 'Bluetooth Headphones', 'P9 Max headphones', 1850.00, 60, 'asset:assets/Deals of the Day/1.png');

-- Add new asset products to section tables (so they show on homepage)
-- Trending: all asset products
INSERT IGNORE INTO trending_products (product_id, trending_score)
SELECT product_id, 50 FROM products WHERE image_url LIKE 'asset:%';

-- Best sellers: first 10 asset products
INSERT IGNORE INTO best_sellers (product_id, sales_count)
SELECT product_id, 30 FROM products WHERE image_url LIKE 'asset:%' ORDER BY product_id LIMIT 10;

-- Deals of the day: some asset products
INSERT IGNORE INTO deals_of_the_day (product_id, deal_price, start_date, end_date)
SELECT product_id, price * 0.9, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)
FROM products WHERE image_url LIKE 'asset:%' ORDER BY product_id LIMIT 5;

-- Flash sale: add asset products to active flash sale
INSERT IGNORE INTO flash_sale_products (flash_sale_id, product_id)
SELECT 1, product_id FROM products WHERE image_url LIKE 'asset:%' LIMIT 8;

-- Tech part: add some for tech section
INSERT IGNORE INTO tech_part_products (product_id, display_order)
SELECT product_id, 0 FROM products WHERE image_url LIKE 'asset:%' AND category_id = 3 ORDER BY product_id LIMIT 6;
