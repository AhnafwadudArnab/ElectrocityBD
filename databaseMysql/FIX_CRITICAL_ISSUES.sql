-- ============================================================================
-- ElectroCityBD - Critical Database Fixes
-- ============================================================================

USE electrobd;

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
DELIMITER $$

DROP TRIGGER IF EXISTS after_review_insert$$
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
    
    -- Calculate statistics
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
    
    -- Update product_ratings
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
END$$

DROP TRIGGER IF EXISTS after_review_update$$
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
END$$

DROP TRIGGER IF EXISTS after_review_delete$$
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
END$$

DELIMITER ;

-- ---------------------------------------------------------------------------
-- 6. Fix stock management - Add transaction support
-- ---------------------------------------------------------------------------
-- Update stored procedure for atomic stock operations
DELIMITER $$

DROP PROCEDURE IF EXISTS sp_stock_in_atomic$$
CREATE PROCEDURE sp_stock_in_atomic(
    IN p_product_id INT,
    IN p_quantity INT,
    IN p_reason ENUM('PURCHASE', 'RETURN', 'ADJUSTMENT', 'INITIAL'),
    IN p_reference_id INT,
    IN p_notes TEXT,
    IN p_performed_by INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock IN operation failed';
    END;
    
    START TRANSACTION;
    
    -- Update product stock
    UPDATE products 
    SET stock_quantity = stock_quantity + p_quantity
    WHERE product_id = p_product_id;
    
    -- Record movement
    INSERT INTO stock_movements (
        product_id, movement_type, quantity, 
        quantity_before, quantity_after, reason, notes, performed_by
    )
    SELECT 
        p_product_id, 'IN', p_quantity,
        stock_quantity - p_quantity, stock_quantity,
        p_reason, p_notes, p_performed_by
    FROM products
    WHERE product_id = p_product_id;
    
    COMMIT;
END$$

DROP PROCEDURE IF EXISTS sp_stock_out_atomic$$
CREATE PROCEDURE sp_stock_out_atomic(
    IN p_product_id INT,
    IN p_quantity INT,
    IN p_reason ENUM('SALE', 'DAMAGE', 'ADJUSTMENT', 'RETURN'),
    IN p_reference_id INT,
    IN p_notes TEXT,
    IN p_performed_by INT
)
BEGIN
    DECLARE current_stock INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock OUT operation failed';
    END;
    
    START TRANSACTION;
    
    -- Get current stock with lock
    SELECT stock_quantity INTO current_stock
    FROM products
    WHERE product_id = p_product_id
    FOR UPDATE;
    
    -- Check if enough stock
    IF current_stock < p_quantity THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Insufficient stock';
    END IF;
    
    -- Update product stock
    UPDATE products 
    SET stock_quantity = stock_quantity - p_quantity
    WHERE product_id = p_product_id;
    
    -- Record movement
    INSERT INTO stock_movements (
        product_id, movement_type, quantity,
        quantity_before, quantity_after, reason, notes, performed_by
    )
    VALUES (
        p_product_id, 'OUT', p_quantity,
        current_stock, current_stock - p_quantity,
        p_reason, p_notes, p_performed_by
    );
    
    COMMIT;
END$$

DELIMITER ;

-- ---------------------------------------------------------------------------
-- 7. Create CSRF tokens table
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
-- 8. Create API rate limiting table
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

-- ---------------------------------------------------------------------------
-- Success message
-- ---------------------------------------------------------------------------
SELECT 'Critical database fixes applied successfully!' as message;
