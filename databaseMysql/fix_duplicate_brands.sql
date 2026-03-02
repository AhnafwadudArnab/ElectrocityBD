-- ============================================
-- Fix Duplicate Brands in Database
-- ============================================
USE electrobd;

-- ============================================
-- 1. Check for duplicate brands
-- ============================================
SELECT 'Checking for duplicate brands...' as Status;

SELECT 
    brand_name,
    COUNT(*) as count,
    GROUP_CONCAT(brand_id ORDER BY brand_id) as brand_ids
FROM brands
GROUP BY LOWER(brand_name)
HAVING COUNT(*) > 1;

-- ============================================
-- 2. Show all brands before cleanup
-- ============================================
SELECT 'All brands before cleanup:' as Info;
SELECT brand_id, brand_name, brand_logo
FROM brands
ORDER BY brand_name, brand_id;

-- ============================================
-- 3. Remove duplicate brands (keep lowest brand_id)
-- ============================================
SELECT 'Removing duplicate brands...' as Status;

-- Create temporary table with brands to keep (lowest brand_id for each name)
CREATE TEMPORARY TABLE brands_to_keep AS
SELECT MIN(brand_id) as brand_id, LOWER(brand_name) as brand_name_lower
FROM brands
GROUP BY LOWER(brand_name);

-- Update products to use the brand we're keeping
UPDATE products p
JOIN brands b ON p.brand_id = b.brand_id
JOIN brands_to_keep btk ON LOWER(b.brand_name) = btk.brand_name_lower
SET p.brand_id = btk.brand_id
WHERE p.brand_id != btk.brand_id;

-- Delete duplicate brands
DELETE b FROM brands b
LEFT JOIN brands_to_keep btk ON b.brand_id = btk.brand_id
WHERE btk.brand_id IS NULL;

DROP TEMPORARY TABLE brands_to_keep;

SELECT 'Duplicate brands removed!' as Status;

-- ============================================
-- 4. Show all brands after cleanup
-- ============================================
SELECT 'All brands after cleanup:' as Info;
SELECT brand_id, brand_name, brand_logo
FROM brands
ORDER BY brand_name;

-- ============================================
-- 5. Verify no duplicates remain
-- ============================================
SELECT 'Verifying no duplicates remain...' as Status;

SELECT 
    brand_name,
    COUNT(*) as count
FROM brands
GROUP BY LOWER(brand_name)
HAVING COUNT(*) > 1;

-- If no results, duplicates are removed
SELECT CASE 
    WHEN (SELECT COUNT(*) FROM (
        SELECT brand_name
        FROM brands
        GROUP BY LOWER(brand_name)
        HAVING COUNT(*) > 1
    ) as dups) = 0 
    THEN '✅ No duplicate brands found!'
    ELSE '⚠️ Duplicates still exist!'
END as Result;

-- ============================================
-- 6. Add unique constraint to prevent future duplicates
-- ============================================
SELECT 'Adding unique constraint...' as Status;

-- Drop existing index if it exists
DROP INDEX IF EXISTS idx_brand_name_unique ON brands;

-- Add unique constraint on lowercase brand_name
ALTER TABLE brands 
ADD UNIQUE INDEX idx_brand_name_unique (brand_name);

SELECT 'Unique constraint added!' as Status;

-- ============================================
-- 7. Summary
-- ============================================
SELECT '============================================' as '';
SELECT 'Duplicate Brands Fix Complete!' as Status;
SELECT '============================================' as '';

SELECT 
    'Total Unique Brands' as Metric,
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
WHERE brand_id IS NULL;

SELECT '============================================' as '';
SELECT 'All duplicate brands have been removed' as Note;
SELECT 'Unique constraint added to prevent future duplicates' as Note;
