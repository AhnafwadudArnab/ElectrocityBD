<?php
require_once __DIR__ . '/bootstrap.php';

$db = db();
$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';

if ($method === 'OPTIONS') {
    http_response_code(200);
    exit;
}

switch ($method) {
    case 'GET':
        if (isset($_GET['order_id'])) {
            $orderId = (int)$_GET['order_id'];
            $stmt = $db->prepare("
                SELECT * FROM payments
                WHERE order_id = ?
                ORDER BY payment_date DESC
            ");
            $stmt->execute([$orderId]);
            echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
        } elseif (isset($_GET['id'])) {
            $id = (int)$_GET['id'];
            $stmt = $db->prepare("SELECT * FROM payments WHERE payment_id = ?");
            $stmt->execute([$id]);
            echo json_encode($stmt->fetch(PDO::FETCH_ASSOC));
        } else {
            $stmt = $db->query("
                SELECT p.*, o.user_id, o.total_amount as order_amount
                FROM payments p
                LEFT JOIN orders o ON p.order_id = o.order_id
                ORDER BY p.payment_date DESC
            ");
            echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
        }
        break;
}
