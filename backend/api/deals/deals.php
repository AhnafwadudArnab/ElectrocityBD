<?php
// /api/deals
try {
    $stmt = $pdo->query('SELECT * FROM deals_of_the_day dd JOIN products p ON dd.product_id = p.product_id');
    $deals = $stmt->fetchAll();
    echo json_encode($deals);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Server error: ' . $e->getMessage()]);
}
?>
