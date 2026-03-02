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
    // First, let's see what's in the database
    $stmt = $db->query("SELECT brand_name FROM brands ORDER BY brand_name");
    $existing = $stmt->fetchAll(PDO::FETCH_COLUMN);
    
    echo "Current brands in database: " . count($existing) . "\n";
    if (count($existing) > 0) {
        echo "Existing brands: " . implode(', ', $existing) . "\n\n";
    }
    
    // Insert or update each brand
    $stmt = $db->prepare("
        INSERT INTO brands (brand_name, brand_logo)
        VALUES (?, ?)
        ON DUPLICATE KEY UPDATE brand_logo = VALUES(brand_logo)
    ");
    
    $inserted = 0;
    $updated = 0;
    
    foreach ($brands as $brand) {
        // Check if brand exists
        $check = $db->prepare("SELECT brand_id FROM brands WHERE brand_name = ?");
        $check->execute([$brand['name']]);
        $exists = $check->fetch();
        
        $stmt->execute([$brand['name'], $brand['logo']]);
        
        if ($exists) {
            $updated++;
            echo "Updated: {$brand['name']}\n";
        } else {
            $inserted++;
            echo "Inserted: {$brand['name']}\n";
        }
    }
    
    echo "\n✅ Successfully processed " . count($brands) . " brands!\n";
    echo "   Inserted: $inserted, Updated: $updated\n";
    
    // Show final count
    $stmt = $db->query("SELECT COUNT(*) as count FROM brands");
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    echo "   Total brands in database: {$result['count']}\n";
    
} catch (Exception $e) {
    echo "❌ Error: " . $e->getMessage() . "\n";
}
