<?php
// /api/promotions
$method = $_SERVER['REQUEST_METHOD'];
$pathParts = explode('/', $_SERVER['REQUEST_URI']);
$id = end($pathParts);
if (strpos($id, '?') !== false) $id = explode('?', $id)[0];

try {
    if ($method === 'GET') {
        $stmt = $pdo->query('SELECT * FROM promotions WHERE active = 1 AND end_date >= NOW()');
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
        $title = $body['title'];
        $desc = $body['description'] ?? '';
        $percent = $body['discount_percent'] ?? 0;
        $start = $body['start_date'] ?? date('Y-m-d');
        $end = $body['end_date'] ?? date('Y-m-d', strtotime('+30 days'));

        $stmt = $pdo->prepare('INSERT INTO promotions (title, description, discount_percent, start_date, end_date) VALUES (?, ?, ?, ?, ?)');
        $stmt->execute([$title, $desc, $percent, $start, $end]);
        echo json_encode(['message' => 'Promotion created', 'id' => $pdo->lastInsertId()]);

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
        foreach (['title', 'description', 'discount_percent', 'start_date', 'end_date', 'active'] as $f) {
            if (isset($body[$f])) { $updates[] = "$f = ?"; $params[] = $body[$f]; }
        }
        $params[] = $id;
        $stmt = $pdo->prepare("UPDATE promotions SET " . implode(', ', $updates) . " WHERE promotion_id = ?");
        $stmt->execute($params);
        echo json_encode(['message' => 'Promotion updated']);

    } else if ($method === 'DELETE') {
        $token = getBearerToken();
        $payload = JWTHelper::verify($token);
        if (!$payload || $payload['role'] !== 'admin') {
            http_response_code(403);
            echo json_encode(['error' => 'Admin access required.']);
            exit;
        }

        $stmt = $pdo->prepare('DELETE FROM promotions WHERE promotion_id = ?');
        $stmt->execute([$id]);
        echo json_encode(['message' => 'Promotion deleted']);
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Server error: ' . $e->getMessage()]);
}
?>