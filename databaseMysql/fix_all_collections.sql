-- ============================================
-- Fix All Collections - Ensure Only Relevant Products
-- ============================================
USE electrobd;

SELECT '============================================' as '';
SELECT 'Fixing All Collections' as Status;
SELECT '============================================' as '';

-- ============================================
-- 1. FANS COLLECTION (Already Fixed)
-- ============================================
SELECT '1. Fans Collection - Already Fixed' as Status;

-- ============================================
-- 2. COOKERS COLLECTION
-- ============================================
SELECT '2. Fixing Cookers Collection...' as Status;

-- Remove non-cooker products
DELETE FROM collection_products 
WHERE collection_id = 2 
AND product_id IN (
    SELECT p.product_id 
    FROM products p
    WHERE p.product_name NOT LIKE '%Cooker%'
    AND p.product_name NOT LIKE '%Rice%'
    AND p.product_name NOT LIKE '%Curry%'
);

-- Add cooker products that are missing
INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 2, p.product_id
FROM products p
WHERE (p.product_name LIKE '%Cooker%' 
    OR p.product_name LIKE '%Rice Cooker%'
    OR p.product_name LIKE '%Curry%')
AND p.product_id NOT IN (SELECT product_id FROM collection_products WHERE collection_id = 2);

SELECT 'Cookers Collection Fixed' as Status;

-- ============================================
-- 3. BLENDERS COLLECTION
-- ============================================
SELECT '3. Fixing Blenders Collection...' as Status;

-- Remove non-blender products
DELETE FROM collection_products 
WHERE collection_id = 3 
AND product_id IN (
    SELECT p.product_id 
    FROM products p
    WHERE p.product_name NOT LIKE '%Blender%'
    AND p.product_name NOT LIKE '%Mixer%'
);

-- Add blender products that are missing
INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 3, p.product_id
FROM products p
WHERE (p.product_name LIKE '%Blender%' 
    OR p.product_name LIKE '%Mixer%')
AND p.product_id NOT IN (SELECT product_id FROM collection_products WHERE collection_id = 3);

SELECT 'Blenders Collection Fixed' as Status;

-- ============================================
-- 4. PHONE RELATED COLLECTION
-- ============================================
SELECT '4. Fixing Phone Related Collection...' as Status;

-- Remove non-phone products
DELETE FROM collection_products 
WHERE collection_id = 4 
AND product_id IN (
    SELECT p.product_id 
    FROM products p
    WHERE p.product_name NOT LIKE '%Phone%'
    AND p.product_name NOT LIKE '%Charger%'
    AND p.product_name NOT LIKE '%Cable%'
    AND p.product_name NOT LIKE '%Earphone%'
    AND p.product_name NOT LIKE '%Headphone%'
);

SELECT 'Phone Related Collection Fixed' as Status;

-- ============================================
-- 5. MASSAGER ITEMS COLLECTION
-- ============================================
SELECT '5. Fixing Massager Items Collection...' as Status;

-- Remove non-massager products
DELETE FROM collection_products 
WHERE collection_id = 5 
AND product_id IN (
    SELECT p.product_id 
    FROM products p
    WHERE p.product_name NOT LIKE '%Massager%'
    AND p.product_name NOT LIKE '%Massage%'
);

-- Add massager products that are missing
INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 5, p.product_id
FROM products p
WHERE (p.product_name LIKE '%Massager%' 
    OR p.product_name LIKE '%Massage%')
AND p.product_id NOT IN (SELECT product_id FROM collection_products WHERE collection_id = 5);

SELECT 'Massager Items Collection Fixed' as Status;

-- ============================================
-- 6. TRIMMER COLLECTION
-- ============================================
SELECT '6. Fixing Trimmer Collection...' as Status;

-- Remove non-trimmer products
DELETE FROM collection_products 
WHERE collection_id = 6 
AND product_id IN (
    SELECT p.product_id 
    FROM products p
    WHERE p.product_name NOT LIKE '%Trimmer%'
    AND p.product_name NOT LIKE '%Shaver%'
);

-- Add trimmer products that are missing
INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 6, p.product_id
FROM products p
WHERE (p.product_name LIKE '%Trimmer%' 
    OR p.product_name LIKE '%Shaver%')
AND p.product_id NOT IN (SELECT product_id FROM collection_products WHERE collection_id = 6);

SELECT 'Trimmer Collection Fixed' as Status;

-- ============================================
-- 7. ELECTRIC CHULA COLLECTION
-- ============================================
SELECT '7. Fixing Electric Chula Collection...' as Status;

-- Remove non-chula products
DELETE FROM collection_products 
WHERE collection_id = 7 
AND product_id IN (
    SELECT p.product_id 
    FROM products p
    WHERE p.product_name NOT LIKE '%Chula%'
    AND p.product_name NOT LIKE '%Stove%'
    AND p.product_name NOT LIKE '%Electric Stove%'
);

-- Add electric stove products that are missing
INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 7, p.product_id
FROM products p
WHERE (p.product_name LIKE '%Chula%' 
    OR p.product_name LIKE '%Stove%'
    OR p.product_name LIKE '%Electric Stove%')
AND p.product_id NOT IN (SELECT product_id FROM collection_products WHERE collection_id = 7);

SELECT 'Electric Chula Collection Fixed' as Status;

-- ============================================
-- 8. IRON COLLECTION
-- ============================================
SELECT '8. Fixing Iron Collection...' as Status;

-- Remove non-iron products
DELETE FROM collection_products 
WHERE collection_id = 8 
AND product_id IN (
    SELECT p.product_id 
    FROM products p
    WHERE p.product_name NOT LIKE '%Iron%'
);

