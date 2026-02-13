-- Sample Data for Testing

-- Insert Sample Categories
INSERT INTO categories (category_name, description) VALUES
('Monitors', 'Computer Monitors and Displays'),
('Laptops', 'Laptops and Notebooks'),
('Desktops', 'Desktop Computers'),
('Components', 'PC Components'),
('Accessories', 'Computer Accessories'),
('Gaming', 'Gaming Products');

-- Insert Sample Brands
INSERT INTO brands (brand_name, is_featured) VALUES
('Dell', TRUE),
('HP', TRUE),
('Asus', TRUE),
('Lenovo', TRUE),
('Samsung', TRUE),
('LG', TRUE),
('Acer', TRUE),
('MSI', TRUE);

-- Insert Sample Products
INSERT INTO products (product_name, category_id, brand_id, description, price, discount_price, stock_quantity, sku, is_featured, is_trending) VALUES
('Dell UltraSharp 27" Monitor', 1, 1, 'High-quality 4K monitor', 35000.00, 32000.00, 25, 'DELL-MON-001', TRUE, TRUE),
('HP Pavilion Gaming Laptop', 2, 2, '15.6" Gaming Laptop with RTX 3060', 95000.00, 89000.00, 15, 'HP-LAP-001', TRUE, FALSE),
('Asus ROG Monitor 32"', 1, 3, 'Gaming monitor 165Hz', 45000.00, 42000.00, 10, 'ASUS-MON-001', FALSE, TRUE);

-- Insert Admin User (password: admin123 - should be hashed in production)
INSERT INTO users (username, email, password_hash, full_name, role) VALUES
('admin', 'admin@electrocitybd.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin User', 'admin');