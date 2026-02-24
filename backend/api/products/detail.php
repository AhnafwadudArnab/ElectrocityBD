<?php
// GET /api/products/:id

function imageFullUrl($imageUrl) {
    if (!$imageUrl || !is_string($imageUrl)) return $imageUrl ?? '';
    if (strpos($imageUrl, 'asset:') === 0) return $imageUrl;
    if (strpos($imageUrl, 'http://') === 0 || strpos($imageUrl, 'https://') === 0) return $imageUrl;
    
    $protocol = isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http";
    $host = $_SERVER['HTTP_HOST'] ?? 'localhost:3000';
    $base = "$protocol://$host";
    
    return strpos($imageUrl, '/') === 0 ? $base . $imageUrl : $base . '/' . $imageUrl;
}

$method = $_SERVER['REQUEST_METHOD'];

try {
    $id = $_GET['id'] ?? null;
    if (!$id) {
        http_response_code(400);
        echo json_encode(['error' => 'Product ID is required.']);
        exit;
    }

    if ($method === 'GET') {
        $stmt = $pdo->prepare(
            "SELECT p.*, c.category_name, b.brand_name,
             d.discount_percent, d.valid_from, d.valid_to
             FROM products p
             LEFT JOIN categories c ON p.category_id = c.category_id
             LEFT JOIN brands b ON p.brand_id = b.brand_id
             LEFT JOIN discounts d ON p.product_id = d.product_id
             WHERE p.product_id = ?"
        );
        $stmt->execute([$id]);
        $row = $stmt->fetch();

        if (!$row) {
            http_response_code(404);
            echo json_encode(['error' => 'Product not found.']);
            exit;
        }

        $row['image_url'] = imageFullUrl($row['image_url']);

        echo json_encode($row);

    } else if ($method === 'PUT') {
        // Admin only check
        $token = getBearerToken();
        $payload = $token ? JWTHelper::verify($token) : null;
        if (!$payload || $payload['role'] !== 'admin') {
            http_response_code(403);
            echo json_encode(['error' => 'Unauthorized. Admin only.']);
            exit;
        }

        $body = getRequestBody();
        $updates = [];
        $params = [];
        
        $fields = [
            'category_id', 'brand_id', 'product_name', 'description',
            'price', 'stock_quantity', 'image_url'
        ];
        
        foreach ($fields as $f) {
            if (isset($body[$f])) {
                $updates[] = "$f = ?";
                $val = $body[$f];
                $params[] = $val;
            }
        }
        
        if (empty($updates)) {
            http_response_code(400);
            echo json_encode(['error' => 'No fields to update.']);
            exit;
        }
        
        $params[] = $id;
        $stmt = $pdo->prepare("UPDATE products SET " . implode(', ', $updates) . " WHERE product_id = ?");
        $stmt->execute($params);
        echo json_encode(['message' => 'Product updated successfully.']);

    } else if ($method === 'DELETE') {
        // Admin only check
        $token = getBearerToken();
        $payload = $token ? JWTHelper::verify($token) : null;
        if (!$payload || $payload['role'] !== 'admin') {
            http_response_code(403);
            echo json_encode(['error' => 'Unauthorized. Admin only.']);
            exit;
        }

        $stmt = $pdo->prepare("DELETE FROM products WHERE product_id = ?");
        $stmt->execute([$id]);
        echo json_encode(['message' => 'Product deleted successfully.']);
    }

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Server error: ' . $e->getMessage()]);
}
?>
