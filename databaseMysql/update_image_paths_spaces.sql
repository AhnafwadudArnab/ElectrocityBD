-- Update database image paths to match renamed files
USE electrobd;

SELECT '============================================' as '';
SELECT 'Updating Image Paths (Removing Spaces)' as Status;
SELECT '============================================' as '';

-- Update: av sandwich maker.jpg -> av_sandwich_maker.jpg
UPDATE products 
SET image_url = 'assets/trends/av_sandwich_maker.jpg'
WHERE image_url = 'assets/trends/av sandwich maker.jpg';

-- Update: miyoko 25l oven.jpg -> miyoko_25l_oven.jpg
UPDATE products 
SET image_url = 'assets/trends/miyoko_25l_oven.jpg'
WHERE image_url = 'assets/trends/miyoko 25l oven.jpg';

-- Update: noha hot king.jpg -> noha_hot_king.jpg
UPDATE products 
SET image_url = 'assets/trends/noha_hot_king.jpg'
WHERE image_url = 'assets/trends/noha hot king.jpg';

-- Update: av sandwich maker.jpg -> av_sandwich_maker.jpg
UPDATE products 
SET image_url = 'assets/Deals of the Day/av_sandwich_maker.jpg'
WHERE image_url = 'assets/Deals of the Day/av sandwich maker.jpg';

-- Update: kennede charger fan.jpg -> kennede_charger_fan.jpg
UPDATE products 
SET image_url = 'assets/Deals of the Day/kennede_charger_fan.jpg'
WHERE image_url = 'assets/Deals of the Day/kennede charger fan.jpg';

-- Update: miyoko 25l oven.jpg -> miyoko_25l_oven.jpg
UPDATE products 
SET image_url = 'assets/Deals of the Day/miyoko_25l_oven.jpg'
WHERE image_url = 'assets/Deals of the Day/miyoko 25l oven.jpg';

-- Update: miyoko kettle.jpg -> miyoko_kettle.jpg
UPDATE products 
SET image_url = 'assets/Deals of the Day/miyoko_kettle.jpg'
WHERE image_url = 'assets/Deals of the Day/miyoko kettle.jpg';

-- Update: nima grinder.jpg -> nima_grinder.jpg
UPDATE products 
SET image_url = 'assets/Deals of the Day/nima_grinder.jpg'
WHERE image_url = 'assets/Deals of the Day/nima grinder.jpg';

-- Update: noha hot king.jpg -> noha_hot_king.jpg
UPDATE products 
SET image_url = 'assets/Deals of the Day/noha_hot_king.jpg'
WHERE image_url = 'assets/Deals of the Day/noha hot king.jpg';

-- Update: pinkPanther blender.jpg -> pinkPanther_blender.jpg
UPDATE products 
SET image_url = 'assets/Deals of the Day/pinkPanther_blender.jpg'
WHERE image_url = 'assets/Deals of the Day/pinkPanther blender.jpg';

-- Update: sokany dyer.jpg -> sokany_dyer.jpg
UPDATE products 
SET image_url = 'assets/Deals of the Day/sokany_dyer.jpg'
WHERE image_url = 'assets/Deals of the Day/sokany dyer.jpg';

-- Update: HK Defender 2914.jpg -> HK_Defender_2914.jpg
UPDATE products 
SET image_url = 'assets/Collections/Kennede & Defender Charger Fan/HK_Defender_2914.jpg'
WHERE image_url = 'assets/Collections/Kennede & Defender Charger Fan/HK Defender 2914.jpg';

-- Update: HK Defender 2916_1.jpg -> HK_Defender_2916_1.jpg
UPDATE products 
SET image_url = 'assets/Collections/Kennede & Defender Charger Fan/HK_Defender_2916_1.jpg'
WHERE image_url = 'assets/Collections/Kennede & Defender Charger Fan/HK Defender 2916_1.jpg';

-- Update: HK Defender 2916.jpg -> HK_Defender_2916.jpg
UPDATE products 
SET image_url = 'assets/Collections/Kennede & Defender Charger Fan/HK_Defender_2916.jpg'
WHERE image_url = 'assets/Collections/Kennede & Defender Charger Fan/HK Defender 2916.jpg';

SELECT '============================================' as '';
SELECT 'Image Paths Updated!' as Status;
SELECT '============================================' as '';

-- Verify updates
SELECT 'Updated paths:' as Info;
SELECT DISTINCT image_url 
FROM products 
WHERE image_url LIKE '%trends%' OR image_url LIKE '%Deals%'
ORDER BY image_url;
