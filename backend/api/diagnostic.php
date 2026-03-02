<?php
header('Content-Type: application/json');
require_once __DIR__ . '/bootstrap.php';

$db = db();
$results = [];

// Check database connection
try {
    $db->query("SELECT 1");
    $results['database_connection'] = 'OK';
} catch (Exception $e) {
    $results['database_connection'] = 'FAILED: ' . $e->getMessage();
}

// Check if required tables exist
$requiredTables = [
    'products',
    'best_sellers',
    'trending_products',
    'flash_sale_products',
    'flash_sales',
    'deals_of_the_day',
    'tech_part_products',
    'orders',
    'categories',
    'brands'
];

$results['tables'] = [];
foreach ($requiredTables as $table) {
    try {
        $stmt = $db->query("SELECT COUNT(*) as count FROM $table");
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        $results['tables'][$table] = [
            'exists' => true,
            'count' => $row['count']
        ];
    } catch (Exception $e) {
        $results['tables'][$table] = [
            'exists' => false,
            'error' => $e->getMessage()
        ];
    }
}

// Check if created_at columns exist
$sectionTables = [
    'best_sellers',
    'trending_products',
    'flash_sale_products',
    'deals_of_the_day',
    'tech_part_products'
];

$results['created_at_columns'] = [];
foreach ($sectionTables as $table) {
    try {
        $stmt = $db->query("SHOW COLUMNS FROM $table LIKE 'created_at'");
        $column = $stmt->fetch(PDO::FETCH_ASSOC);
        $results['created_at_columns'][$table] = $column ? 'EXISTS' : 'MISSING';
    } catch (Exception $e) {
        $results['created_at_columns'][$table] = 'ERROR: ' . $e->getMessage();
    }
}

// Check if products exist in sections
$results['section_products'] = [];
foreach ($sectionTables as $table) {
    try {
        $stmt = $db->query("SELECT COUNT(*) as count FROM $table");
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        $results['section_products'][$table] = $row['count'];
    } catch (Exception $e) {
        $results['section_products'][$table] = 'ERROR';
    }
}

// Check latest products in each section
$results['latest_products'] = [];
try {
    // Flash Sale
    $stmt = $db->query("
        SELECT p.product_name, fsp.created_at 
        FROM flash_sale_products fsp
        JOIN products p ON fsp.product_id = p.product_id
        ORDER BY fsp.created_at DESC 
        LIMIT 1
    ");
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    $results['latest_products']['flash_sale'] = $row ?: 'No products';
    
    // Trending
    $stmt = $db->query("
        SELECT p.product_name, tp.created_at 
        FROM trending_products tp
        JOIN products p ON tp.product_id = p.product_id
        ORDER BY tp.created_at DESC 
        LIMIT 1
    ");
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    $results['latest_products']['trending'] = $row ?: 'No products';
    
    // Best Sellers
    $stmt = $db->query("
        SELECT p.product_name, bs.created_at 
        FROM best_sellers bs
        JOIN products p ON bs.product_id = p.product_id
        ORDER BY bs.created_at DESC 
        LIMIT 1
    ");
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    $results['latest_products']['best_sellers'] = $row ?: 'No products';
    
} catch (Exception $e) {
    $results['latest_products']['error'] = $e->getMessage();
}

// Check API endpoints
$results['api_endpoints'] = [
    'products' => file_exists(__DIR__ . '/products.php') ? 'EXISTS' : 'MISSING',
    'product_sections' => file_exists(__DIR__ . '/product_sections.php') ? 'EXISTS' : 'MISSING',
    'orders' => file_exists(__DIR__ . '/orders.php') ? 'EXISTS' : 'MISSING',
];

// Overall status
$allGood = true;
if ($results['database_connection'] !== 'OK') $allGood = false;
foreach ($results['created_at_columns'] as $status) {
    if ($status !== 'EXISTS') $allGood = false;
}
foreach ($results['api_endpoints'] as $status) {
    if ($status !== 'EXISTS') $allGood = false;
}

$results['overall_status'] = $allGood ? 'ALL SYSTEMS OK' : 'ISSUES DETECTED';
$results['timestamp'] = date('Y-m-d H:i:s');

echo json_encode($results, JSON_PRETTY_PRINT);
