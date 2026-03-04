DELETE FROM collection_products
WHERE collection_id BETWEEN 1 AND 15;

INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 1, p.product_id
FROM products p
WHERE p.product_name LIKE '%Essential%'
   OR p.product_name LIKE '%Basic%'
   OR p.product_name LIKE '%Home%'
LIMIT 20;

INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 2, p.product_id
FROM products p
WHERE p.product_name LIKE '%Fan%'
   OR p.product_name LIKE '%Charger Fan%'
   OR p.category_id IN (SELECT category_id FROM categories WHERE category_name LIKE '%Fan%');

INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 3, p.product_id
FROM products p
WHERE p.product_name LIKE '%Cooker%'
   OR p.product_name LIKE '%Rice Cooker%'
   OR p.product_name LIKE '%Curry%'
   OR p.product_name LIKE '%Pressure Cooker%';

INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 4, p.product_id
FROM products p
WHERE p.product_name LIKE '%Blender%'
   OR p.product_name LIKE '%Mixer%'
   OR p.product_name LIKE '%Juicer%';

INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 5, p.product_id
FROM products p
WHERE p.product_name LIKE '%Phone%'
   OR p.product_name LIKE '%Charger%'
   OR p.product_name LIKE '%Cable%'
   OR p.product_name LIKE '%Adapter%'
   OR p.product_name LIKE '%Power Bank%';

INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 6, p.product_id
FROM products p
WHERE p.product_name LIKE '%Massager%'
   OR p.product_name LIKE '%Massage%';

INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 7, p.product_id
FROM products p
WHERE p.product_name LIKE '%Trimmer%'
   OR p.product_name LIKE '%Shaver%'
   OR p.product_name LIKE '%Clipper%';

INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 8, p.product_id
FROM products p
WHERE p.product_name LIKE '%Chula%'
   OR p.product_name LIKE '%Stove%'
   OR p.product_name LIKE '%Electric Stove%'
   OR p.product_name LIKE '%Induction%';

INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 9, p.product_id
FROM products p
WHERE p.product_name LIKE '%Iron%'
   AND p.product_name NOT LIKE '%Air Fryer%';

INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 10, p.product_id
FROM products p
WHERE p.product_name LIKE '%Chopper%';

INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 11, p.product_id
FROM products p
WHERE p.product_name LIKE '%Grinder%';

INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 12, p.product_id
FROM products p
WHERE p.product_name LIKE '%Kettle%';

INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 13, p.product_id
FROM products p
WHERE p.product_name LIKE '%Hair%Dryer%'
   OR p.product_name LIKE '%Hair%Drier%'
   OR p.product_name LIKE '%Hair Dryer%';

INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 14, p.product_id
FROM products p
WHERE p.product_name LIKE '%Oven%'
   OR p.product_name LIKE '%Microwave%';

INSERT IGNORE INTO collection_products (collection_id, product_id)
SELECT 15, p.product_id
FROM products p
WHERE p.product_name LIKE '%Air%Fryer%'
   OR p.product_name LIKE '%Air Fryer%';

SELECT 
    c.collection_id,
    c.name,
    COUNT(cp.product_id) as actual_count
FROM collections c
LEFT JOIN collection_products cp ON c.collection_id = cp.collection_id
WHERE c.is_active = 1
GROUP BY c.collection_id, c.name
ORDER BY c.display_order;

SELECT 'Collections populated successfully!' as Status;
