-- Common API Queries for ElectrocityBD - FIXED VERSION

-- Get Featured Products
SELECT 
    p.product_id,
    p.product_name,
    p.price,
    p.discount_price,
    p.rating,
    b.brand_name,
    c.category_name,
    (SELECT image_url FROM product_images 
     WHERE product_id = p.product_id AND is_primary = TRUE LIMIT 1) as primary_image
FROM products p
LEFT JOIN brands b ON p.brand_id = b.brand_id
LEFT JOIN categories c ON p.category_id = c.category_id
WHERE p.is_featured = TRUE AND p.is_active = TRUE
ORDER BY p.created_at DESC
LIMIT 10;

-- Get Trending Items
SELECT 
    p.product_id,
    p.product_name,
    p.price,
    p.discount_price,
    p.rating,
    p.view_count,
    b.brand_name,
    c.category_name,
    (SELECT image_url FROM product_images 
     WHERE product_id = p.product_id AND is_primary = TRUE LIMIT 1) as primary_image
FROM products p
LEFT JOIN brands b ON p.brand_id = b.brand_id
LEFT JOIN categories c ON p.category_id = c.category_id
WHERE p.is_trending = TRUE AND p.is_active = TRUE
ORDER BY p.view_count DESC
LIMIT 10;

-- Get Best Selling Products
SELECT 
    p.product_id,
    p.product_name,
    p.price,
    p.discount_price,
    p.rating,
    b.brand_name,
    c.category_name,
    (SELECT image_url FROM product_images 
     WHERE product_id = p.product_id AND is_primary = TRUE LIMIT 1) as primary_image,
    COALESCE(COUNT(oi.order_item_id), 0) as total_sales
FROM products p
LEFT JOIN brands b ON p.brand_id = b.brand_id
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE p.is_active = TRUE
GROUP BY p.product_id, p.product_name, p.price, p.discount_price, p.rating, b.brand_name, c.category_name
ORDER BY total_sales DESC
LIMIT 10;

-- Get Flash Sale Products
SELECT 
    p.product_id,
    p.product_name,
    p.price,
    p.discount_price,
    fs.sale_price,
    fs.start_time,
    fs.end_time,
    b.brand_name,
    c.category_name,
    (SELECT image_url FROM product_images 
     WHERE product_id = p.product_id AND is_primary = TRUE LIMIT 1) as primary_image
FROM products p
INNER JOIN flash_sales fs ON p.product_id = fs.product_id
LEFT JOIN brands b ON p.brand_id = b.brand_id
LEFT JOIN categories c ON p.category_id = c.category_id
WHERE fs.is_active = TRUE 
  AND fs.start_time <= NOW() 
  AND fs.end_time >= NOW()
  AND p.is_active = TRUE
ORDER BY fs.end_time ASC;

-- Get Products by Category (with parameter)
SELECT 
    p.product_id,
    p.product_name,
    p.price,
    p.discount_price,
    p.rating,
    b.brand_name,
    (SELECT image_url FROM product_images 
     WHERE product_id = p.product_id AND is_primary = TRUE LIMIT 1) as primary_image
FROM products p
LEFT JOIN brands b ON p.brand_id = b.brand_id
WHERE p.category_id = :category_id
  AND p.is_active = TRUE
ORDER BY p.created_at DESC;

-- Get Product Details with Images and Specs
SELECT 
    p.product_id,
    p.product_name,
    p.description,
    p.price,
    p.discount_price,
    p.stock_quantity,
    p.sku,
    p.rating,
    p.view_count,
    b.brand_name,
    c.category_name
FROM products p
LEFT JOIN brands b ON p.brand_id = b.brand_id
LEFT JOIN categories c ON p.category_id = c.category_id
WHERE p.product_id = :product_id
  AND p.is_active = TRUE;

-- Get Product Images
SELECT 
    image_id,
    image_url,
    is_primary,
    display_order
FROM product_images
WHERE product_id = :product_id
ORDER BY display_order ASC;

-- Get Product Specifications
SELECT 
    spec_id,
    spec_key,
    spec_value
FROM product_specifications
WHERE product_id = :product_id;

-- Get Product Reviews
SELECT 
    r.review_id,
    r.rating,
    r.review_text,
    r.is_verified_purchase,
    r.created_at,
    u.user_id,
    u.username,
    u.full_name
FROM reviews r
INNER JOIN users u ON r.user_id = u.user_id
WHERE r.product_id = :product_id
ORDER BY r.created_at DESC;

-- Search Products
SELECT 
    p.product_id,
    p.product_name,
    p.description,
    p.price,
    p.discount_price,
    p.rating,
    b.brand_name,
    c.category_name,
    (SELECT image_url FROM product_images 
     WHERE product_id = p.product_id AND is_primary = TRUE LIMIT 1) as primary_image
FROM products p
LEFT JOIN brands b ON p.brand_id = b.brand_id
LEFT JOIN categories c ON p.category_id = c.category_id
WHERE (p.product_name LIKE CONCAT('%', :search_term, '%')
    OR p.description LIKE CONCAT('%', :search_term, '%'))
  AND p.is_active = TRUE
ORDER BY p.view_count DESC;

-- Get User Cart
SELECT 
    c.cart_id,
    c.product_id,
    c.quantity,
    p.product_name,
    p.price,
    p.discount_price,
    (SELECT image_url FROM product_images 
     WHERE product_id = p.product_id AND is_primary = TRUE LIMIT 1) as primary_image
FROM cart c
INNER JOIN products p ON c.product_id = p.product_id
WHERE c.user_id = :user_id
ORDER BY c.added_at DESC;

-- Get User Orders
SELECT 
    o.order_id,
    o.order_number,
    o.total_amount,
    o.final_amount,
    o.order_status,
    o.payment_status,
    o.created_at
FROM orders o
WHERE o.user_id = :user_id
ORDER BY o.created_at DESC;

-- Get Order Details
SELECT 
    oi.order_item_id,
    oi.product_id,
    oi.quantity,
    oi.unit_price,
    oi.total_price,
    p.product_name
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.product_id
WHERE oi.order_id = :order_id;