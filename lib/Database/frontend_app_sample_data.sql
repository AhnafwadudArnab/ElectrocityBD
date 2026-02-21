-- Use the database
USE sql12817693;

-- Insert sample users (with PASSWORD column, roles: admin/customer)
INSERT INTO users (full_name, last_name, email, PASSWORD, phone_number, address, role)
VALUES
('Admin', 'User', 'admin@electrocitybd.com', 'admin123', '01700000001', 'Dhaka, Bangladesh', 'admin'),
('Customer', 'One', 'customer1@electrocitybd.com', 'cust123', '01700000004', 'Sylhet, Bangladesh', 'customer'),
('Customer', 'Two', 'customer2@electrocitybd.com', 'cust456', '01700000005', 'Rajshahi, Bangladesh', 'customer');

-- Insert sample brands
INSERT INTO brands (brand_name, brand_logo)
VALUES
('Philips', 'philips_logo.png'),
('Walton', 'walton_logo.png');

-- Insert sample categories
INSERT INTO categories (category_name, category_image)
VALUES
('Lighting', 'lighting.png'),
('Wiring', 'wiring.png'),
('Tools', 'tools.png');

-- Insert sample products
INSERT INTO products (category_id, brand_id, product_name, description, price, stock_quantity, image_url)
VALUES
(1, 1, 'LED Bulb', 'Energy saving LED bulb', 150.00, 100, 'led_bulb.png'),
(1, 1, 'Tube Light', 'Bright tube light', 250.00, 50, 'tube_light.png'),
(2, 2, 'Copper Wire', 'High quality copper wire', 500.00, 200, 'copper_wire.png'),
(3, 2, 'Screwdriver Set', 'Multi-purpose screwdriver set', 350.00, 75, 'screwdriver_set.png');

-- Insert sample cart items
INSERT INTO cart (user_id, product_id, quantity)
VALUES
(2, 1, 2),
(3, 3, 1);

-- Insert sample orders
INSERT INTO orders (user_id, total_amount, order_status, payment_status, delivery_address)
VALUES
(2, 300.00, 'pending', 'unpaid', 'Sylhet, Bangladesh'),
(3, 500.00, 'processing', 'paid', 'Rajshahi, Bangladesh');

-- Insert sample order items
INSERT INTO order_items (order_id, product_id, quantity, price_at_purchase)
VALUES
(1, 1, 2, 150.00),
(2, 3, 1, 500.00);

-- Insert sample bookings
INSERT INTO bookings (user_id, service_description, preferred_date, booking_status, technician_id)
VALUES
(2, 'Fan installation', '2026-02-25', 'pending', NULL),
(3, 'Wiring check', '2026-02-26', 'confirmed', NULL);

-- Insert sample wishlists
INSERT INTO wishlists (user_id, product_id)
VALUES
(2, 2),
(3, 4);

-- Insert sample support tickets
INSERT INTO customer_support (user_id, subject, message, status)
VALUES
(2, 'Order Delay', 'My order is delayed. Please help.', 'open'),
(3, 'Product Inquiry', 'Is the screwdriver set available?', 'resolved');

-- Insert sample promotions
INSERT INTO promotions (title, description, discount_percent, start_date, end_date, active)
VALUES
('Winter Sale', 'Up to 20% off on all lighting products', 20.00, '2026-02-01', '2026-02-28', TRUE),
('Tools Discount', '10% off on all tools', 10.00, '2026-02-10', '2026-03-10', TRUE);

-- Insert sample product promotions
INSERT INTO product_promotions (product_id, promotion_id)
VALUES
(1, 1),
(4, 2);

-- Insert sample featured brands
INSERT INTO featured_brands (brand_id, featured)
VALUES
(1, TRUE),
(2, TRUE);

-- Insert sample deals of the day
INSERT INTO deals_of_the_day (product_id, deal_price, start_date, end_date)
VALUES
(1, 120.00, '2026-02-21 00:00:00', '2026-02-22 23:59:59');

-- Insert sample mid banners
INSERT INTO mid_banners (image_url, link_url, active, start_date, end_date)
VALUES
('banner1.png', 'https://electrocitybd.com/deals', TRUE, '2026-02-01 00:00:00', '2026-02-28 23:59:59');

-- Insert sample offers upto 90
INSERT INTO offers_upto_90 (product_id, discount_percent, start_date, end_date)
VALUES
(2, 90.00, '2026-02-15 00:00:00', '2026-02-20 23:59:59');

-- Insert sample promo cards
INSERT INTO promo_cards (title, description, image_url, link_url, active, start_date, end_date)
VALUES
('Special Offer', 'Limited time offer on LED Bulbs', 'promo_led.png', 'https://electrocitybd.com/led', TRUE, '2026-02-21 00:00:00', '2026-02-22 23:59:59');

-- Insert sample tech part
INSERT INTO tech_part (product_id, featured)
VALUES
(4, TRUE);

-- Insert sample best sellers
INSERT INTO best_sellers (product_id, sales_count, last_updated)
VALUES
(1, 50, NOW());

-- Insert sample trending products
INSERT INTO trending_products (product_id, trending_score, last_updated)
VALUES
(2, 80, NOW());

-- Insert sample flash sales
INSERT INTO flash_sales (title, start_time, end_time, active)
VALUES
('Flash Sale February', '2026-02-21 10:00:00', '2026-02-21 22:00:00', TRUE);

-- Insert sample flash sale products
INSERT INTO flash_sale_products (flash_sale_id, product_id)
VALUES
(1, 1),
(1, 2);

-- Insert sample collections
INSERT INTO collections (name, description, image_url)
VALUES
('Home Essentials', 'Must-have products for every home', 'home_essentials.png');

-- Insert sample collection products
INSERT INTO collection_products (collection_id, product_id)
VALUES
(1, 1),
(1, 4);

-- Insert sample reports
INSERT INTO reports (admin_id, report_type, details)
VALUES
(1, 'Sales', 'Sales report for February');