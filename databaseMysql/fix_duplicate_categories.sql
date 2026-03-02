-- ============================================
-- Fix Duplicate Categories
-- ============================================
USE electrobd;

SELECT '============================================' as '';
SELECT 'Fixing Duplicate Categories' as Status;
SELECT '============================================' as '';

-- Show duplicates
SELECT 'Duplicate categories:' as Info;
SELECT category_name, COUNT(*) as count, GROUP_CONCAT(category_id) as ids
FROM categories
GROUP BY category_name
HAVING COUNT(*) > 1
ORDER BY category_name;

-- Show all categories with product counts
SELECT 'All categories with product counts:' as Info;
SELECT c.category_id, c.category_name, 
       COUNT(p.product_id) as product_count
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_id, c.category_name
ORDER BY c.category_name, c.category_id;

-- ============================================
-- Strategy: Keep category with products, delete empty duplicates
-- ============================================

-- For each duplicate, keep the one with products and delete the empty one

-- 1. Home Comfort & Utility: Keep 3 (18 products), Delete 9 (0 products)
SELECT 'Deleting duplicate: Home Comfort & Utility (ID 9)' as Status;
DELETE FROM categories WHERE category_id = 9;

-- 2. Kitchen Appliances: Keep 1 (34 products), Delete 7 (0 products)
SELECT 'Deleting duplicate: Kitchen Appliances (ID 7)' as Status;
DELETE FROM categories WHERE category_id = 7;

-- 3. Lighting: Keep 4 (9 products), Delete 10 (0 products)
SELECT 'Deleting duplicate: Lighting (ID 10)' as Status;
DELETE FROM categories WHERE category_id = 10;

-- 4. Personal Care & Lifestyle: Keep 2 (3 products), Delete 8 (0 products)
SELECT 'Deleting duplicate: Personal Care & Lifestyle (ID 8)' as Status;
DELETE FROM categories WHERE category_id = 8;

-- 5. Tools: Keep 6 (2 products), Delete 12 (0 products)
SELECT 'Deleting duplicate: Tools (ID 12)' as Status;
DELETE FROM categories WHERE category_id = 12;

-- 6. Wiring: Keep 5 (1 product), Delete 11 (0 products)
SELECT 'Deleting duplicate: Wiring (ID 11)' as Status;
DELETE FROM categories WHERE category_id = 11;

-- ============================================
-- Add unique constraint to prevent future duplicates
-- ============================================
SELECT 'Adding unique constraint...' as Status;

-- Drop existing index if it exists
DROP INDEX IF EXISTS idx_category_name_unique ON categories;

-- Add unique constraint
ALTER TABLE categories 
ADD UNIQUE INDEX idx_category_name_unique (category_name);

SELECT 'Unique constraint added!' as Status;

-- ============================================
-- Verify no duplicates remain
-- ============================================
SELECT 'Verifying no duplicates remain...' as Status;

SELECT category_name, COUNT(*) as count
FROM categories
GROUP BY category_name
HAVING COUNT(*) > 1;

-- If no results, duplicates are removed
SELECT CASE 
    WHEN (SELECT COUNT(*) FROM (
        SELECT category_name
        FROM categories
        GROUP BY category_name
        HAVING COUNT(*) > 1
    ) as dups) = 0 
    THEN '✅ No duplicate categories found!'
    ELSE '⚠️ Duplicates still exist!'
END as Result;

-- ============================================
-- Show final categories
-- ============================================
SELECT '============================================' as '';
SELECT 'Final Categories List' as Status;
SELECT '============================================' as '';

SELECT c.category_id, c.category_name, 
       COUNT(p.product_id) as product_count
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_id, c.category_name
ORDER BY c.category_name;

SELECT '============================================' as '';
SELECT 'Duplicate Categories Removed!' as Status;
SELECT '============================================' as '';
