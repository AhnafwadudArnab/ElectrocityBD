-- Common API Queries for ElectrocityBD

-- Get Featured Products
SELECT p.*, b.brand_name, c.category_name, 
       (SELECT image_url FROM product_images WHERE product_id = p.product_id AND is_primary = TRUE LIMIT 1) as primary_image
FROM products p
LEFT JOIN brands b ON p.brand_id = b.brand_id
LEFT JOIN categories c ON p.category_id = c.category_id
WHERE p.is_featured = TRUE AND p.is_active = TRUE
ORDER BY p.created_at DESC
LIMIT 10;

-- Get Trending Items
SELECT p.*, b.brand_name, c.category_name,
       (SELECT image_url FROM product_images WHERE product_id = p.product_id AND is_primary = TRUE LIMIT 1) as primary_image
FROM products p
LEFT JOIN brands b ON p.brand_id = b.brand_id
LEFT JOIN categories c ON p.category_id = c.category_id
WHERE p.is_trending = TRUE AND p.is_active = TRUE
ORDER BY p.view_count DESC
LIMIT 10;

-- Get Best Selling Products
SELECT p.*, b.brand_name, c.category_name,
       (SELECT image_url FROM product_images WHERE product_id = p.product_id AND is_primary = TRUE LIMIT 1) as primary_image,
       COUNT(oi.order_item_id) as total_sales
FROM products p
LEFT JOIN brands b ON p.brand_id = b.brand_id
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE p.is_active = TRUE
GROUP BY p.product_id
ORDER BY total_sales DESC
LIMIT 10;

-- Get Flash Sale Products
SELECT p.*, fs.sale_price, fs.start_time, fs.end_time,
       b.brand_name, c.category_name,
       (SELECT image_url FROM product_images WHERE product_id = p.product_id AND is_primary = TRUE LIMIT 1) as primary_image
FROM products p
INNER JOIN flash_sales fs ON p.product_id = fs.product_id
LEFT JOIN brands b ON p.brand_id = b.brand_id
LEFT JOIN categories c ON p.category_id = c.category_id
WHERE fs.is_active = TRUE 
  AND fs.start_time <= NOW() 
  AND fs.end_time >= NOW()
  AND p.is_active = TRUE
ORDER BY fs.end_time ASC;

-- Get Products by Category
SELECT p.*, b.brand_name,
       (SELECT image_url FROM product_images WHERE product_id = p.product_id AND is_primary = TRUE LIMIT 1) as primary_image
FROM products p
LEFT JOIN brands b ON p.brand_id = b.brand_id
WHERE p.category_id = ? AND p.is_active = TRUE
ORDER BY p.created_at DESC;

-- Get Product Details with Images and Specs
SELECT p.*, b.brand_name, c.category_name
FROM products p
LEFT JOIN brands b ON p.brand_id = b.brand_id
LEFT JOIN categories c ON p.category_id = c.category_id
WHERE p.product_id = ?;

-- Get Product Images
SELECT * FROM product_images WHERE product_id = ? ORDER BY display_order;

-- Get Product Specifications
SELECT * FROM product_specifications WHERE product_id = ?;

-- Get Product Reviews
SELECT r.*, u.username, u.full_name
FROM reviews r
INNER JOIN users u ON r.user_id = u.user_id
WHERE r.product_id = ?
ORDER BY r.created_at DESC;

-- Search Products
SELECT p.*, b.brand_name, c.category_name,
       (SELECT image_url FROM product_images WHERE product_id = p.product_id AND is_primary = TRUE LIMIT 1) as primary_image
FROM products p
LEFT JOIN brands b ON p.brand_id = b.brand_id
LEFT JOIN categories c ON p.category_id = c.category_id
WHERE (p.product_name LIKE ? OR p.description LIKE ?)
  AND p.is_active = TRUE
ORDER BY p.view_count DESC;