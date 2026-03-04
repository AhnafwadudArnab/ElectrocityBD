-- ============================================================================
-- ElectroCityBD - Search System Improvements
-- ============================================================================

USE electrobd;

-- ---------------------------------------------------------------------------
-- 1. Add FULLTEXT indexes for better search performance
-- ---------------------------------------------------------------------------

-- Add FULLTEXT index on product name and description
ALTER TABLE products ADD FULLTEXT INDEX ft_product_search (product_name, description);

-- Add FULLTEXT index on category name
ALTER TABLE categories ADD FULLTEXT INDEX ft_category_name (category_name);

-- Add FULLTEXT index on brand name
ALTER TABLE brands ADD FULLTEXT INDEX ft_brand_name (brand_name);

-- ---------------------------------------------------------------------------
-- 2. Create search suggestions table for pre-computed suggestions
-- ---------------------------------------------------------------------------
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

-- ---------------------------------------------------------------------------
-- 3. Populate search suggestions from existing data
-- ---------------------------------------------------------------------------

-- Add product names as suggestions
INSERT INTO search_suggestions (suggestion_text, suggestion_type, search_count)
SELECT DISTINCT product_name, 'product', 0
FROM products
WHERE product_name IS NOT NULL AND product_name != ''
ON DUPLICATE KEY UPDATE suggestion_type = 'product';

-- Add category names as suggestions
INSERT INTO search_suggestions (suggestion_text, suggestion_type, search_count)
SELECT DISTINCT category_name, 'category', 0
FROM categories
WHERE category_name IS NOT NULL AND category_name != ''
ON DUPLICATE KEY UPDATE suggestion_type = 'category';

-- Add brand names as suggestions
INSERT INTO search_suggestions (suggestion_text, suggestion_type, search_count)
SELECT DISTINCT brand_name, 'brand', 0
FROM brands
WHERE brand_name IS NOT NULL AND brand_name != ''
ON DUPLICATE KEY UPDATE suggestion_type = 'brand';

-- ---------------------------------------------------------------------------
-- 4. Create trigger to auto-update search suggestions
-- ---------------------------------------------------------------------------
DELIMITER $$

DROP TRIGGER IF EXISTS after_product_insert_search$$
CREATE TRIGGER after_product_insert_search
AFTER INSERT ON products
FOR EACH ROW
BEGIN
    INSERT INTO search_suggestions (suggestion_text, suggestion_type)
    VALUES (NEW.product_name, 'product')
    ON DUPLICATE KEY UPDATE 
        suggestion_type = 'product',
        is_active = TRUE;
END$$

DROP TRIGGER IF EXISTS after_category_insert_search$$
CREATE TRIGGER after_category_insert_search
AFTER INSERT ON categories
FOR EACH ROW
BEGIN
    INSERT INTO search_suggestions (suggestion_text, suggestion_type)
    VALUES (NEW.category_name, 'category')
    ON DUPLICATE KEY UPDATE 
        suggestion_type = 'category',
        is_active = TRUE;
END$$

DROP TRIGGER IF EXISTS after_brand_insert_search$$
CREATE TRIGGER after_brand_insert_search
AFTER INSERT ON brands
FOR EACH ROW
BEGIN
    INSERT INTO search_suggestions (suggestion_text, suggestion_type)
    VALUES (NEW.brand_name, 'brand')
    ON DUPLICATE KEY UPDATE 
        suggestion_type = 'brand',
        is_active = TRUE;
END$$

DELIMITER ;

-- ---------------------------------------------------------------------------
-- 5. Create stored procedure for search with ranking
-- ---------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS sp_search_products$$
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
        -- Relevance scoring
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
END$$

DELIMITER ;

-- ---------------------------------------------------------------------------
-- 6. Create view for popular searches
-- ---------------------------------------------------------------------------
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

-- ---------------------------------------------------------------------------
-- 7. Create view for trending searches (last 7 days)
-- ---------------------------------------------------------------------------
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

-- ---------------------------------------------------------------------------
-- 8. Add indexes for better search history performance
-- ---------------------------------------------------------------------------
ALTER TABLE search_history 
    ADD INDEX idx_user_query (user_id, search_query),
    ADD INDEX idx_query_date (search_query, searched_at);

-- ---------------------------------------------------------------------------
-- 9. Create table for search analytics
-- ---------------------------------------------------------------------------
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

-- ---------------------------------------------------------------------------
-- 10. Create event to aggregate search analytics daily
-- ---------------------------------------------------------------------------
DELIMITER $$

DROP EVENT IF EXISTS daily_search_analytics$$
CREATE EVENT daily_search_analytics
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_DATE + INTERVAL 1 DAY
DO
BEGIN
    INSERT INTO search_analytics (date, search_query, total_searches, unique_users, avg_results, zero_results_count)
    SELECT 
        DATE(searched_at) as date,
        search_query,
        COUNT(*) as total_searches,
        COUNT(DISTINCT user_id) as unique_users,
        AVG(results_count) as avg_results,
        SUM(CASE WHEN results_count = 0 THEN 1 ELSE 0 END) as zero_results_count
    FROM search_history
    WHERE DATE(searched_at) = CURDATE() - INTERVAL 1 DAY
    GROUP BY DATE(searched_at), search_query
    ON DUPLICATE KEY UPDATE
        total_searches = VALUES(total_searches),
        unique_users = VALUES(unique_users),
        avg_results = VALUES(avg_results),
        zero_results_count = VALUES(zero_results_count);
END$$

DELIMITER ;

-- ---------------------------------------------------------------------------
-- 11. Clean up old search history (keep last 90 days)
-- ---------------------------------------------------------------------------
DELIMITER $$

DROP EVENT IF EXISTS cleanup_old_search_history$$
CREATE EVENT cleanup_old_search_history
ON SCHEDULE EVERY 1 WEEK
DO
BEGIN
    DELETE FROM search_history
    WHERE searched_at < DATE_SUB(NOW(), INTERVAL 90 DAY);
END$$

DELIMITER ;

-- ---------------------------------------------------------------------------
-- Success message
-- ---------------------------------------------------------------------------
SELECT 'Search system improvements applied successfully!' as message,
       (SELECT COUNT(*) FROM search_suggestions) as total_suggestions,
       (SELECT COUNT(*) FROM search_history) as total_searches;
