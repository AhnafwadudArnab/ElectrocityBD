-- Use the database
USE electrocity_db;

-- Insert sample users (no password hash, just plain text for demo)
INSERT INTO users (full_name, email, password_hash, phone_number, address, role)
VALUES
('Admin User', 'admin@electrocitybd.com', 'admin123', '01700000001', 'Dhaka, Bangladesh', 'admin'),
('Moderator User', 'mod@electrocitybd.com', 'mod123', '01700000002', 'Chittagong, Bangladesh', 'moderator'),
('Technician One', 'tech1@electrocitybd.com', 'tech123', '01700000003', 'Khulna, Bangladesh', 'technician'),
('Customer One', 'customer1@electrocitybd.com', 'cust123', '01700000004', 'Sylhet, Bangladesh', 'customer'),
('Customer Two', 'customer2@electrocitybd.com', 'cust456', '01700000005', 'Rajshahi, Bangladesh', 'customer');

-- Insert sample categories
INSERT INTO categories (category_name, category_image)
VALUES
('Lighting', 'lighting.png'),
('Wiring', 'wiring.png'),
('Tools', 'tools.png');

-- Insert sample products
INSERT INTO products (category_id, product_name, description, price, stock_quantity, image_url)
VALUES
(1, 'LED Bulb', 'Energy saving LED bulb', 150.00, 100, 'led_bulb.png'),
(1, 'Tube Light', 'Bright tube light', 250.00, 50, 'tube_light.png'),
(2, 'Copper Wire', 'High quality copper wire', 500.00, 200, 'copper_wire.png'),
(3, 'Screwdriver Set', 'Multi-purpose screwdriver set', 350.00, 75, 'screwdriver_set.png');

-- Insert sample cart items
INSERT INTO cart (user_id, product_id, quantity)
VALUES
(4, 1, 2),
(5, 3, 1);

-- Insert sample orders
INSERT INTO orders (user_id, total_amount, order_status, payment_status, delivery_address)
VALUES
(4, 300.00, 'pending', 'unpaid', 'Sylhet, Bangladesh'),
(5, 500.00, 'processing', 'paid', 'Rajshahi, Bangladesh');

-- Insert sample order items
INSERT INTO order_items (order_id, product_id, quantity, price_at_purchase)
VALUES
(1, 1, 2, 150.00),
(2, 3, 1, 500.00);

-- Insert sample bookings
INSERT INTO bookings (user_id, service_description, preferred_date, booking_status, technician_id)
VALUES
(4, 'Fan installation', '2026-02-25', 'pending', 3),
(5, 'Wiring check', '2026-02-26', 'confirmed', 3);

-- Insert sample wishlists
INSERT INTO wishlists (user_id, product_id)
VALUES
(4, 2),
(5, 4);

-- Insert sample support tickets
INSERT INTO customer_support (user_id, subject, message, status)
VALUES
(4, 'Order Delay', 'My order is delayed. Please help.', 'open'),
(5, 'Product Inquiry', 'Is the screwdriver set available?', 'resolved');

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