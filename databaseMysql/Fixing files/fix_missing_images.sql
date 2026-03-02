-- ============================================
-- Fix Missing Images in Database
-- ============================================
USE electrobd;

-- ============================================
-- 1. Check for products with missing images
-- ============================================

SELECT 'Products with NULL or empty images:' as Info;
SELECT 
    product_id,
    product_name,
    category_id,
    image_url,
    stock_quantity
FROM products 
WHERE image_url IS NULL 
   OR image_url = '' 
   OR TRIM(image_url) = ''
ORDER BY product_id;

-- ============================================
-- 2. Count missing images by category
-- ============================================

SELECT 'Missing images by category:' as Info;
SELECT 
    c.category_name,
    COUNT(*) as missing_count
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
WHERE p.image_url IS NULL 
   OR p.image_url = '' 
   OR TRIM(p.image_url) = ''
GROUP BY c.category_name
ORDER BY missing_count DESC;

-- ============================================
-- 3. Fix missing images with placeholder
-- ============================================

-- Update products with missing images to use a placeholder
UPDATE products 
SET image_url = 'assets/images/placeholder.png'
WHERE image_url IS NULL 
   OR image_url = '' 
   OR TRIM(image_url) = '';

SELECT 'Updated products with placeholder images' as Status;

-- ============================================
-- 4. Check flash sale products with missing images
-- ============================================

SELECT 'Flash Sale products with missing images:' as Info;
SELECT 
    fsp.product_id,
    p.product_name,
    p.image_url as product_image,
    fsp.image_path as flash_image,
    COALESCE(fsp.image_path, p.image_url) as final_image
FROM flash_sale_products fsp
INNER JOIN products p ON fsp.product_id = p.product_id
WHERE (fsp.image_path IS NULL OR fsp.image_path = '' OR TRIM(fsp.image_path) = '')
  AND (p.image_url IS NULL OR p.image_url = '' OR TRIM(p.image_url) = '');

-- ============================================
-- 5. Check trending products with missing images
-- ============================================

SELECT 'Trending products with missing images:' as Info;
SELECT 
    tp.product_id,
    p.product_name,
    p.image_url as product_image,
    tp.image_path as trending_image,
    COALESCE(tp.image_path, p.image_url) as final_image
FROM trending_products tp
INNER JOIN products p ON tp.product_id = p.product_id
WHERE (tp.image_path IS NULL OR tp.image_path = '' OR TRIM(tp.image_path) = '')
  AND (p.image_url IS NULL OR p.image_url = '' OR TRIM(p.image_url) = '');

-- ============================================
-- 6. Verify all products now have images
-- ============================================

SELECT 'Verification - Products without images:' as Info;
SELECT COUNT(*) as count
FROM products 
WHERE image_url IS NULL 
   OR image_url = '' 
   OR TRIM(image_url) = '';

-- ============================================
-- 7. Sample products with images
-- ============================================

SELECT 'Sample products with images:' as Info;
SELECT 
    product_id,
    product_name,
    image_url,
    stock_quantity,
    price
FROM products 
WHERE image_url IS NOT NULL 
  AND image_url != '' 
  AND TRIM(image_url) != ''
LIMIT 10;

-- ============================================
-- 8. Recommendations
-- ============================================

SELECT '
IMAGE LOADING ISSUES - SOLUTIONS:
==================================

1. MISSING IMAGES IN DATABASE:
   ✓ Run this SQL to add placeholder images
   ✓ Upload actual product images
   ✓ Update image_url in products table

2. IMAGE PATH FORMAT:
   - Use: assets/images/product.jpg (for Flutter assets)
   - Use: /uploads/product.jpg (for backend uploads)
   - Use: https://domain.com/image.jpg (for external URLs)

3. FRONTEND OPTIMIZATION:
   ✓ Use OptimizedImageWidget (already implemented)
   ✓ Images will cache automatically
   ✓ Placeholder shows for missing images

4. PAGINATION ISSUE FIXED:
   ✓ Maximum 5 pages shown at once
   ✓ Ellipsis (...) for more pages
   ✓ Last page number always visible

5. NEXT STEPS:
   - Upload product images to assets/ or backend
   - Update database with correct image paths
   - Test image loading on all pages
   - Clear app cache and reload

EXAMPLE IMAGE PATHS:
--------------------
-- Flutter assets:
UPDATE products SET image_url = "assets/prod/fan1.jpg" WHERE product_id = 1;

-- Backend uploads:
UPDATE products SET image_url = "/uploads/products/fan1.jpg" WHERE product_id = 1;

-- External URL:
UPDATE products SET image_url = "https://example.com/images/fan1.jpg" WHERE product_id = 1;

' as Recommendations;
