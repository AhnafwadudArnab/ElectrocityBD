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
    case 'POST':
        // Add item to collection
        $data = json_decode(file_get_contents('php://input'), true);
        
        if (!isset($data['collection_id']) || !isset($data['product_id'])) {
            http_response_code(400);
            echo json_encode(['message' => 'Collection ID and Product ID required']);
            exit;
        }
        
        $collection_id = (int)$data['collection_id'];
        $product_id = (int)$data['product_id'];
        $display_order = $data['display_order'] ?? 0;
        
        // Check if already exists
        $stmt = $db->prepare("
            SELECT item_id FROM collection_items 
            WHERE collection_id = ? AND product_id = ?
        ");
        $stmt->execute([$collection_id, $product_id]);
        
        if ($stmt->rowCount() > 0) {
            http_response_code(400);
            echo json_encode(['message' => 'Product already in collection']);
            exit;
        }
        
        $stmt = $db->prepare("
            INSERT INTO collection_items (collection_id, product_id, display_order)
            VALUES (?, ?, ?)
        ");
        
        if ($stmt->execute([$collection_id, $product_id, $display_order])) {
            http_response_code(201);
            echo json_encode(['message' => 'Item added to collection']);
        } else {
            http_response_code(500);
            echo json_encode(['message' => 'Failed to add item']);
        }
        break;
        
    case 'PUT':
        // Update item display order
        if (!isset($_GET['id'])) {
            http_response_code(400);
            echo json_encode(['message' => 'Item ID required']);
            exit;
        }
        
        $item_id = (int)$_GET['id'];
        $data = json_decode(file_get_contents('php://input'), true);
        
        if (!isset($data['display_order'])) {
            http_response_code(400);
            echo json_encode(['message' => 'Display order required']);
            exit;
        }
        
        $stmt = $db->prepare("UPDATE collection_items SET display_order = ? WHERE item_id = ?");
        if ($stmt->execute([$data['display_order'], $item_id])) {
            echo json_encode(['message' => 'Item updated']);
        } else {
            http_response_code(500);
            echo json_encode(['message' => 'Failed to update item']);
        }
        break;
        
    case 'DELETE':
        // Remove item from collection
        if (!isset($_GET['id'])) {
            http_response_code(400);
            echo json_encode(['message' => 'Item ID required']);
            exit;
        }
        
        $item_id = (int)$_GET['id'];
        
        $stmt = $db->prepare("DELETE FROM collection_items WHERE item_id = ?");
        if ($stmt->execute([$item_id])) {
            echo json_encode(['message' => 'Item removed from collection']);
        } else {
            http_response_code(500);
            echo json_encode(['message' => 'Failed to remove item']);
        }
        break;
        
    default:
        http_response_code(405);
        echo json_encode(['message' => 'Method not allowed']);
}
