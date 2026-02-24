<?php
// /api/flash-sales
try {
    $stmt = $pdo->query('SELECT * FROM flash_sales WHERE end_time >= NOW()');
    $flash_sales = $stmt->fetchAll();
    echo json_encode($flash_sales);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Server error: ' . $e->getMessage()]);
}
?>
