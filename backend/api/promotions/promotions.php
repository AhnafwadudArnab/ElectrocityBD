<?php
// /api/promotions
try {
    $stmt = $pdo->query('SELECT * FROM promotions WHERE end_date >= CURDATE()');
    $promotions = $stmt->fetchAll();
    echo json_encode($promotions);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Server error: ' . $e->getMessage()]);
}
?>
