-- ============================================
-- Fix Fans Collection - Remove Wrong Products
-- ============================================
USE electrobd;

SELECT '============================================' as '';
SELECT 'Fixing Fans Collection' as Status;
SELECT '============================================' as '';

-- Show current products in Fans collection
SELECT 'Current products in Fans collection:' as Info;
SELECT 
    p.product_id,
    p.product_name,
    c.category_name,
    b.brand_name
FROM collection_products cp
JOIN products p ON cp.product_id = p.product_id
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN brands b ON p.brand_id = b.brand_id
WHERE cp.collection_id = 1
ORDER BY p.product_id;

-- Remove products that are NOT fans
-- Product 1: Miyako Curry Cooker (Kitchen Appliances) - REMOVE
-- Product 4: Sokany Hair Dryer (Personal Care) - REMOVE
SELECT 'Removing non-fan products from Fans collection...' as Status;

DELETE FROM collection_products 
WHERE collection_id = 1 
AND product_id IN (1, 4);

SELECT 'Removed Curry Cooker and Hair Dryer from Fans collection' as Status;

-- Add actual fan products from Electronics category if not already added
SELECT 'Adding Electronics category fans to collection...' as Status;

INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 1, p.product_id
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE c.category_name = 'Electronics'
AND p.product_name LIKE '%Fan%';

SELECT 'Added Electronics fans to collection' as Status;

-- Show updated products in Fans collection
SELECT 'Updated products in Fans collection:' as Info;
SELECT 
    p.product_id,
    p.product_name,
    c.category_name,
    b.brand_name
FROM collection_products cp
JOIN products p ON cp.product_id = p.product_id
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN brands b ON p.brand_id = b.brand_id
WHERE cp.collection_id = 1
ORDER BY p.product_id;

-- Update collection item count
UPDATE collections 
SET item_count = (
    SELECT COUNT(*) 
    FROM collection_products 
    WHERE collection_id = 1
)
WHERE collection_id = 1;

SELECT '============================================' as '';
SELECT 'Fans Collection Fixed!' as Status;
SELECT '============================================' as '';

SELECT 
    'Total Fan Products' as Metric,
    COUNT(*) as Count
FROM collection_products
WHERE collection_id = 1;

SELECT '============================================' as '';
SELECT 'Only actual fan products are now in Fans collection' as Note;
