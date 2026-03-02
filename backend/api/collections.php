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
            // Get single collection with products
            $id = (int)$_GET['id'];
            $stmt = $db->prepare("
                SELECT c.*, 
                    (SELECT COUNT(*) FROM collection_products WHERE collection_id = c.collection_id) as product_count
                FROM collections c 
                WHERE c.collection_id = ? AND c.is_active = 1
            ");
            $stmt->execute([$id]);
            $collection = $stmt->fetch(PDO::FETCH_ASSOC);
            
            if (!$collection) {
                http_response_code(404);
                echo json_encode(['error' => 'Collection not found']);
                exit;
            }
            
            // Get collection items
            $stmt = $db->prepare("SELECT * FROM collection_items WHERE collection_id = ? ORDER BY display_order");
            $stmt->execute([$id]);
            $collection['items'] = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            // Get products in collection
            $stmt = $db->prepare("
                SELECT p.* FROM products p
                INNER JOIN collection_products cp ON p.product_id = cp.product_id
                WHERE cp.collection_id = ?
            ");
            $stmt->execute([$id]);
            $collection['products'] = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            echo json_encode($collection);
        } else {
            // Get all collections
            $stmt = $db->query("
                SELECT c.*, 
                    (SELECT COUNT(*) FROM collection_products WHERE collection_id = c.collection_id) as product_count
                FROM collections c 
                WHERE c.is_active = 1 
                ORDER BY c.display_order
            ");
            echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
        }
        break;
        
    case 'POST':
        $data = json_decode(file_get_contents('php://input'), true);
        $stmt = $db->prepare("
            INSERT INTO collections (name, slug, description, icon, image_url, is_active, display_order)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        ");
        $stmt->execute([
            $data['name'],
            $data['slug'] ?? strtolower(str_replace(' ', '-', $data['name'])),
            $data['description'] ?? '',
            $data['icon'] ?? '',
            $data['image_url'] ?? '',
            $data['is_active'] ?? 1,
            $data['display_order'] ?? 0
        ]);
        echo json_encode(['message' => 'Collection created', 'id' => $db->lastInsertId()]);
        break;
        
    case 'PUT':
        $id = (int)$_GET['id'];
        $data = json_decode(file_get_contents('php://input'), true);
        $stmt = $db->prepare("
            UPDATE collections 
            SET name = ?, slug = ?, description = ?, icon = ?, image_url = ?, is_active = ?, display_order = ?
            WHERE collection_id = ?
        ");
        $stmt->execute([
            $data['name'],
            $data['slug'],
            $data['description'] ?? '',
            $data['icon'] ?? '',
            $data['image_url'] ?? '',
            $data['is_active'] ?? 1,
            $data['display_order'] ?? 0,
            $id
        ]);
        echo json_encode(['message' => 'Collection updated']);
        break;
        
    case 'DELETE':
        $id = (int)$_GET['id'];
        $stmt = $db->prepare("DELETE FROM collections WHERE collection_id = ?");
        $stmt->execute([$id]);
        echo json_encode(['message' => 'Collection deleted']);
        break;
}
