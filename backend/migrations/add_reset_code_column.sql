-- Add reset_code column to password_reset_tokens table
-- Run this SQL to enable 6-digit code functionality

USE electrobd;

-- Check if column already exists
SET @col_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'electrobd' 
    AND TABLE_NAME = 'password_reset_tokens' 
    AND COLUMN_NAME = 'reset_code'
);

-- Add column if it doesn't exist
SET @sql = IF(@col_exists = 0,
    'ALTER TABLE password_reset_tokens ADD COLUMN reset_code VARCHAR(6) NULL AFTER token',
    'SELECT "Column reset_code already exists" AS message'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Add index if column was added
SET @idx_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.STATISTICS 
    WHERE TABLE_SCHEMA = 'electrobd' 
    AND TABLE_NAME = 'password_reset_tokens' 
    AND INDEX_NAME = 'idx_reset_code'
);

SET @sql = IF(@idx_exists = 0 AND @col_exists = 0,
    'ALTER TABLE password_reset_tokens ADD INDEX idx_reset_code (reset_code)',
    'SELECT "Index idx_reset_code already exists or column not added" AS message'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Verify the changes
SELECT 'Migration completed successfully!' AS status;
DESCRIBE password_reset_tokens;
