<?php
// /api/flash-sales
$method = $_SERVER['REQUEST_METHOD'];
$pathParts = explode('/', $_SERVER['REQUEST_URI']);
$id = end($pathParts);
if (strpos($id, '?') !== false) $id = explode('?', $id)[0];

try {
    if ($method === 'GET') {
        $stmt = $pdo->query('SELECT * FROM flash_sales WHERE active = 1 AND end_time >= NOW()');
        $sales = $stmt->fetchAll();
        foreach ($sales as &$s) {
            $stmtProducts = $pdo->prepare('SELECT p.* FROM flash_sale_products fsp JOIN products p ON fsp.product_id = p.product_id WHERE fsp.flash_sale_id = ?');
            $stmtProducts->execute([$s['flash_sale_id']]);
            $s['products'] = $stmtProducts->fetchAll();
        }
        echo json_encode($sales);

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
        $start = $body['start_time'];
        $end = $body['end_time'];
        $productIds = $body['product_ids'] ?? [];

        $pdo->beginTransaction();
        $stmt = $pdo->prepare('INSERT INTO flash_sales (title, start_time, end_time) VALUES (?, ?, ?)');
        $stmt->execute([$title, $start, $end]);
        $fsId = $pdo->lastInsertId();

        foreach ($productIds as $pid) {
            $stmtProd = $pdo->prepare('INSERT INTO flash_sale_products (flash_sale_id, product_id) VALUES (?, ?)');
            $stmtProd->execute([$fsId, $pid]);
        }
        $pdo->commit();
        echo json_encode(['message' => 'Flash sale created', 'id' => $fsId]);

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
        foreach (['title', 'start_time', 'end_time', 'active'] as $f) {
            if (isset($body[$f])) { $updates[] = "$f = ?"; $params[] = $body[$f]; }
        }
        $params[] = $id;
        $stmt = $pdo->prepare("UPDATE flash_sales SET " . implode(', ', $updates) . " WHERE flash_sale_id = ?");
        $stmt->execute($params);
        echo json_encode(['message' => 'Flash sale updated']);

    } else if ($method === 'DELETE') {
        $token = getBearerToken();
        $payload = JWTHelper::verify($token);
        if (!$payload || $payload['role'] !== 'admin') {
            http_response_code(403);
            echo json_encode(['error' => 'Admin access required.']);
            exit;
        }

        $stmt = $pdo->prepare('DELETE FROM flash_sales WHERE flash_sale_id = ?');
        $stmt->execute([$id]);
        echo json_encode(['message' => 'Flash sale deleted']);
    }
} catch (Exception $e) {
    if ($pdo->inTransaction()) $pdo->rollBack();
    http_response_code(500);
    echo json_encode(['error' => 'Server error: ' . $e->getMessage()]);
}
?>