<?php
// GET /api/health
header('Content-Type: application/json');
try {
    // $pdo should be available from index.php include
    if (isset($pdo)) {
        $stmt = $pdo->query('SELECT 1');
        $ok = $stmt->fetchColumn() == 1;
        echo json_encode([
            'status' => 'ok',
            'db' => $ok ? 'connected' : 'unknown',
            'timestamp' => date('c')
        ]);
    } else {
        echo json_encode([
            'status' => 'ok',
            'db' => 'unknown',
            'timestamp' => date('c')
        ]);
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['status' => 'error', 'error' => $e->getMessage()]);
}
?>
