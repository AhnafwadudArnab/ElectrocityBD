<?php
require_once __DIR__ . '/bootstrap.php';

$db = db();
$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';

if ($method === 'OPTIONS') {
    http_response_code(200);
    exit;
}

switch ($method) {
    case 'GET':
        $limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 10;
        
        $stmt = $db->prepare("
            SELECT p.*, bs.sales_count, bs.selling_point, bs.sales_strategy
            FROM products p
            INNER JOIN best_sellers bs ON p.product_id = bs.product_id
            ORDER BY bs.sales_count DESC
            LIMIT ?
        ");
        $stmt->execute([$limit]);
        echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
        break;
        
    case 'POST':
        $data = json_decode(file_get_contents('php://input'), true);
        $stmt = $db->prepare("
            INSERT INTO best_sellers (product_id, sales_count, selling_point, sales_strategy)
            VALUES (?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE 
                sales_count = VALUES(sales_count),
                selling_point = VALUES(selling_point),
                sales_strategy = VALUES(sales_strategy)
        ");
        $stmt->execute([
            $data['product_id'],
            $data['sales_count'] ?? 0,
            $data['selling_point'] ?? '',
            $data['sales_strategy'] ?? ''
        ]);
        echo json_encode(['message' => 'Best seller added/updated']);
        break;
        
    case 'PUT':
        $productId = (int)$_GET['product_id'];
        $data = json_decode(file_get_contents('php://input'), true);
        $stmt = $db->prepare("
            UPDATE best_sellers 
            SET sales_count = ?, selling_point = ?, sales_strategy = ?
            WHERE product_id = ?
        ");
        $stmt->execute([
            $data['sales_count'] ?? 0,
            $data['selling_point'] ?? '',
            $data['sales_strategy'] ?? '',
            $productId
        ]);
        echo json_encode(['message' => 'Best seller updated']);
        break;
        
    case 'DELETE':
        $productId = (int)$_GET['product_id'];
        $stmt = $db->prepare("DELETE FROM best_sellers WHERE product_id = ?");
        $stmt->execute([$productId]);
        echo json_encode(['message' => 'Best seller removed']);
        break;
}
