-- ============================================================
-- Fix Order Placement Issue for Regular Users
-- This script adds missing columns to best_sellers and trending_products tables
-- ============================================================

USE electrobd;

-- Check and add last_updated column to best_sellers if it doesn't exist
ALTER TABLE best_sellers 
ADD COLUMN IF NOT EXISTS last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- Check and add last_updated column to trending_products if it doesn't exist
ALTER TABLE trending_products 
ADD COLUMN IF NOT EXISTS last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- Verify the changes
SELECT 'Fix applied successfully!' as Status;
SELECT 'Orders from regular users should now save to database' as Info;

-- Show table structures to confirm
DESCRIBE best_sellers;
DESCRIBE trending_products;
