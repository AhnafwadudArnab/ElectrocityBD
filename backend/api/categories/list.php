<?php
// GET /api/categories

$method = $_SERVER['REQUEST_METHOD'];
$pathParts = explode('/', $_SERVER['REQUEST_URI']);
$lastPart = end($pathParts);
if (strpos($lastPart, '?') !== false) {
    $lastPart = explode('?', $lastPart)[0];
}

try {
    if ($method === 'GET') {
        // Check if it's /api/categories/:id/products
        if ($lastPart === 'products') {
            $id = $pathParts[count($pathParts)-2];
            $stmt = $pdo->prepare(
                "SELECT p.*, b.brand_name, d.discount_percent
                 FROM products p
                 LEFT JOIN brands b ON p.brand_id = b.brand_id
                 LEFT JOIN discounts d ON p.product_id = d.product_id
                 WHERE p.category_id = ?
                 ORDER BY p.created_at DESC"
            );
            $stmt->execute([$id]);
            echo json_encode($stmt->fetchAll());
            exit;
        }

        // Default: list all categories
        $stmt = $pdo->query(
            "SELECT c.*, COUNT(p.product_id) as product_count
             FROM categories c
             LEFT JOIN products p ON c.category_id = p.category_id
             GROUP BY c.category_id
             ORDER BY c.category_name"
        );
        echo json_encode($stmt->fetchAll());

    } else if ($method === 'POST') {
        // Auth and Admin check
        $headers = getallheaders();
        $authHeader = $headers['Authorization'] ?? '';
        $token = '';
        if (preg_match('/Bearer\s(\S+)/', $authHeader, $matches)) {
            $token = $matches[1];
        }
        $payload = JWTHelper::verify($token);
        if (!$payload || $payload['role'] !== 'admin') {
            http_response_code(403);
            echo json_encode(['error' => 'Admin access required.']);
            exit;
        }

        $body = getRequestBody();
        $name = $body['category_name'] ?? '';
        $image = $body['category_image'] ?? '';
        
        $stmt = $pdo->prepare('INSERT INTO categories (category_name, category_image) VALUES (?, ?)');
        $stmt->execute([$name, $image]);
        
        http_response_code(201);
        echo json_encode(['message' => 'Category created.', 'categoryId' => (int)$pdo->lastInsertId()]);
    }

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Server error: ' . $e->getMessage()]);
}
?>
