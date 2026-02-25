<?php
header('Content-Type: application/json');
require_once __DIR__ . '/bootstrap.php';
require_once __DIR__ . '/../config/cors.php';
require_once __DIR__ . '/../middleware/authmiddleware.php';

$db = db();
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        $stmt = $db->query('SELECT d.discount_id AS id, d.product_id, p.product_name, d.discount_percent, d.valid_from, d.valid_to 
                            FROM discounts d 
                            JOIN products p ON d.product_id = p.product_id
                            ORDER BY d.valid_from DESC');
        echo json_encode($stmt->fetchAll());
        break;

    case 'POST':
        $u = AuthMiddleware::authenticateAdmin();
        $data = json_decode(file_get_contents('php://input'), true);
        $pid = (int)($data['product_id'] ?? 0);
        $percent = (float)($data['discount_percent'] ?? 0);
        $from = $data['valid_from'] ?? null;
        $to = $data['valid_to'] ?? null;
        if ($pid <= 0 || $percent <= 0 || !$from || !$to) {
            http_response_code(400);
            echo json_encode(['message' => 'product_id, discount_percent, valid_from, valid_to required']);
            break;
        }
        $stmt = $db->prepare('INSERT INTO discounts (product_id, discount_percent, valid_from, valid_to) VALUES (?, ?, ?, ?)');
        $stmt->execute([$pid, $percent, $from, $to]);
        echo json_encode(['message' => 'Discount created', 'id' => (int)$db->lastInsertId()]);
        break;

    case 'PUT':
        $u = AuthMiddleware::authenticateAdmin();
        if (!isset($_GET['id'])) {
            http_response_code(400);
            echo json_encode(['message' => 'id required']);
            break;
        }
        $id = (int)$_GET['id'];
        $data = json_decode(file_get_contents('php://input'), true);
        $percent = $data['discount_percent'] ?? null;
        $from = $data['valid_from'] ?? null;
        $to = $data['valid_to'] ?? null;
        $stmt = $db->prepare('UPDATE discounts SET discount_percent = COALESCE(?, discount_percent), valid_from = COALESCE(?, valid_from), valid_to = COALESCE(?, valid_to) WHERE discount_id = ?');
        $stmt->execute([$percent, $from, $to, $id]);
        echo json_encode(['message' => 'Discount updated']);
        break;

    case 'DELETE':
        $u = AuthMiddleware::authenticateAdmin();
        if (!isset($_GET['id'])) {
            http_response_code(400);
            echo json_encode(['message' => 'id required']);
            break;
        }
        $id = (int)$_GET['id'];
        $stmt = $db->prepare('DELETE FROM discounts WHERE discount_id = ?');
        $stmt->execute([$id]);
        echo json_encode(['message' => 'Discount deleted']);
        break;

    default:
        http_response_code(405);
        echo json_encode(['message' => 'Method not allowed']);
}
