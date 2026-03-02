-- ============================================
-- Verify Brand Data in Database
-- ============================================
USE electrobd;

-- ============================================
-- 1. Check all brands in database
-- ============================================
SELECT 'All Brands in Database:' as Info;
SELECT brand_id, brand_name
FROM brands
ORDER BY brand_name;

-- ============================================
-- 2. Check products with brands
-- ============================================
SELECT 'Products with Brand Information:' as Info;
SELECT 
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name,
    p.price
FROM products p
LEFT JOIN brands b ON p.brand_id = b.brand_id
LEFT JOIN categories c ON p.category_id = c.category_id
ORDER BY p.product_id DESC
LIMIT 20;

-- ============================================
-- 3. Check Flash Sale products with brands
-- ============================================
SELECT 'Flash Sale Products with Brands:' as Info;
SELECT 
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name,
    fsp.flash_price,
    COALESCE(fsp.image_path, p.image_url) as image_url
FROM flash_sale_products fsp
JOIN products p ON fsp.product_id = p.product_id
LEFT JOIN brands b ON p.brand_id = b.brand_id
LEFT JOIN categories c ON p.category_id = c.category_id
JOIN flash_sales fs ON fsp.flash_sale_id = fs.flash_sale_id
WHERE fs.active = 1
ORDER BY fsp.created_at DESC
LIMIT 20;

-- ============================================
-- 4. Check Trending products with brands
-- ============================================
SELECT 'Trending Products with Brands:' as Info;
SELECT 
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name,
    tp.trending_score,
    COALESCE(tp.image_path, p.image_url) as image_url
FROM trending_products tp
JOIN products p ON tp.product_id = p.product_id
LEFT JOIN brands b ON p.brand_id = b.brand_id
LEFT JOIN categories c ON p.category_id = c.category_id
ORDER BY tp.created_at DESC
LIMIT 20;

-- ============================================
-- 5. Check products without brands
-- ============================================
SELECT 'Products WITHOUT Brand (NULL brand_id):' as Info;
SELECT 
    p.product_id,
    p.product_name,
    p.brand_id,
    c.category_name
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
WHERE p.brand_id IS NULL
LIMIT 10;

-- ============================================
-- 6. Brand distribution in Flash Sale
-- ============================================
SELECT 'Brand Distribution in Flash Sale:' as Info;
SELECT 
    b.brand_name,
    COUNT(*) as product_count
FROM flash_sale_products fsp
JOIN products p ON fsp.product_id = p.product_id
LEFT JOIN brands b ON p.brand_id = b.brand_id
JOIN flash_sales fs ON fsp.flash_sale_id = fs.flash_sale_id
WHERE fs.active = 1
GROUP BY b.brand_name
ORDER BY product_count DESC;

-- ============================================
-- 7. Brand distribution in Trending
-- ============================================
SELECT 'Brand Distribution in Trending:' as Info;
SELECT 
    b.brand_name,
    COUNT(*) as product_count
FROM trending_products tp
JOIN products p ON tp.product_id = p.product_id
LEFT JOIN brands b ON p.brand_id = b.brand_id
GROUP BY b.brand_name
ORDER BY product_count DESC;

-- ============================================
-- 8. Fix products with NULL brand_id
-- ============================================
SELECT 'Fixing products with NULL brand_id...' as Info;

-- Create a default "Unknown" brand if it doesn't exist
INSERT INTO brands (brand_name)
SELECT 'Unknown'
WHERE NOT EXISTS (SELECT 1 FROM brands WHERE brand_name = 'Unknown');

-- Update products with NULL brand_id to use "Unknown" brand
UPDATE products p
SET p.brand_id = (SELECT brand_id FROM brands WHERE brand_name = 'Unknown' LIMIT 1)
WHERE p.brand_id IS NULL;

SELECT 'Products with NULL brand_id have been updated to "Unknown"' as Status;

-- ============================================
-- 9. Summary
-- ============================================
SELECT '============================================' as '';
SELECT 'Brand Verification Complete!' as Status;
SELECT '============================================' as '';

SELECT 
    'Total Brands' as Metric,
    COUNT(*) as Count
FROM brands
UNION ALL
SELECT 
    'Products with Brands',
    COUNT(*)
FROM products
WHERE brand_id IS NOT NULL
UNION ALL
SELECT 
    'Products without Brands',
    COUNT(*)
FROM products
WHERE brand_id IS NULL
UNION ALL
SELECT 
    'Flash Sale Products',
    COUNT(*)
FROM flash_sale_products fsp
JOIN flash_sales fs ON fsp.flash_sale_id = fs.flash_sale_id
WHERE fs.active = 1
UNION ALL
SELECT 
    'Trending Products',
    COUNT(*)
FROM trending_products;

SELECT '============================================' as '';
SELECT 'All products should now have brand information' as Note;
