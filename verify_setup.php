<?php
/**
 * ElectrocityBD Setup Verification Script
 * Run this to verify database and backend configuration
 */

echo "╔════════════════════════════════════════════════════════════╗\n";
echo "║     ElectrocityBD - Setup Verification                     ║\n";
echo "╚════════════════════════════════════════════════════════════╝\n\n";

// Check 1: Database Connection
echo "1. Checking Database Connection...\n";
require_once __DIR__ . '/backend/config/db.php';
$database = new Database();
$db = $database->getConnection();

if ($db) {
    echo "   ✓ Database connected successfully\n\n";
} else {
    echo "   ✗ Database connection failed!\n";
    echo "   Please check your database credentials in backend/.env\n\n";
    exit(1);
}

// Check 2: Verify Tables
echo "2. Checking Database Tables...\n";
$required_tables = ['users', 'orders', 'order_items', 'products', 'cart', 'categories', 'brands'];
$missing_tables = [];

foreach ($required_tables as $table) {
    $stmt = $db->query("SHOW TABLES LIKE '$table'");
    if ($stmt->rowCount() > 0) {
        echo "   ✓ Table '$table' exists\n";
    } else {
        echo "   ✗ Table '$table' is missing\n";
        $missing_tables[] = $table;
    }
}

if (count($missing_tables) > 0) {
    echo "\n   ⚠ Missing tables detected. Run the database setup script:\n";
    echo "   mysql -u root -p electrobd < databaseMysql/COMPLETE_DATABASE_SETUP.sql\n\n";
} else {
    echo "   ✓ All required tables exist\n\n";
}

// Check 3: Admin User
echo "3. Checking Admin User...\n";
$stmt = $db->prepare("SELECT user_id, email, role FROM users WHERE email = ?");
$stmt->execute(['ahnaf@electrocitybd.com']);
$admin = $stmt->fetch();

if ($admin) {
    echo "   ✓ Admin user exists\n";
    echo "     Email: {$admin['email']}\n";
    echo "     Role: {$admin['role']}\n";
    echo "     Password: 1234@\n\n";
} else {
    echo "   ✗ Admin user not found\n";
    echo "   Run: php add_admin.php (if file exists)\n\n";
}

// Check 4: Orders
echo "4. Checking Orders...\n";
$stmt = $db->query("SELECT COUNT(*) as count FROM orders");
$result = $stmt->fetch();
$order_count = $result['count'];

echo "   Total orders in database: $order_count\n";

if ($order_count > 0) {
    $stmt = $db->query("SELECT o.order_id, o.user_id, u.email, o.total_amount, o.order_status, o.order_date 
                        FROM orders o 
                        JOIN users u ON o.user_id = u.user_id 
                        ORDER BY o.order_date DESC LIMIT 3");
    $recent_orders = $stmt->fetchAll();
    
    echo "\n   Recent orders:\n";
    foreach ($recent_orders as $order) {
        echo "   - Order #{$order['order_id']} by {$order['email']} - ৳{$order['total_amount']} ({$order['order_status']})\n";
    }
}
echo "\n";

// Check 5: Products
echo "5. Checking Products...\n";
$stmt = $db->query("SELECT COUNT(*) as count FROM products");
$result = $stmt->fetch();
$product_count = $result['count'];

echo "   Total products in database: $product_count\n";

if ($product_count == 0) {
    echo "   ⚠ No products found. You may need to import sample data.\n";
}
echo "\n";

// Check 6: Backend Configuration
echo "6. Checking Backend Configuration...\n";
$config = require __DIR__ . '/backend/config.php';

echo "   Database Name: {$config['db']['name']}\n";
echo "   Database Host: {$config['db']['host']}:{$config['db']['port']}\n";
echo "   Database User: {$config['db']['user']}\n";

if ($config['db']['name'] !== 'electrobd') {
    echo "   ⚠ Warning: Database name should be 'electrobd'\n";
}
echo "\n";

// Check 7: .env file
echo "7. Checking Environment File...\n";
$env_file = __DIR__ . '/backend/.env';
if (file_exists($env_file)) {
    echo "   ✓ .env file exists\n";
    $env_content = file_get_contents($env_file);
    if (strpos($env_content, 'DB_NAME=electrobd') !== false) {
        echo "   ✓ Database name is correctly set to 'electrobd'\n";
    } else {
        echo "   ⚠ Database name in .env may need to be updated to 'electrobd'\n";
    }
} else {
    echo "   ⚠ .env file not found\n";
    echo "   Copy .env.example to .env and configure it\n";
}
echo "\n";

// Summary
echo "╔════════════════════════════════════════════════════════════╗\n";
echo "║     Setup Verification Complete                            ║\n";
echo "╚════════════════════════════════════════════════════════════╝\n\n";

echo "Next Steps:\n";
echo "1. Start the backend server:\n";
echo "   php -S localhost:8000 -t backend/public backend/router.php\n\n";
echo "2. Start the Flutter app:\n";
echo "   flutter run -d chrome\n\n";
echo "3. Login with admin credentials:\n";
echo "   Email: ahnaf@electrocitybd.com\n";
echo "   Password: 1234@\n\n";

if ($order_count == 0) {
    echo "4. Place a test order to verify the system is working\n\n";
}

echo "For more information, see START_BACKEND.md\n\n";
?>
