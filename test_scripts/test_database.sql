-- Database Testing Script
-- Run this to verify database integrity

-- 1. Check all tables exist
SELECT 'Checking tables...' as status;
SELECT 
    TABLE_NAME,
    TABLE_ROWS,
    ROUND(((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024), 2) AS 'Size (MB)'
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'electrobd'
ORDER BY TABLE_NAME;

-- 2. Check users table
SELECT 'Checking users...' as status;
SELECT COUNT(*) as total_users FROM users;
SELECT role, COUNT(*) as count FROM users GROUP BY role;

-- 3. Check products table
SELECT 'Checking products...' as status;
SELECT COUNT(*) as total_products FROM products;
SELECT 
    CASE 
        WHEN stock_quantity > 0 THEN 'In Stock'
        ELSE 'Out of Stock'
    END as stock_status,
    COUNT(*) as count
FROM products
GROUP BY stock_status;

-- 4. Check orders table
SELECT 'Checking orders...' as status;
SELECT COUNT(*) as total_orders FROM orders;
SELECT status, COUNT(*) as count FROM orders GROUP BY status;

-- 5. Check categories table
SELECT 'Checking categories...' as status;
SELECT COUNT(*) as total_categories FROM categories;

-- 6. Check brands table
SELECT 'Checking brands...' as status;
SELECT COUNT(*) as total_brands FROM brands;

-- 7. Check notifications table
SELECT 'Checking notifications...' as status;
SELECT COUNT(*) as total_notifications FROM notifications;
SELECT type, COUNT(*) as count FROM notifications GROUP BY type;

-- 8. Check rate_limits table
SELECT 'Checking rate_limits...' as status;
SELECT COUNT(*) as total_rate_limits FROM rate_limits;

-- 9. Check for orphaned records
SELECT 'Checking data integrity...' as status;

-- Orphaned order items
SELECT COUNT(*) as orphaned_order_items
FROM order_items 
WHERE order_id NOT IN (SELECT order_id FROM orders);

-- Orphaned products (no category)
SELECT COUNT(*) as products_without_category
FROM products 
WHERE category_id IS NOT NULL 
AND category_id NOT IN (SELECT category_id FROM categories);

-- 10. Check indexes
SELECT 'Checking indexes...' as status;
SELECT 
    TABLE_NAME,
    INDEX_NAME,
    COLUMN_NAME
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'electrobd'
ORDER BY TABLE_NAME, INDEX_NAME;

-- 11. Summary
SELECT 'Database check completed!' as status;
