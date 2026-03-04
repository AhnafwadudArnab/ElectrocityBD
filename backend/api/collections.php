<?php
require_once __DIR__ . '/bootstrap.php';

$db = db();
$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';

if ($method === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Admin authentication required
$token = getBearerToken();
if (!$token) {
    http_response_code(401);
    echo json_encode(['message' => 'Unauthorized']);
    exit;
}

$decoded = JWT::verify($token);
if (!$decoded || $decoded['role'] !== 'admin') {
    http_response_code(403);
    echo json_encode(['message' => 'Admin access required']);
    exit;
}

switch ($method) {
    case 'GET':
        // Get all collections
        $stmt = $db->query("
            SELECT c.*, COUNT(ci.item_id) as item_count
            FROM collections c
            LEFT JOIN collection_items ci ON c.collection_id = ci.collection_id
            GROUP BY c.collection_id
            ORDER BY c.display_order ASC, c.created_at DESC
        ");
        $collections = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        // Get items for each collection
        foreach ($collections as &$collection) {
            $stmt = $db->prepare("
                SELECT ci.*, p.product_name, p.price, p.image_url
                FROM collection_items ci
                LEFT JOIN products p ON ci.product_id = p.product_id
                WHERE ci.collection_id = ?
                ORDER BY ci.display_order ASC
            ");
            $stmt->execute([$collection['collection_id']]);
            $collection['items'] = $stmt->fetchAll(PDO::FETCH_ASSOC);
        }
        
        echo json_encode(['collections' => $collections]);
        break;
        
    case 'POST':
        // Create new collection
        $data = json_decode(file_get_contents('php://input'), true);
        
        if (!isset($data['name'])) {
            http_response_code(400);
            echo json_encode(['message' => 'Collection name required']);
            exit;
        }
        
        $name = $data['name'];
        $description = $data['description'] ?? '';
        $display_order = $data['display_order'] ?? 0;
        
        $stmt = $db->prepare("
            INSERT INTO collections (collection_name, description, display_order)
            VALUES (?, ?, ?)
        ");
        
        if ($stmt->execute([$name, $description, $display_order])) {
            $collection_id = $db->lastInsertId();
            http_response_code(201);
            echo json_encode([
                'message' => 'Collection created',
                'collection_id' => $collection_id
            ]);
        } else {
            http_response_code(500);
            echo json_encode(['message' => 'Failed to create collection']);
        }
        break;
        
    case 'PUT':
        // Update collection
        if (!isset($_GET['id'])) {
            http_response_code(400);
            echo json_encode(['message' => 'Collection ID required']);
            exit;
        }
        
        $collection_id = (int)$_GET['id'];
        $data = json_decode(file_get_contents('php://input'), true);
        
        $updates = [];
        $params = [];
        
        if (isset($data['name'])) {
            $updates[] = "collection_name = ?";
            $params[] = $data['name'];
        }
        if (isset($data['description'])) {
            $updates[] = "description = ?";
            $params[] = $data['description'];
        }
        if (isset($data['display_order'])) {
            $updates[] = "display_order = ?";
            $params[] = (int)$data['display_order'];
        }
        
        if (empty($updates)) {
            http_response_code(400);
            echo json_encode(['message' => 'No fields to update']);
            exit;
        }
        
        $params[] = $collection_id;
        $sql = "UPDATE collections SET " . implode(', ', $updates) . " WHERE collection_id = ?";
        
        $stmt = $db->prepare($sql);
        if ($stmt->execute($params)) {
            echo json_encode(['message' => 'Collection updated']);
        } else {
            http_response_code(500);
            echo json_encode(['message' => 'Failed to update collection']);
        }
        break;
        
    case 'DELETE':
        // Delete collection
        if (!isset($_GET['id'])) {
            http_response_code(400);
            echo json_encode(['message' => 'Collection ID required']);
            exit;
        }
        
        $collection_id = (int)$_GET['id'];
        
        // Delete collection items first
        $stmt = $db->prepare("DELETE FROM collection_items WHERE collection_id = ?");
        $stmt->execute([$collection_id]);
        
        // Delete collection
        $stmt = $db->prepare("DELETE FROM collections WHERE collection_id = ?");
        if ($stmt->execute([$collection_id])) {
            echo json_encode(['message' => 'Collection deleted']);
        } else {
            http_response_code(500);
            echo json_encode(['message' => 'Failed to delete collection']);
        }
        break;
        
    default:
        http_response_code(405);
        echo json_encode(['message' => 'Method not allowed']);
}
