<?php
// /api/deals
$method = $_SERVER['REQUEST_METHOD'];
$pathParts = explode('/', $_SERVER['REQUEST_URI']);
$id = end($pathParts);
if (strpos($id, '?') !== false) $id = explode('?', $id)[0];

try {
    if ($method === 'GET') {
        $stmt = $pdo->query('SELECT d.*, p.product_name, p.price as original_price FROM deals_of_the_day d JOIN products p ON d.product_id = p.product_id WHERE d.end_date >= NOW()');
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
        $dealPrice = $body['deal_price'];
        $start = $body['start_date'] ?? date('Y-m-d H:i:s');
        $end = $body['end_date'] ?? date('Y-m-d H:i:s', strtotime('+1 day'));

        $stmt = $pdo->prepare('INSERT INTO deals_of_the_day (product_id, deal_price, start_date, end_date) VALUES (?, ?, ?, ?)');
        $stmt->execute([$productId, $dealPrice, $start, $end]);
        echo json_encode(['message' => 'Deal created', 'id' => $pdo->lastInsertId()]);

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
        foreach (['product_id', 'deal_price', 'start_date', 'end_date'] as $f) {
            if (isset($body[$f])) { $updates[] = "$f = ?"; $params[] = $body[$f]; }
        }
        $params[] = $id;
        $stmt = $pdo->prepare("UPDATE deals_of_the_day SET " . implode(', ', $updates) . " WHERE deal_id = ?");
        $stmt->execute($params);
        echo json_encode(['message' => 'Deal updated']);

    } else if ($method === 'DELETE') {
        $token = getBearerToken();
        $payload = JWTHelper::verify($token);
        if (!$payload || $payload['role'] !== 'admin') {
            http_response_code(403);
            echo json_encode(['error' => 'Admin access required.']);
            exit;
        }

        $stmt = $pdo->prepare('DELETE FROM deals_of_the_day WHERE deal_id = ?');
        $stmt->execute([$id]);
        echo json_encode(['message' => 'Deal deleted']);
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Server error: ' . $e->getMessage()]);
}
?>