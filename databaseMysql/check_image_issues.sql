-- Check for image loading issues
USE electrobd;

SELECT '============================================' as '';
SELECT 'Checking Image Paths' as Status;
SELECT '============================================' as '';

-- Check all unique image paths
SELECT 'All unique image paths:' as Info;
SELECT DISTINCT image_url, COUNT(*) as count
FROM products
WHERE image_url IS NOT NULL AND image_url != ''
GROUP BY image_url
ORDER BY image_url
LIMIT 20;

-- Check for problematic paths
SELECT 'Paths with spaces:' as Info;
SELECT product_id, product_name, image_url
FROM products
WHERE image_url LIKE '% %'
LIMIT 10;

-- Check for paths with special characters
SELECT 'Paths with special characters:' as Info;
SELECT product_id, product_name, image_url
FROM products
WHERE image_url REGEXP '[^a-zA-Z0-9/._-]'
LIMIT 10;

-- Check trending products specifically
SELECT 'Trending products images:' as Info;
SELECT p.product_id, p.product_name, p.image_url,
       CASE 
           WHEN p.image_url LIKE 'assets/%' THEN 'Asset Path'
           WHEN p.image_url LIKE 'http%' THEN 'Network URL'
           WHEN p.image_url LIKE '/uploads/%' THEN 'Upload Path'
           ELSE 'Unknown Format'
       END as path_type
FROM products p
JOIN trending_products tp ON p.product_id = tp.product_id
ORDER BY tp.display_order
LIMIT 20;
