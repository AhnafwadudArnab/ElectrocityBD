-- ============================================
-- Populate Collections with Products
-- This script automatically links products to collections based on product names
-- ============================================

-- Clear existing collection_products (optional - remove if you want to keep existing)
-- TRUNCATE TABLE collection_products;

-- ============================================
-- 1. HOME ESSENTIALS (collection_id = 1)
-- ============================================
INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 1, p.product_id
FROM products p
WHERE p.product_name LIKE '%Essential%'
   OR p.product_name LIKE '%Basic%'
   OR p.product_name LIKE '%Home%'
LIMIT 20;

-- ============================================
-- 2. FANS (collection_id = 2)
-- ============================================
INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 2, p.product_id
FROM products p
WHERE p.product_name LIKE '%Fan%'
   OR p.product_name LIKE '%Charger Fan%'
   OR p.category_id IN (SELECT category_id FROM categories WHERE category_name LIKE '%Fan%');

-- ============================================
-- 3. COOKERS (collection_id = 3)
-- ============================================
INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 3, p.product_id
FROM products p
WHERE p.product_name LIKE '%Cooker%'
   OR p.product_name LIKE '%Rice Cooker%'
   OR p.product_name LIKE '%Curry%'
   OR p.product_name LIKE '%Pressure Cooker%';

-- ============================================
-- 4. BLENDERS (collection_id = 4)
-- ============================================
INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 4, p.product_id
FROM products p
WHERE p.product_name LIKE '%Blender%'
   OR p.product_name LIKE '%Mixer%'
   OR p.product_name LIKE '%Juicer%';

-- ============================================
-- 5. PHONE RELATED (collection_id = 5)
-- ============================================
INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 5, p.product_id
FROM products p
WHERE p.product_name LIKE '%Phone%'
   OR p.product_name LIKE '%Charger%'
   OR p.product_name LIKE '%Cable%'
   OR p.product_name LIKE '%Adapter%'
   OR p.product_name LIKE '%Power Bank%';

-- ============================================
-- 6. MASSAGER ITEMS (collection_id = 6)
-- ============================================
INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 6, p.product_id
FROM products p
WHERE p.product_name LIKE '%Massager%'
   OR p.product_name LIKE '%Massage%';

-- ============================================
-- 7. TRIMMER (collection_id = 7)
-- ============================================
INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 7, p.product_id
FROM products p
WHERE p.product_name LIKE '%Trimmer%'
   OR p.product_name LIKE '%Shaver%'
   OR p.product_name LIKE '%Clipper%';

-- ============================================
-- 8. ELECTRIC CHULA (collection_id = 8)
-- ============================================
INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 8, p.product_id
FROM products p
WHERE p.product_name LIKE '%Chula%'
   OR p.product_name LIKE '%Stove%'
   OR p.product_name LIKE '%Electric Stove%'
   OR p.product_name LIKE '%Induction%';

-- ============================================
-- 9. IRON (collection_id = 9)
-- ============================================
INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 9, p.product_id
FROM products p
WHERE p.product_name LIKE '%Iron%'
   AND p.product_name NOT LIKE '%Air Fryer%';

-- ============================================
-- 10. CHOPPER (collection_id = 10)
-- ============================================
INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 10, p.product_id
FROM products p
WHERE p.product_name LIKE '%Chopper%';

-- ============================================
-- 11. GRINDER (collection_id = 11)
-- ============================================
INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 11, p.product_id
FROM products p
WHERE p.product_name LIKE '%Grinder%';

-- ============================================
-- 12. KETTLE (collection_id = 12)
-- ============================================
INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 12, p.product_id
FROM products p
WHERE p.product_name LIKE '%Kettle%';

-- ============================================
-- 13. HAIR DRYER (collection_id = 13)
-- ============================================
INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 13, p.product_id
FROM products p
WHERE p.product_name LIKE '%Hair%Dryer%'
   OR p.product_name LIKE '%Hair%Drier%'
   OR p.product_name LIKE '%Hair Dryer%';

-- ============================================
-- 14. OVEN (collection_id = 14)
-- ============================================
INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 14, p.product_id
FROM products p
WHERE p.product_name LIKE '%Oven%'
   OR p.product_name LIKE '%Microwave%';

-- ============================================
-- 15. AIR FRYER (collection_id = 15)
-- ============================================
INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 15, p.product_id
FROM products p
WHERE p.product_name LIKE '%Air%Fryer%'
   OR p.product_name LIKE '%Air Fryer%';

-- ============================================
-- Update product counts in collections table
-- ============================================
UPDATE collections c
SET product_count = (
    SELECT COUNT(*) 
    FROM collection_products cp
    WHERE cp.collection_id = c.collection_id
);

-- ============================================
-- Show results
-- ============================================
SELECT 
    c.collection_id,
    c.name,
    c.product_count,
    COUNT(cp.product_id) as actual_count
FROM collections c
LEFT JOIN collection_products cp ON c.collection_id = cp.collection_id
WHERE c.is_active = 1
GROUP BY c.collection_id, c.name, c.product_count
ORDER BY c.display_order;

SELECT 'Collections populated successfully!' as Status;
