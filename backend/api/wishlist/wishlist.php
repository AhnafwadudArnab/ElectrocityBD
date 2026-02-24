<?php
// /api/wishlist

function imageFullUrl($imageUrl) {
    if (!$imageUrl || !is_string($imageUrl)) return $imageUrl ?? '';
    if (strpos($imageUrl, 'asset:') === 0) return $imageUrl;
    if (strpos($imageUrl, 'http://') === 0 || strpos($imageUrl, 'https://') === 0) return $imageUrl;
    
    $protocol = isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http";
    $host = $_SERVER['HTTP_HOST'] ?? 'localhost:3000';
    $base = "$protocol://$host";
    
    return strpos($imageUrl, '/') === 0 ? $base . $imageUrl : $base . '/' . $imageUrl;
}

$token = getBearerToken();

if (!$token) {
    http_response_code(401);
    echo json_encode(['error' => 'No token provided.']);
    exit;
}

$payload = JWTHelper::verify($token);
if (!$payload) {
    http_response_code(401);
    echo json_encode(['error' => 'Invalid or expired token.']);
    exit;
}

$userId = $payload['userId'];
$method = $_SERVER['REQUEST_METHOD'];

try {
    if ($method === 'GET') {
        $stmt = $pdo->prepare(
            "SELECT w.wishlist_id, w.added_at,
             p.product_id, p.product_name, p.price, p.image_url, p.description
             FROM wishlist w
             JOIN products p ON w.product_id = p.product_id
             WHERE w.user_id = ?
             ORDER BY w.added_at DESC"
        );
        $stmt->execute([$userId]);
        $rows = $stmt->fetchAll();

        $items = [];
        foreach ($rows as $r) {
            $r['image_url'] = imageFullUrl($r['image_url']);
            $items[] = $r;
        }

        echo json_encode($items);

    } else if ($method === 'POST') {
        $body = getRequestBody();
        $productId = $body['product_id'] ?? null;

        if (!$productId) {
            http_response_code(400);
            echo json_encode(['error' => 'product_id is required.']);
            exit;
        }

        // Check if already in wishlist
        $stmt = $pdo->prepare('SELECT wishlist_id FROM wishlist WHERE user_id = ? AND product_id = ?');
        $stmt->execute([$userId, $productId]);
        if ($stmt->fetch()) {
            echo json_encode(['message' => 'Product already in wishlist.']);
            exit;
        }

        $stmt = $pdo->prepare('INSERT INTO wishlist (user_id, product_id) VALUES (?, ?)');
        $stmt->execute([$userId, $productId]);

        echo json_encode(['message' => 'Product added to wishlist.']);

    } else if ($method === 'DELETE') {
        $pathParts = explode('/', $_SERVER['REQUEST_URI']);
        $productId = end($pathParts);

        if (strpos($productId, '?') !== false) {
            $productId = explode('?', $productId)[0];
        }

        $stmt = $pdo->prepare('DELETE FROM wishlist WHERE user_id = ? AND product_id = ?');
        $stmt->execute([$userId, $productId]);

        echo json_encode(['message' => 'Product removed from wishlist.']);
    }

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Server error: ' . $e->getMessage()]);
}
?>
