<?php
// Run this file to initialize database with admin user

require_once __DIR__ . '/config/database.php';

$database = new Database();
$db = $database->getConnection();

// Create admin user
$full_name = 'Ahnaf';
$last_name = 'Admin';
$email = 'ahnaf@electrocitybd.com';
$password = password_hash('1234@', PASSWORD_BCRYPT);
$role = 'admin';

// Check if admin exists
$check = $db->prepare("SELECT user_id FROM users WHERE email = ?");
$check->execute([$email]);

if ($check->rowCount() == 0) {
    $query = "INSERT INTO users (full_name, last_name, email, password, role) VALUES (?, ?, ?, ?, ?)";
    $stmt = $db->prepare($query);
    
    if ($stmt->execute([$full_name, $last_name, $email, $password, $role])) {
        $user_id = $db->lastInsertId();
        
        // Create profile
        $profile = "INSERT INTO user_profile (user_id, full_name, last_name) VALUES (?, ?, ?)";
        $profile_stmt = $db->prepare($profile);
        $profile_stmt->execute([$user_id, $full_name, $last_name]);
        
        echo "Admin user created successfully!\n";
        echo "Email: ahnaf@electrocitybd.com\n";
        echo "Password: 1234@\n";
    } else {
        echo "Failed to create admin user\n";
    }
} else {
    echo "Admin user already exists\n";
}

// Update sample products with discounts
$discounts = [
    [1, 10, '2024-01-01', '2024-12-31'], // LED Bulb 10% off
    [3, 5, '2024-01-01', '2024-12-31'],  // Copper Wire 5% off
    [4, 15, '2024-01-01', '2024-06-30'], // Screwdriver Set 15% off
];

foreach ($discounts as $d) {
    $check_discount = $db->prepare("SELECT discount_id FROM discounts WHERE product_id = ?");
    $check_discount->execute([$d[0]]);
    
    if ($check_discount->rowCount() == 0) {
        $insert = $db->prepare("INSERT INTO discounts (product_id, discount_percent, valid_from, valid_to) VALUES (?, ?, ?, ?)");
        $insert->execute($d);
    }
}

// Add to best sellers
$best_sellers = [
    [1, 150],
    [2, 200],
    [3, 75],
    [4, 120],
    [5, 45],
    [6, 90]
];

foreach ($best_sellers as $bs) {
    $insert_bs = $db->prepare("INSERT INTO best_sellers (product_id, sales_count) VALUES (?, ?) ON DUPLICATE KEY UPDATE sales_count = ?");
    $insert_bs->execute([$bs[0], $bs[1], $bs[1]]);
}

// Add to trending
$trending = [
    [1, 85],
    [2, 70],
    [3, 40],
    [4, 95],
    [5, 30],
    [6, 60]
];

foreach ($trending as $t) {
    $insert_t = $db->prepare("INSERT INTO trending_products (product_id, trending_score) VALUES (?, ?) ON DUPLICATE KEY UPDATE trending_score = ?");
    $insert_t->execute([$t[0], $t[1], $t[1]]);
}

// Create a flash sale
$flash_sale_check = $db->query("SELECT flash_sale_id FROM flash_sales LIMIT 1");
if ($flash_sale_check->rowCount() == 0) {
    $start = date('Y-m-d H:i:s');
    $end = date('Y-m-d H:i:s', strtotime('+7 days'));
    
    $fs = $db->prepare("INSERT INTO flash_sales (title, start_time, end_time, active) VALUES (?, ?, ?, 1)");
    $fs->execute(['Weekend Flash Sale', $start, $end]);
    $fs_id = $db->lastInsertId();
    
    // Add products to flash sale
    $fsp = $db->prepare("INSERT INTO flash_sale_products (flash_sale_id, product_id) VALUES (?, ?)");
    $fsp->execute([$fs_id, 1]);
    $fsp->execute([$fs_id, 4]);
    $fsp->execute([$fs_id, 5]);
}

echo "Database initialized successfully!\n";
?>