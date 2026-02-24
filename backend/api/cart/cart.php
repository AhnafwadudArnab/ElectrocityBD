<?php
// /api/cart

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
$pathParts = explode('/', $_SERVER['REQUEST_URI']);
$lastPart = end($pathParts);
if (strpos($lastPart, '?') !== false) $lastPart = explode('?', $lastPart)[0];

try {
    if ($lastPart === 'all' && $method === 'GET' && $payload['role'] === 'admin') {
        $stmt = $pdo->query(
            "SELECT c.*, p.product_name, u.email, u.full_name
             FROM cart c
             JOIN products p ON c.product_id = p.product_id
             JOIN users u ON c.user_id = u.user_id
             ORDER BY c.added_at DESC"
        );
        echo json_encode($stmt->fetchAll());
        exit;
    }

    if ($method === 'GET') {
        $stmt = $pdo->prepare(
            "SELECT c.cart_id, c.quantity, c.added_at,
             p.product_id, p.product_name, p.price, p.image_url, p.stock_quantity,
             cat.category_name
             FROM cart c
             JOIN products p ON c.product_id = p.product_id
             LEFT JOIN categories cat ON p.category_id = cat.category_id
             WHERE c.user_id = ?
             ORDER BY c.added_at DESC"
        );
        $stmt->execute([$userId]);
        $rows = $stmt->fetchAll();

        $items = [];
        $total = 0;
        $itemCount = 0;

        foreach ($rows as $r) {
            $r['image_url'] = imageFullUrl($r['image_url']);
            $items[] = $r;
            $total += $r['price'] * $r['quantity'];
            $itemCount += $r['quantity'];
        }

        echo json_encode(['items' => $items, 'total' => (float)$total, 'itemCount' => (int)$itemCount]);

    } else if ($method === 'POST') {
        $body = getRequestBody();
        $productId = $body['product_id'] ?? null;
        $quantity = $body['quantity'] ?? 1;

        if (!$productId) {
            http_response_code(400);
            echo json_encode(['error' => 'product_id is required.']);
            exit;
        }

        $stmt = $pdo->prepare('SELECT cart_id, quantity FROM cart WHERE user_id = ? AND product_id = ?');
        $stmt->execute([$userId, $productId]);
        $existing = $stmt->fetch();

        if ($existing) {
            $stmt = $pdo->prepare('UPDATE cart SET quantity = quantity + ? WHERE cart_id = ?');
            $stmt->execute([$quantity, $existing['cart_id']]);
        } else {
            $stmt = $pdo->prepare('INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)');
            $stmt->execute([$userId, $productId, $quantity]);
        }

        echo json_encode(['message' => 'Item added to cart.']);

    } else if ($method === 'PUT') {
        // Handle /api/cart/:id - extract ID from path
        $pathParts = explode('/', $_SERVER['REQUEST_URI']);
        $cartId = end($pathParts);
        
        $body = getRequestBody();
        $quantity = $body['quantity'] ?? null;

        if ($quantity === null) {
            http_response_code(400);
            echo json_encode(['error' => 'quantity is required.']);
            exit;
        }

        if ($quantity <= 0) {
            $stmt = $pdo->prepare('DELETE FROM cart WHERE cart_id = ? AND user_id = ?');
            $stmt->execute([$cartId, $userId]);
        } else {
            $stmt = $pdo->prepare('UPDATE cart SET quantity = ? WHERE cart_id = ? AND user_id = ?');
            $stmt->execute([$quantity, $cartId, $userId]);
        }

        echo json_encode(['message' => 'Cart updated.']);

    } else if ($method === 'DELETE') {
        $pathParts = explode('/', $_SERVER['REQUEST_URI']);
        $cartId = end($pathParts);

        if (strpos($cartId, '?') !== false) {
            $cartId = explode('?', $cartId)[0];
        }

        if (!is_numeric($cartId) || $cartId === 'cart') {
            $stmt = $pdo->prepare('DELETE FROM cart WHERE user_id = ?');
            $stmt->execute([$userId]);
            echo json_encode(['message' => 'Cart cleared.']);
            return;
        } else {
            $stmt = $pdo->prepare('DELETE FROM cart WHERE cart_id = ? AND user_id = ?');
            $stmt->execute([$cartId, $userId]);
        }

        echo json_encode(['message' => 'Item removed from cart.']);
    }

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Server error: ' . $e->getMessage()]);
}
?>
