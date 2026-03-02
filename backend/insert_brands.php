<?php
require_once __DIR__ . '/api/bootstrap.php';

$db = db();

// Brand logos mapping
$brands = [
    ['name' => 'Gree', 'logo' => 'assets/Brand Logo/Gree.png'],
    ['name' => 'LG', 'logo' => 'assets/Brand Logo/LG.png'],
    ['name' => 'Panasonic', 'logo' => 'assets/Brand Logo/panasonnic.png'],
    ['name' => 'Singer', 'logo' => 'assets/Brand Logo/singer.png'],
    ['name' => 'Vision', 'logo' => 'assets/Brand Logo/vision.jpg'],
    ['name' => 'Walton', 'logo' => 'assets/Brand Logo/walton.png'],
    ['name' => 'Jamuna', 'logo' => 'assets/Brand Logo/jamuna.jpg'],
    ['name' => 'Samsung', 'logo' => 'assets/Brand Logo/images.png'],
    ['name' => 'Sony', 'logo' => 'assets/Brand Logo/images (1).png'],
    ['name' => 'Philips', 'logo' => 'assets/Brand Logo/images (2).png'],
    ['name' => 'Sharp', 'logo' => 'assets/Brand Logo/images (3).png'],
    ['name' => 'Toshiba', 'logo' => 'assets/Brand Logo/images (4).png'],
    ['name' => 'Hitachi', 'logo' => 'assets/Brand Logo/images (5).png'],
    ['name' => 'Haier', 'logo' => 'assets/Brand Logo/images (6).png'],
    ['name' => 'Whirlpool', 'logo' => 'assets/Brand Logo/images (7).png'],
    ['name' => 'Electrolux', 'logo' => 'assets/Brand Logo/images.jpg'],
    ['name' => 'Bosch', 'logo' => 'assets/Brand Logo/images (1).jpg'],
    ['name' => 'Siemens', 'logo' => 'assets/Brand Logo/images (2).jpg'],
    ['name' => 'Midea', 'logo' => 'assets/Brand Logo/images (3).jpg'],
    ['name' => 'TCL', 'logo' => 'assets/Brand Logo/images (4).jpg'],
    ['name' => 'Hisense', 'logo' => 'assets/Brand Logo/images (5).jpg'],
    ['name' => 'Konka', 'logo' => 'assets/Brand Logo/images (6).jpg'],
    ['name' => 'Changhong', 'logo' => 'assets/Brand Logo/images (7).jpg'],
    ['name' => 'Skyworth', 'logo' => 'assets/Brand Logo/images (8).jpg'],
    ['name' => 'Videocon', 'logo' => 'assets/Brand Logo/images (9).jpg'],
    ['name' => 'Onida', 'logo' => 'assets/Brand Logo/images (10).jpg'],
    ['name' => 'BPL', 'logo' => 'assets/Brand Logo/images (11).jpg'],
];

try {
    // Check if brands already exist
    $stmt = $db->query("SELECT COUNT(*) as count FROM brands");
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if ($result['count'] > 0) {
        echo "Brands already exist in database. Updating logos...\n";
        
        // Update existing brands with logos
        foreach ($brands as $brand) {
            $stmt = $db->prepare("
                UPDATE brands 
                SET brand_logo = ? 
                WHERE brand_name = ?
            ");
            $stmt->execute([$brand['logo'], $brand['name']]);
            echo "Updated: {$brand['name']}\n";
        }
    } else {
        echo "Inserting new brands...\n";
        
        // Insert new brands
        $stmt = $db->prepare("
            INSERT INTO brands (brand_name, brand_logo)
            VALUES (?, ?)
        ");
        
        foreach ($brands as $brand) {
            $stmt->execute([$brand['name'], $brand['logo']]);
            echo "Inserted: {$brand['name']}\n";
        }
    }
    
    echo "\n✅ Successfully processed " . count($brands) . " brands!\n";
    
} catch (Exception $e) {
    echo "❌ Error: " . $e->getMessage() . "\n";
}
