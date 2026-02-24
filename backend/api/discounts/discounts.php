<?php
// /api/discounts
try {
    $stmt = $pdo->query('SELECT * FROM discounts WHERE valid_to >= NOW()');
    $discounts = $stmt->fetchAll();
    echo json_encode($discounts);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Server error: ' . $e->getMessage()]);
}
?>
