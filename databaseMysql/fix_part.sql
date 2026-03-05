-- ============================================================
-- ElectrocityBD - Database Fixes and Improvements
-- Combined from all fixing files
-- ============================================================

USE electrobd;

-- ============================================================================
-- PART 1: CRITICAL FIXES
-- ============================================================================

-- ---------------------------------------------------------------------------
-- 1. Add UNIQUE constraint on email
-- ---------------------------------------------------------------------------
SET @unique_email_exists := (
    SELECT COUNT(*)
    FROM information_schema.statistics
    WHERE table_schema = DATABASE()
      AND table_name = 'users'
      AND index_name = 'unique_email'
);

SET @sql_unique_email := IF(
    @unique_email_exists = 0,
    'ALTER TABLE users ADD UNIQUE KEY unique_email (email)',
    'SELECT ''unique_email already exists'' AS message'
);

PREPARE stmt_unique_email FROM @sql_unique_email;
EXECUTE stmt_unique_email;
DEALLOCATE PREPARE stmt_unique_email;

-- ---------------------------------------------------------------------------
-- 2. Create product_ratings table
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS product_ratings (
    rating_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    rating_avg DECIMAL(3,2) DEFAULT 0.00,
    review_count INT DEFAULT 0,
    rating_1_star INT DEFAULT 0,
    rating_2_star INT DEFAULT 0,
    rating_3_star INT DEFAULT 0,
    rating_4_star INT DEFAULT 0,
    rating_5_star INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    UNIQUE KEY unique_product_rating (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Initialize ratings for existing products
INSERT INTO product_ratings (product_id, rating_avg, review_count)
SELECT product_id, 4.5, 0
FROM products
WHERE product_id NOT IN (SELECT product_id FROM product_ratings)
ON DUPLICATE KEY UPDATE rating_id = rating_id;

-- ---------------------------------------------------------------------------
-- 3. Add missing indexes for performance
-- ---------------------------------------------------------------------------
ALTER TABLE products ADD INDEX IF NOT EXISTS idx_category_id (category_id);
ALTER TABLE products ADD INDEX IF NOT EXISTS idx_brand_id (brand_id);
ALTER TABLE products ADD INDEX IF NOT EXISTS idx_price (price);
ALTER TABLE products ADD INDEX IF NOT EXISTS idx_created_at (created_at);

ALTER TABLE orders ADD INDEX IF NOT EXISTS idx_user_id (user_id);
ALTER TABLE orders ADD INDEX IF NOT EXISTS idx_order_status (order_status);
ALTER TABLE orders ADD INDEX IF NOT EXISTS idx_order_date (order_date);

ALTER TABLE order_items ADD INDEX IF NOT EXISTS idx_order_id (order_id);
ALTER TABLE order_items ADD INDEX IF NOT EXISTS idx_product_id (product_id);

ALTER TABLE cart ADD INDEX IF NOT EXISTS idx_user_id (user_id);
ALTER TABLE cart ADD INDEX IF NOT EXISTS idx_product_id (product_id);

ALTER TABLE wishlists ADD INDEX IF NOT EXISTS idx_user_id (user_id);
ALTER TABLE wishlists ADD INDEX IF NOT EXISTS idx_product_id (product_id);

-- ---------------------------------------------------------------------------
-- 4. Create reviews table for product reviews
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS product_reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    review_title VARCHAR(255),
    is_verified_purchase BOOLEAN DEFAULT FALSE,
    helpful_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_product_id (product_id),
    INDEX idx_user_id (user_id),
    INDEX idx_rating (rating),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------
-- 5. Create trigger to update product_ratings when review is added
-- ---------------------------------------------------------------------------
DELIMITER $

DROP TRIGGER IF EXISTS after_review_insert$
CREATE TRIGGER after_review_insert
AFTER INSERT ON product_reviews
FOR EACH ROW
BEGIN
    DECLARE avg_rating DECIMAL(3,2);
    DECLARE total_reviews INT;
    DECLARE count_1 INT;
    DECLARE count_2 INT;
    DECLARE count_3 INT;
    DECLARE count_4 INT;
    DECLARE count_5 INT;
    
    SELECT 
        AVG(rating),
        COUNT(*),
        SUM(CASE WHEN rating = 1 THEN 1 ELSE 0 END),
        SUM(CASE WHEN rating = 2 THEN 1 ELSE 0 END),
        SUM(CASE WHEN rating = 3 THEN 1 ELSE 0 END),
        SUM(CASE WHEN rating = 4 THEN 1 ELSE 0 END),
        SUM(CASE WHEN rating = 5 THEN 1 ELSE 0 END)
    INTO avg_rating, total_reviews, count_1, count_2, count_3, count_4, count_5
    FROM product_reviews
    WHERE product_id = NEW.product_id;
    
    INSERT INTO product_ratings (
        product_id, rating_avg, review_count,
        rating_1_star, rating_2_star, rating_3_star, rating_4_star, rating_5_star
    ) VALUES (
        NEW.product_id, avg_rating, total_reviews,
        count_1, count_2, count_3, count_4, count_5
    )
    ON DUPLICATE KEY UPDATE
        rating_avg = avg_rating,
        review_count = total_reviews,
        rating_1_star = count_1,
        rating_2_star = count_2,
        rating_3_star = count_3,
        rating_4_star = count_4,
        rating_5_star = count_5;
END$

DROP TRIGGER IF EXISTS after_review_update$
CREATE TRIGGER after_review_update
AFTER UPDATE ON product_reviews
FOR EACH ROW
BEGIN
    DECLARE avg_rating DECIMAL(3,2);
    DECLARE total_reviews INT;
    DECLARE count_1 INT;
    DECLARE count_2 INT;
    DECLARE count_3 INT;
    DECLARE count_4 INT;
    DECLARE count_5 INT;
    
    SELECT 
        AVG(rating),
        COUNT(*),
        SUM(CASE WHEN rating = 1 THEN 1 ELSE 0 END),
        SUM(CASE WHEN rating = 2 THEN 1 ELSE 0 END),
        SUM(CASE WHEN rating = 3 THEN 1 ELSE 0 END),
        SUM(CASE WHEN rating = 4 THEN 1 ELSE 0 END),
        SUM(CASE WHEN rating = 5 THEN 1 ELSE 0 END)
    INTO avg_rating, total_reviews, count_1, count_2, count_3, count_4, count_5
    FROM product_reviews
    WHERE product_id = NEW.product_id;
    
    UPDATE product_ratings SET
        rating_avg = avg_rating,
        review_count = total_reviews,
        rating_1_star = count_1,
        rating_2_star = count_2,
        rating_3_star = count_3,
        rating_4_star = count_4,
        rating_5_star = count_5
    WHERE product_id = NEW.product_id;
END$

DROP TRIGGER IF EXISTS after_review_delete$
CREATE TRIGGER after_review_delete
AFTER DELETE ON product_reviews
FOR EACH ROW
BEGIN
    DECLARE avg_rating DECIMAL(3,2);
    DECLARE total_reviews INT;
    DECLARE count_1 INT;
    DECLARE count_2 INT;
    DECLARE count_3 INT;
    DECLARE count_4 INT;
    DECLARE count_5 INT;
    
    SELECT 
        COALESCE(AVG(rating), 0),
        COUNT(*),
        SUM(CASE WHEN rating = 1 THEN 1 ELSE 0 END),
        SUM(CASE WHEN rating = 2 THEN 1 ELSE 0 END),
        SUM(CASE WHEN rating = 3 THEN 1 ELSE 0 END),
        SUM(CASE WHEN rating = 4 THEN 1 ELSE 0 END),
        SUM(CASE WHEN rating = 5 THEN 1 ELSE 0 END)
    INTO avg_rating, total_reviews, count_1, count_2, count_3, count_4, count_5
    FROM product_reviews
    WHERE product_id = OLD.product_id;
    
    UPDATE product_ratings SET
        rating_avg = avg_rating,
        review_count = total_reviews,
        rating_1_star = COALESCE(count_1, 0),
        rating_2_star = COALESCE(count_2, 0),
        rating_3_star = COALESCE(count_3, 0),
        rating_4_star = COALESCE(count_4, 0),
        rating_5_star = COALESCE(count_5, 0)
    WHERE product_id = OLD.product_id;
END$

DELIMITER ;

-- ---------------------------------------------------------------------------
-- 6. Create CSRF tokens table
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS csrf_tokens (
    token_id INT AUTO_INCREMENT PRIMARY KEY,
    token VARCHAR(64) NOT NULL UNIQUE,
    user_id INT,
    session_id VARCHAR(128),
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_token (token),
    INDEX idx_expires (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------
-- 7. Create API rate limiting table
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS rate_limits (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ip_address VARCHAR(45) NOT NULL,
    endpoint VARCHAR(255) NOT NULL,
    request_count INT DEFAULT 1,
    window_start TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_ip_endpoint (ip_address, endpoint),
    INDEX idx_window (window_start)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================================
-- PART 2: ORDER ISSUE FIXES
-- ============================================================================

-- Add last_updated column to best_sellers if it doesn't exist
ALTER TABLE best_sellers 
ADD COLUMN IF NOT EXISTS last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- Add last_updated column to trending_products if it doesn't exist
ALTER TABLE trending_products 
ADD COLUMN IF NOT EXISTS last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- ============================================================================
-- PART 3: ADD CREATED_AT COLUMNS
-- ============================================================================

-- Add created_at to best_sellers if not exists
ALTER TABLE best_sellers 
ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Add created_at to trending_products if not exists
ALTER TABLE trending_products 
ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Add created_at to flash_sale_products if not exists
ALTER TABLE flash_sale_products 
ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Add created_at to flash_sales if not exists
ALTER TABLE flash_sales 
ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Add created_at to deals_of_the_day if not exists
ALTER TABLE deals_of_the_day 
ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Add created_at to tech_part_products if not exists
ALTER TABLE tech_part_products 
ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Add indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_best_sellers_created ON best_sellers(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_trending_created ON trending_products(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_flash_sale_products_created ON flash_sale_products(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_flash_sales_created ON flash_sales(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_deals_created ON deals_of_the_day(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tech_part_created ON tech_part_products(created_at DESC);

-- ============================================================================
-- PART 4: SEARCH IMPROVEMENTS
-- ============================================================================

-- Add FULLTEXT indexes for better search performance
ALTER TABLE products ADD FULLTEXT INDEX IF NOT EXISTS ft_product_search (product_name, description);
ALTER TABLE categories ADD FULLTEXT INDEX IF NOT EXISTS ft_category_name (category_name);
ALTER TABLE brands ADD FULLTEXT INDEX IF NOT EXISTS ft_brand_name (brand_name);

-- Create search suggestions table
CREATE TABLE IF NOT EXISTS search_suggestions (
    suggestion_id INT AUTO_INCREMENT PRIMARY KEY,
    suggestion_text VARCHAR(255) NOT NULL UNIQUE,
    suggestion_type ENUM('product', 'category', 'brand', 'keyword') DEFAULT 'keyword',
    search_count INT DEFAULT 0,
    last_searched TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_suggestion_text (suggestion_text),
    INDEX idx_search_count (search_count DESC),
    INDEX idx_type (suggestion_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Populate search suggestions from existing data
INSERT INTO search_suggestions (suggestion_text, suggestion_type, search_count)
SELECT DISTINCT product_name, 'product', 0
FROM products
WHERE product_name IS NOT NULL AND product_name != ''
ON DUPLICATE KEY UPDATE suggestion_type = 'product';

INSERT INTO search_suggestions (suggestion_text, suggestion_type, search_count)
SELECT DISTINCT category_name, 'category', 0
FROM categories
WHERE category_name IS NOT NULL AND category_name != ''
ON DUPLICATE KEY UPDATE suggestion_type = 'category';

INSERT INTO search_suggestions (suggestion_text, suggestion_type, search_count)
SELECT DISTINCT brand_name, 'brand', 0
FROM brands
WHERE brand_name IS NOT NULL AND brand_name != ''
ON DUPLICATE KEY UPDATE suggestion_type = 'brand';

-- Create triggers to auto-update search suggestions
DELIMITER $

DROP TRIGGER IF EXISTS after_product_insert_search$
CREATE TRIGGER after_product_insert_search
AFTER INSERT ON products
FOR EACH ROW
BEGIN
    INSERT INTO search_suggestions (suggestion_text, suggestion_type)
    VALUES (NEW.product_name, 'product')
    ON DUPLICATE KEY UPDATE 
        suggestion_type = 'product',
        is_active = TRUE;
END$

DROP TRIGGER IF EXISTS after_category_insert_search$
CREATE TRIGGER after_category_insert_search
AFTER INSERT ON categories
FOR EACH ROW
BEGIN
    INSERT INTO search_suggestions (suggestion_text, suggestion_type)
    VALUES (NEW.category_name, 'category')
    ON DUPLICATE KEY UPDATE 
        suggestion_type = 'category',
        is_active = TRUE;
END$

DROP TRIGGER IF EXISTS after_brand_insert_search$
CREATE TRIGGER after_brand_insert_search
AFTER INSERT ON brands
FOR EACH ROW
BEGIN
    INSERT INTO search_suggestions (suggestion_text, suggestion_type)
    VALUES (NEW.brand_name, 'brand')
    ON DUPLICATE KEY UPDATE 
        suggestion_type = 'brand',
        is_active = TRUE;
END$

DELIMITER ;

-- Create stored procedure for search with ranking
DELIMITER $

DROP PROCEDURE IF EXISTS sp_search_products$
CREATE PROCEDURE sp_search_products(
    IN p_query VARCHAR(255),
    IN p_limit INT,
    IN p_offset INT
)
BEGIN
    DECLARE search_pattern VARCHAR(257);
    SET search_pattern = CONCAT('%', p_query, '%');
    
    SELECT 
        p.*,
        c.category_name,
        b.brand_name,
        d.discount_percent,
        CASE 
            WHEN d.discount_percent IS NOT NULL 
            THEN p.price * (1 - d.discount_percent/100)
            ELSE p.price 
        END as discounted_price,
        (
            CASE WHEN p.product_name = p_query THEN 100 ELSE 0 END +
            CASE WHEN p.product_name LIKE CONCAT(p_query, '%') THEN 50 ELSE 0 END +
            CASE WHEN p.product_name LIKE search_pattern THEN 25 ELSE 0 END +
            CASE WHEN p.description LIKE search_pattern THEN 10 ELSE 0 END +
            CASE WHEN c.category_name LIKE search_pattern THEN 15 ELSE 0 END +
            CASE WHEN b.brand_name LIKE search_pattern THEN 15 ELSE 0 END
        ) as relevance_score
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.category_id
    LEFT JOIN brands b ON p.brand_id = b.brand_id
    LEFT JOIN discounts d ON p.product_id = d.product_id 
        AND CURDATE() BETWEEN d.valid_from AND d.valid_to
    WHERE 
        p.product_name LIKE search_pattern
        OR p.description LIKE search_pattern
        OR c.category_name LIKE search_pattern
        OR b.brand_name LIKE search_pattern
    HAVING relevance_score > 0
    ORDER BY relevance_score DESC, p.product_name ASC
    LIMIT p_limit OFFSET p_offset;
END$

DELIMITER ;

-- Create views for popular and trending searches
CREATE OR REPLACE VIEW v_popular_searches AS
SELECT 
    search_query,
    COUNT(*) as search_count,
    MAX(searched_at) as last_searched,
    COUNT(DISTINCT user_id) as unique_users
FROM search_history
WHERE searched_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY search_query
HAVING search_count > 1
ORDER BY search_count DESC, last_searched DESC;

CREATE OR REPLACE VIEW v_trending_searches AS
SELECT 
    search_query,
    COUNT(*) as search_count,
    MAX(searched_at) as last_searched
FROM search_history
WHERE searched_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
GROUP BY search_query
ORDER BY search_count DESC
LIMIT 20;

-- Add indexes for better search history performance
ALTER TABLE search_history 
    ADD INDEX IF NOT EXISTS idx_user_query (user_id, search_query),
    ADD INDEX IF NOT EXISTS idx_query_date (search_query, searched_at);

-- Create table for search analytics
CREATE TABLE IF NOT EXISTS search_analytics (
    analytics_id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL,
    search_query VARCHAR(255) NOT NULL,
    total_searches INT DEFAULT 0,
    unique_users INT DEFAULT 0,
    avg_results INT DEFAULT 0,
    zero_results_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_date_query (date, search_query),
    INDEX idx_date (date),
    INDEX idx_total_searches (total_searches DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- SUCCESS MESSAGE
-- ============================================================================

SELECT 'All database fixes and improvements applied successfully!' as Status;
SELECT 'Critical fixes, order issues, created_at columns, and search improvements completed' as Info;
