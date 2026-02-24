<?php
// /api/orders

function imageFullUrl($imageUrl) {
    if (!$imageUrl || !is_string($imageUrl)) return $imageUrl ?? '';
    if (strpos($imageUrl, 'asset:') === 0) return $imageUrl;
    if (strpos($imageUrl, 'http://') === 0 || strpos($imageUrl, 'https://') === 0) return $imageUrl;
    
    $protocol = isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http";
    $host = $_SERVER['HTTP_HOST'] ?? 'localhost:3000';
    $base = "$protocol://$host";
    
    return strpos($imageUrl, '/') === 0 ? $base . $imageUrl : $base . '/' . $imageUrl;
}

$headers = getallheaders();
$authHeader = $headers['Authorization'] ?? '';
$token = '';
if (preg_match('/Bearer\s(\S+)/', $authHeader, $matches)) {
    $token = $matches[1];
}

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
$role = $payload['role'];
$method = $_SERVER['REQUEST_METHOD'];

try {
    if ($method === 'GET') {
        if ($role === 'admin') {
            $stmt = $pdo->prepare(
                "SELECT o.*, u.email, u.full_name
                 FROM orders o
                 JOIN users u ON o.user_id = u.user_id
                 ORDER BY o.order_date DESC"
            );
            $stmt->execute();
        } else {
            $stmt = $pdo->prepare("SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC");
            $stmt->execute([$userId]);
        }
        $orders = $stmt->fetchAll();

        foreach ($orders as &$order) {
            $stmtItems = $pdo->prepare(
                "SELECT oi.*, p.image_url as product_image, p.price as current_price, p.product_name as current_name, b.brand_name
                 FROM order_items oi
                 LEFT JOIN products p ON oi.product_id = p.product_id
                 LEFT JOIN brands b ON p.brand_id = b.brand_id
                 WHERE oi.order_id = ?"
            );
            $stmtItems->execute([$order['order_id']]);
            $items = $stmtItems->fetchAll();
            
            foreach ($items as &$it) {
                $it['image_url'] = imageFullUrl($it['image_url'] ?: $it['product_image']);
                $it['product_image'] = imageFullUrl($it['product_image'] ?: $it['image_url']);
            }
            $order['items'] = $items;
        }

        echo json_encode($orders);

    } else if ($method === 'POST') {
        $body = getRequestBody();
        $total_amount = $body['total_amount'] ?? 0;
        $payment_method = $body['payment_method'] ?? 'Cash on Delivery';
        $delivery_address = $body['delivery_address'] ?? '';
        $transaction_id = $body['transaction_id'] ?? '';
        $estimated_delivery = $body['estimated_delivery'] ?? '';
        $items = $body['items'] ?? [];

        if (empty($items)) {
            http_response_code(400);
            echo json_encode(['error' => 'Order must have at least one item.']);
            exit;
        }

        // Stock check
        foreach ($items as $item) {
            if (isset($item['product_id'])) {
                $stmtStock = $pdo->prepare('SELECT stock_quantity FROM products WHERE product_id = ?');
                $stmtStock->execute([$item['product_id']]);
                $stock = $stmtStock->fetchColumn() ?: 0;
                $qty = (int)($item['quantity'] ?? 0);
                if ($qty > $stock) {
                    http_response_code(400);
                    echo json_encode(['error' => "Insufficient stock for product ID {$item['product_id']}. Available: $stock, requested: $qty."]);
                    exit;
                }
            }
        }

        $stmtOrder = $pdo->prepare(
            "INSERT INTO orders (user_id, total_amount, payment_method, delivery_address, transaction_id, estimated_delivery)
             VALUES (?, ?, ?, ?, ?, ?)"
        );
        $stmtOrder->execute([$userId, $total_amount, $payment_method, $delivery_address, $transaction_id, $estimated_delivery]);
        $orderId = $pdo->lastInsertId();

        foreach ($items as $item) {
            $stmtOrderItem = $pdo->prepare(
                "INSERT INTO order_items (order_id, product_id, product_name, quantity, price_at_purchase, color, image_url)
                 VALUES (?, ?, ?, ?, ?, ?, ?)"
            );
            $stmtOrderItem->execute([
                $orderId, 
                $item['product_id'] ?? null, 
                $item['product_name'] ?? '', 
                $item['quantity'],
                $item['price'], 
                $item['color'] ?? '', 
                $item['image_url'] ?? ''
            ]);
            
            // Update stock
            if (isset($item['product_id'])) {
                $stmtUpdateStock = $pdo->prepare('UPDATE products SET stock_quantity = stock_quantity - ? WHERE product_id = ?');
                $stmtUpdateStock->execute([(int)$item['quantity'], $item['product_id']]);
            }
        }

        // Clear cart
        $stmtClearCart = $pdo->prepare('DELETE FROM cart WHERE user_id = ?');
        $stmtClearCart->execute([$userId]);

        echo json_encode(['message' => 'Order placed successfully.', 'order_id' => (int)$orderId]);
    }

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Server error: ' . $e->getMessage()]);
}
?>
