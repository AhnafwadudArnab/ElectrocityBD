-- ============================================
-- Fix Image Paths in Database
-- ============================================
USE electrobd;

-- Backup current paths (optional)
-- CREATE TABLE IF NOT EXISTS products_backup AS SELECT * FROM products;

-- ============================================
-- 1. Standardize asset paths (remove leading /)
-- ============================================

-- Fix products table
UPDATE products 
SET image_url = REPLACE(image_url, '/assets/', 'assets/')
WHERE image_url LIKE '/assets/%';

-- Fix flash_sale_products table
UPDATE flash_sale_products 
SET image_path = REPLACE(image_path, '/assets/', 'assets/')
WHERE image_path LIKE '/assets/%';

-- Fix trending_products table
UPDATE trending_products 
SET image_path = REPLACE(image_path, '/assets/', 'assets/')
WHERE image_path LIKE '/assets/%';

SELECT 'Step 1: Removed leading slashes from asset paths' as Status;

-- ============================================
-- 2. Check for empty or null image paths
-- ============================================

SELECT 'Products with empty/null images:' as Info;
SELECT product_id, product_name, image_url 
FROM products 
WHERE image_url IS NULL OR image_url = '' OR TRIM(image_url) = '';

SELECT 'Flash Sale products with empty/null images:' as Info;
SELECT fsp.product_id, p.product_name, p.image_url, fsp.image_path
FROM flash_sale_products fsp
JOIN products p ON fsp.product_id = p.product_id
WHERE (p.image_url IS NULL OR p.image_url = '') 
  AND (fsp.image_path IS NULL OR fsp.image_path = '');

SELECT 'Trending products with empty/null images:' as Info;
SELECT tp.product_id, p.product_name, p.image_url, tp.image_path
FROM trending_products tp
JOIN products p ON tp.product_id = p.product_id
WHERE (p.image_url IS NULL OR p.image_url = '') 
  AND (tp.image_path IS NULL OR tp.image_path = '');

-- ============================================
-- 3. Verify image path formats
-- ============================================

SELECT 'Image path format distribution:' as Info;

SELECT 
    CASE 
        WHEN image_url LIKE 'http://%' OR image_url LIKE 'https://%' THEN 'Network URL'
        WHEN image_url LIKE 'assets/%' THEN 'Asset Path (Correct)'
        WHEN image_url LIKE '/assets/%' THEN 'Asset Path (Leading Slash - FIXED)'
        WHEN image_url LIKE '/uploads/%' THEN 'Upload Path'
        WHEN image_url IS NULL OR image_url = '' THEN 'Empty/Null'
        ELSE 'Other'
    END as path_type,
    COUNT(*) as count,
    GROUP_CONCAT(DISTINCT SUBSTRING(image_url, 1, 50) SEPARATOR ', ') as examples
FROM products
GROUP BY path_type;

-- ============================================
-- 4. Check section-specific image paths
-- ============================================

SELECT 'Flash Sale image paths:' as Info;
SELECT 
    p.product_name,
    p.image_url as product_image,
    fsp.image_path as section_image,
    COALESCE(fsp.image_path, p.image_url) as final_image
FROM flash_sale_products fsp
JOIN products p ON fsp.product_id = p.product_id
ORDER BY fsp.created_at DESC
LIMIT 10;

SELECT 'Trending image paths:' as Info;
SELECT 
    p.product_name,
    p.image_url as product_image,
    tp.image_path as section_image,
    COALESCE(tp.image_path, p.image_url) as final_image
FROM trending_products tp
JOIN products p ON tp.product_id = p.product_id
ORDER BY tp.created_at DESC
LIMIT 10;

-- ============================================
-- 5. Summary
-- ============================================

SELECT '============================================' as '';
SELECT 'Image Path Fix Complete!' as Status;
SELECT '============================================' as '';

SELECT 
    'Total Products' as Metric,
    COUNT(*) as Count
FROM products
UNION ALL
SELECT 
    'Products with Images',
    COUNT(*)
FROM products
WHERE image_url IS NOT NULL AND image_url != ''
UNION ALL
SELECT 
    'Products with Asset Images',
    COUNT(*)
FROM products
WHERE image_url LIKE 'assets/%'
UNION ALL
SELECT 
    'Products with Network Images',
    COUNT(*)
FROM products
WHERE image_url LIKE 'http://%' OR image_url LIKE 'https://%'
UNION ALL
SELECT 
    'Products with Upload Images',
    COUNT(*)
FROM products
WHERE image_url LIKE '/uploads/%'
UNION ALL
SELECT 
    'Products without Images',
    COUNT(*)
FROM products
WHERE image_url IS NULL OR image_url = '';

SELECT '============================================' as '';
SELECT 'Check the output above for any issues' as Note;
SELECT 'All asset paths should now start with "assets/" (no leading slash)' as Note;
