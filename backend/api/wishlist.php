<?php
require_once __DIR__ . '/bootstrap.php';
require_once __DIR__ . '/../middleware/authmiddleware.php';

$db = db();
$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';

if ($method === 'OPTIONS') {
    http_response_code(200);
    exit;
}

$userId = authenticate();

switch ($method) {
    case 'GET':
        // Get user's wishlist with product details
        $stmt = $db->prepare("
            SELECT w.*, p.*, w.added_at as wishlist_added_at
            FROM wishlists w
            INNER JOIN products p ON w.product_id = p.product_id
            WHERE w.user_id = ?
            ORDER BY w.added_at DESC
        ");
        $stmt->execute([$userId]);
        echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
        break;
        
    case 'POST':
        $data = json_decode(file_get_contents('php://input'), true);
        
        // Check if already in wishlist
        $stmt = $db->prepare("
            SELECT * FROM wishlists 
            WHERE user_id = ? AND product_id = ?
        ");
        $stmt->execute([$userId, $data['product_id']]);
        
        if ($stmt->fetch()) {
            echo json_encode(['message' => 'Product already in wishlist']);
            exit;
        }
        
        $stmt = $db->prepare("
            INSERT INTO wishlists (user_id, product_id)
            VALUES (?, ?)
        ");
        $stmt->execute([$userId, $data['product_id']]);
        echo json_encode(['message' => 'Added to wishlist', 'id' => $db->lastInsertId()]);
        break;
        
    case 'DELETE':
        if (isset($_GET['product_id'])) {
            $productId = (int)$_GET['product_id'];
            $stmt = $db->prepare("
                DELETE FROM wishlists 
                WHERE user_id = ? AND product_id = ?
            ");
            $stmt->execute([$userId, $productId]);
        } else {
            $id = (int)$_GET['id'];
            $stmt = $db->prepare("
                DELETE FROM wishlists 
                WHERE wishlist_id = ? AND user_id = ?
            ");
            $stmt->execute([$id, $userId]);
        }
        echo json_encode(['message' => 'Removed from wishlist']);
        break;
}
