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
            SELECT p.*, tp.trending_score
            FROM products p
            INNER JOIN trending_products tp ON p.product_id = tp.product_id
            ORDER BY tp.trending_score DESC
            LIMIT ?
        ");
        $stmt->execute([$limit]);
        echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
        break;
        
    case 'POST':
        $data = json_decode(file_get_contents('php://input'), true);
        $stmt = $db->prepare("
            INSERT INTO trending_products (product_id, trending_score)
            VALUES (?, ?)
            ON DUPLICATE KEY UPDATE trending_score = VALUES(trending_score)
        ");
        $stmt->execute([
            $data['product_id'],
            $data['trending_score'] ?? 0
        ]);
        echo json_encode(['message' => 'Trending product added/updated']);
        break;
        
    case 'PUT':
        $productId = (int)$_GET['product_id'];
        $data = json_decode(file_get_contents('php://input'), true);
        $stmt = $db->prepare("
            UPDATE trending_products 
            SET trending_score = ?
            WHERE product_id = ?
        ");
        $stmt->execute([
            $data['trending_score'] ?? 0,
            $productId
        ]);
        echo json_encode(['message' => 'Trending product updated']);
        break;
        
    case 'DELETE':
        $productId = (int)$_GET['product_id'];
        $stmt = $db->prepare("DELETE FROM trending_products WHERE product_id = ?");
        $stmt->execute([$productId]);
        echo json_encode(['message' => 'Trending product removed']);
        break;
}
