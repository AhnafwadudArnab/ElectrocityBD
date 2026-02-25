<?php
header('Content-Type: application/json');
require_once __DIR__ . '/../bootstrap.php';
require_once __DIR__ . '/../../config/cors.php';
require_once __DIR__ . '/../../middleware/authmiddleware.php';

$method = $_SERVER['REQUEST_METHOD'];
if ($method !== 'GET') {
    http_response_code(405);
    echo json_encode(['message' => 'Method not allowed']);
    exit;
}

$user = AuthMiddleware::authenticateAdmin();
$db = db();

$revStmt = $db->query('SELECT COALESCE(SUM(total_amount), 0) AS totalRevenue FROM orders');
$rev = $revStmt->fetch();
$ordersStmt = $db->query('SELECT COUNT(*) AS totalOrders FROM orders');
$orders = $ordersStmt->fetch();
$custStmt = $db->query('SELECT COUNT(*) AS totalCustomers FROM users');
$cust = $custStmt->fetch();

echo json_encode([
    'totalRevenue' => (float)($rev['totalRevenue'] ?? 0),
    'totalOrders' => (int)($orders['totalOrders'] ?? 0),
    'totalCustomers' => (int)($cust['totalCustomers'] ?? 0),
]);
