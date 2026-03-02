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
        if (isset($_GET['id'])) {
            $id = (int)$_GET['id'];
            $stmt = $db->prepare("
                SELECT b.*, 
                    (SELECT COUNT(*) FROM products WHERE brand_id = b.brand_id) as product_count
                FROM brands b 
                WHERE b.brand_id = ?
            ");
            $stmt->execute([$id]);
            $brand = $stmt->fetch(PDO::FETCH_ASSOC);
            
            if (!$brand) {
                http_response_code(404);
                echo json_encode(['error' => 'Brand not found']);
                exit;
            }
            
            echo json_encode($brand);
        } else {
            $stmt = $db->query("
                SELECT b.*, 
                    (SELECT COUNT(*) FROM products WHERE brand_id = b.brand_id) as product_count
                FROM brands b
                ORDER BY b.brand_name
            ");
            echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
        }
        break;
        
    case 'POST':
        $data = json_decode(file_get_contents('php://input'), true);
        $stmt = $db->prepare("
            INSERT INTO brands (brand_name, brand_logo)
            VALUES (?, ?)
        ");
        $stmt->execute([
            $data['brand_name'],
            $data['brand_logo'] ?? ''
        ]);
        echo json_encode(['message' => 'Brand created', 'id' => $db->lastInsertId()]);
        break;
        
    case 'PUT':
        $id = (int)$_GET['id'];
        $data = json_decode(file_get_contents('php://input'), true);
        $stmt = $db->prepare("
            UPDATE brands 
            SET brand_name = ?, brand_logo = ?
            WHERE brand_id = ?
        ");
        $stmt->execute([
            $data['brand_name'],
            $data['brand_logo'] ?? '',
            $id
        ]);
        echo json_encode(['message' => 'Brand updated']);
        break;
        
    case 'DELETE':
        $id = (int)$_GET['id'];
        $stmt = $db->prepare("DELETE FROM brands WHERE brand_id = ?");
        $stmt->execute([$id]);
        echo json_encode(['message' => 'Brand deleted']);
        break;
}
