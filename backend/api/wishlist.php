<?php
require_once __DIR__ . '/bootstrap.php';

$db = db();
$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';

if ($method === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Get user from token
$token = getBearerToken();
if (!$token) {
    http_response_code(401);
    echo json_encode(['message' => 'Unauthorized']);
    exit;
}

$decoded = JWT::verify($token);
if (!$decoded) {
    http_response_code(401);
    echo json_encode(['message' => 'Invalid token']);
    exit;
}

$user_id = $decoded['user_id'];

switch ($method) {
    case 'GET':
        // Get user's wishlist
        $stmt = $db->prepare("
            SELECT w.*, p.product_name, p.price, p.image_url, c.category_name
            FROM wishlist w
            LEFT JOIN products p ON w.product_id = p.product_id
            LEFT JOIN categories c ON p.category_id = c.category_id
            WHERE w.user_id = ?
            ORDER BY w.created_at DESC
        ");
        $stmt->execute([$user_id]);
        $items = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        echo json_encode(['items' => $items]);
        break;
        
    case 'POST':
        // Add to wishlist
        $data = json_decode(file_get_contents('php://input'), true);
        
        if (!isset($data['product_id'])) {
            http_response_code(400);
            echo json_encode(['message' => 'Product ID required']);
            exit;
        }
        
        $product_id = (int)$data['product_id'];
        
        // Check if already in wishlist
        $stmt = $db->prepare("SELECT wishlist_id FROM wishlist WHERE user_id = ? AND product_id = ?");
        $stmt->execute([$user_id, $product_id]);
        
        if ($stmt->rowCount() > 0) {
            echo json_encode(['message' => 'Already in wishlist']);
            exit;
        }
        
        // Add to wishlist
        $stmt = $db->prepare("INSERT INTO wishlist (user_id, product_id) VALUES (?, ?)");
        if ($stmt->execute([$user_id, $product_id])) {
            http_response_code(201);
            echo json_encode(['message' => 'Added to wishlist']);
        } else {
            http_response_code(500);
            echo json_encode(['message' => 'Failed to add to wishlist']);
        }
        break;
        
    case 'DELETE':
        // Remove from wishlist
        if (isset($_GET['product_id'])) {
            $product_id = (int)$_GET['product_id'];
            
            $stmt = $db->prepare("DELETE FROM wishlist WHERE user_id = ? AND product_id = ?");
            if ($stmt->execute([$user_id, $product_id])) {
                echo json_encode(['message' => 'Removed from wishlist']);
            } else {
                http_response_code(500);
                echo json_encode(['message' => 'Failed to remove from wishlist']);
            }
        } elseif (isset($_GET['clear']) && $_GET['clear'] === 'true') {
            // Clear entire wishlist
            $stmt = $db->prepare("DELETE FROM wishlist WHERE user_id = ?");
            if ($stmt->execute([$user_id])) {
                echo json_encode(['message' => 'Wishlist cleared']);
            } else {
                http_response_code(500);
                echo json_encode(['message' => 'Failed to clear wishlist']);
            }
        } else {
            http_response_code(400);
            echo json_encode(['message' => 'Product ID required']);
        }
        break;
        
    default:
        http_response_code(405);
        echo json_encode(['message' => 'Method not allowed']);
}
