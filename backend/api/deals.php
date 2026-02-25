<?php
header('Content-Type: application/json');
require_once __DIR__ . '/bootstrap.php';
require_once __DIR__ . '/../config/cors.php';
require_once __DIR__ . '/../controllers/productController.php';

$db = db();
$product = new ProductController($db);
$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    echo json_encode($product->getDealsOfDay($_GET));
    exit;
}

http_response_code(405);
echo json_encode(['message' => 'Method not allowed']);
