-- Migration: Add created_at columns to section tables
-- Purpose: Enable sorting by newest products first

USE electrobd;

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

SELECT 'Migration completed: created_at columns added to all section tables' AS status;
