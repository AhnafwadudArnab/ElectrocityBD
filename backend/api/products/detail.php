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

try {
    $id = $_GET['id'] ?? null;
    if (!$id) {
        http_response_code(400);
        echo json_encode(['error' => 'Product ID is required.']);
        exit;
    }

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

    $specs = $row['specs_json'];
    if (is_string($specs)) $specs = json_decode($specs, true);
    $row['specs_json'] = $specs;
    $row['image_url'] = imageFullUrl($row['image_url']);

    echo json_encode($row);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Server error: ' . $e->getMessage()]);
}
?>
