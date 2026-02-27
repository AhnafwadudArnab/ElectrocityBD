-- Collections Table Schema
-- This table stores collection categories (Fans, Cookers, Blenders, etc.)

CREATE TABLE IF NOT EXISTS collections (
    collection_id INT AUTO_INCREMENT PRIMARY KEY,
    collection_name VARCHAR(100) NOT NULL,
    collection_slug VARCHAR(100) NOT NULL UNIQUE,
    icon_name VARCHAR(50),
    display_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_slug (collection_slug),
    INDEX idx_active (is_active)
);

-- Collection Items Table
-- This table stores sub-categories within each collection
CREATE TABLE IF NOT EXISTS collection_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    collection_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    item_slug VARCHAR(100) NOT NULL,
    display_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (collection_id) REFERENCES collections(collection_id) ON DELETE CASCADE,
    INDEX idx_collection (collection_id),
    INDEX idx_active (is_active)
);

-- Insert default collections
INSERT INTO collections (collection_name, collection_slug, icon_name, display_order, is_active) VALUES
('Fans', 'fans', 'air', 1, TRUE),
('Cookers', 'cookers', 'kitchen', 2, TRUE),
('Blenders', 'blenders', 'blender', 3, TRUE),
('Phone Related', 'phone-related', 'phone', 4, TRUE),
('Massager Items', 'massager-items', 'spa', 5, TRUE),
('Trimmer', 'trimmer', 'content_cut', 6, TRUE),
('Electric Chula', 'electric-chula', 'electric_bolt', 7, TRUE),
('Iron', 'iron', 'iron', 8, TRUE),
('Chopper', 'chopper', 'restaurant', 9, TRUE),
('Grinder', 'grinder', 'settings', 10, TRUE),
('Kettle', 'kettle', 'coffee_maker', 11, TRUE),
('Hair Dryer', 'hair-dryer', 'air', 12, TRUE),
('Oven', 'oven', 'microwave', 13, TRUE),
('Air Fryer', 'air-fryer', 'kitchen', 14, TRUE);

-- Insert collection items (sub-categories)
INSERT INTO collection_items (collection_id, item_name, item_slug, display_order) VALUES
-- Fans collection items
(1, 'Charger Fan', 'charger-fan', 1),
(1, 'Mini Hand Fan', 'mini-hand-fan', 2),

-- Cookers collection items
(2, 'Rice Cooker', 'rice-cooker', 1),
(2, 'Mini Cooker', 'mini-cooker', 2),
(2, 'Curry Cooker', 'curry-cooker', 3),

-- Blenders collection items
(3, 'Hand Blender', 'hand-blender', 1),
(3, 'Blender', 'blender', 2),

-- Phone Related collection items
(4, 'Telephone Set', 'telephone-set', 1),
(4, 'Sim Telephone', 'sim-telephone', 2),

-- Massager Items collection items
(5, 'Massage Gun', 'massage-gun', 1),
(5, 'Head Massage', 'head-massage', 2),

-- Single item collections
(6, 'Trimmer', 'trimmer', 1),
(7, 'Electric Chula', 'electric-chula', 1),
(8, 'Iron', 'iron', 1),
(9, 'Chopper', 'chopper', 1),
(10, 'Grinder', 'grinder', 1),
(11, 'Kettle', 'kettle', 1),
(12, 'Hair Dryer', 'hair-dryer', 1),
(13, 'Oven', 'oven', 1),
(14, 'Air Fryer', 'air-fryer', 1);

-- Query to get all collections with item count
-- SELECT 
--     c.collection_id,
--     c.collection_name,
--     c.collection_slug,
--     c.icon_name,
--     c.is_active,
--     COUNT(ci.item_id) as item_count
-- FROM collections c
-- LEFT JOIN collection_items ci ON c.collection_id = ci.collection_id
-- WHERE c.is_active = TRUE
-- GROUP BY c.collection_id
-- ORDER BY c.display_order;

-- Query to get items for a specific collection
-- SELECT 
--     ci.item_id,
--     ci.item_name,
--     ci.item_slug
-- FROM collection_items ci
-- WHERE ci.collection_id = ? AND ci.is_active = TRUE
-- ORDER BY ci.display_order;