-- Add iron products that are missing
INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 8, p.product_id
FROM products p
WHERE p.product_name LIKE '%Iron%'
AND p.product_id NOT IN (SELECT product_id FROM collection_products WHERE collection_id = 8);

SELECT 'Iron Collection Fixed' as Status;

-- ============================================
-- 9. CHOPPER COLLECTION
-- ============================================
SELECT '9. Fixing Chopper Collection...' as Status;

-- Remove non-chopper products
DELETE FROM collection_products 
WHERE collection_id = 9 
AND product_id IN (
    SELECT p.product_id 
    FROM products p
    WHERE p.product_name NOT LIKE '%Chopper%'
);

-- Add chopper products that are missing
INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 9, p.product_id
FROM products p
WHERE p.product_name LIKE '%Chopper%'
AND p.product_id NOT IN (SELECT product_id FROM collection_products WHERE collection_id = 9);

SELECT 'Chopper Collection Fixed' as Status;

-- ============================================
-- 10. GRINDER COLLECTION
-- ============================================
SELECT '10. Fixing Grinder Collection...' as Status;

-- Remove non-grinder products
DELETE FROM collection_products 
WHERE collection_id = 10 
AND product_id IN (
    SELECT p.product_id 
    FROM products p
    WHERE p.product_name NOT LIKE '%Grinder%'
);

-- Add grinder products that are missing
INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 10, p.product_id
FROM products p
WHERE p.product_name LIKE '%Grinder%'
AND p.product_id NOT IN (SELECT product_id FROM collection_products WHERE collection_id = 10);

SELECT 'Grinder Collection Fixed' as Status;

-- ============================================
-- 11. KETTLE COLLECTION
-- ============================================
SELECT '11. Fixing Kettle Collection...' as Status;

-- Remove non-kettle products
DELETE FROM collection_products 
WHERE collection_id = 11 
AND product_id IN (
    SELECT p.product_id 
    FROM products p
    WHERE p.product_name NOT LIKE '%Kettle%'
);

-- Add kettle products that are missing
INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 11, p.product_id
FROM products p
WHERE p.product_name LIKE '%Kettle%'
AND p.product_id NOT IN (SELECT product_id FROM collection_products WHERE collection_id = 11);

SELECT 'Kettle Collection Fixed' as Status;

-- ============================================
-- 12. HAIR DRYER COLLECTION
-- ============================================
SELECT '12. Fixing Hair Dryer Collection...' as Status;

-- Remove non-hair-dryer products
DELETE FROM collection_products 
WHERE collection_id = 12 
AND product_id IN (
    SELECT p.product_id 
    FROM products p
    WHERE p.product_name NOT LIKE '%Hair%Dryer%'
    AND p.product_name NOT LIKE '%Dryer%'
    AND p.product_name NOT LIKE '%Hair%Drier%'
);

-- Add hair dryer products that are missing
INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 12, p.product_id
FROM products p
WHERE (p.product_name LIKE '%Hair%Dryer%' 
    OR p.product_name LIKE '%Hair%Drier%')
AND p.product_id NOT IN (SELECT product_id FROM collection_products WHERE collection_id = 12);

SELECT 'Hair Dryer Collection Fixed' as Status;

-- ============================================
-- 13. OVEN COLLECTION
-- ============================================
SELECT '13. Fixing Oven Collection...' as Status;

-- Remove non-oven products
DELETE FROM collection_products 
WHERE collection_id = 13 
AND product_id IN (
    SELECT p.product_id 
    FROM products p
    WHERE p.product_name NOT LIKE '%Oven%'
    AND p.product_name NOT LIKE '%Microwave%'
);

-- Add oven products that are missing
INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 13, p.product_id
FROM products p
WHERE (p.product_name LIKE '%Oven%' 
    OR p.product_name LIKE '%Microwave%')
AND p.product_id NOT IN (SELECT product_id FROM collection_products WHERE collection_id = 13);

SELECT 'Oven Collection Fixed' as Status;

-- ============================================
-- 14. AIR FRYER COLLECTION
-- ============================================
SELECT '14. Fixing Air Fryer Collection...' as Status;

-- Remove non-air-fryer products
DELETE FROM collection_products 
WHERE collection_id = 14 
AND product_id IN (
    SELECT p.product_id 
    FROM products p
    WHERE p.product_name NOT LIKE '%Air%Fryer%'
    AND p.product_name NOT LIKE '%Fryer%'
);

-- Add air fryer products that are missing
INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 14, p.product_id
FROM products p
WHERE (p.product_name LIKE '%Air%Fryer%' 
    OR p.product_name LIKE '%Air Fryer%')
AND p.product_id NOT IN (SELECT product_id FROM collection_products WHERE collection_id = 14);

SELECT 'Air Fryer Collection Fixed' as Status;

-- ============================================
-- UPDATE ALL COLLECTION ITEM COUNTS
-- ============================================
SELECT 'Updating collection item counts...' as Status;

UPDATE collections c
SET item_count = (
    SELECT COUNT(*) 
    FROM collection_products cp
    WHERE cp.collection_id = c.collection_id
);

SELECT 'Item counts updated' as Status;

-- ============================================
-- SUMMARY
-- ============================================
SELECT '============================================' as '';
SELECT 'All Collections Fixed!' as Status;
SELECT '============================================' as '';

SELECT 
    c.collection_id,
    c.name,
    c.item_count as products
FROM collections c
ORDER BY c.collection_id;

SELECT '============================================' as '';
SELECT 'All collections now show only relevant products' as Note;
