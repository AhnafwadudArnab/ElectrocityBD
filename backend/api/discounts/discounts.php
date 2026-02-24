<?php
// /api/discounts
$method = $_SERVER['REQUEST_METHOD'];
$pathParts = explode('/', $_SERVER['REQUEST_URI']);
$id = end($pathParts);
if (strpos($id, '?') !== false) $id = explode('?', $id)[0];

try {
    if ($method === 'GET') {
        $stmt = $pdo->query('SELECT d.*, p.product_name FROM discounts d JOIN products p ON d.product_id = p.product_id WHERE d.valid_to >= NOW()');
        echo json_encode($stmt->fetchAll());

    } else if ($method === 'POST') {
        $token = getBearerToken();
        $payload = JWTHelper::verify($token);
        if (!$payload || $payload['role'] !== 'admin') {
            http_response_code(403);
            echo json_encode(['error' => 'Admin access required.']);
            exit;
        }

        $body = getRequestBody();
        $productId = $body['product_id'];
        $percent = $body['discount_percent'];
        $from = $body['valid_from'] ?? date('Y-m-d');
        $to = $body['valid_to'] ?? date('Y-m-d', strtotime('+30 days'));

        $stmt = $pdo->prepare('INSERT INTO discounts (product_id, discount_percent, valid_from, valid_to) VALUES (?, ?, ?, ?)');
        $stmt->execute([$productId, $percent, $from, $to]);
        echo json_encode(['message' => 'Discount created', 'id' => $pdo->lastInsertId()]);

    } else if ($method === 'PUT') {
        $token = getBearerToken();
        $payload = JWTHelper::verify($token);
        if (!$payload || $payload['role'] !== 'admin') {
            http_response_code(403);
            echo json_encode(['error' => 'Admin access required.']);
            exit;
        }

        $body = getRequestBody();
        $updates = [];
        $params = [];
        foreach (['product_id', 'discount_percent', 'valid_from', 'valid_to'] as $f) {
            if (isset($body[$f])) { $updates[] = "$f = ?"; $params[] = $body[$f]; }
        }
        $params[] = $id;
        $stmt = $pdo->prepare("UPDATE discounts SET " . implode(', ', $updates) . " WHERE discount_id = ?");
        $stmt->execute($params);
        echo json_encode(['message' => 'Discount updated']);

    } else if ($method === 'DELETE') {
        $token = getBearerToken();
        $payload = JWTHelper::verify($token);
        if (!$payload || $payload['role'] !== 'admin') {
            http_response_code(403);
            echo json_encode(['error' => 'Admin access required.']);
            exit;
        }

        $stmt = $pdo->prepare('DELETE FROM discounts WHERE discount_id = ?');
        $stmt->execute([$id]);
        echo json_encode(['message' => 'Discount deleted']);
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Server error: ' . $e->getMessage()]);
}
?>