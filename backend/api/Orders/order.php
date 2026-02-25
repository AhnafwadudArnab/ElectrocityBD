<?php
header('Content-Type: application/json');
require_once __DIR__ . '/../bootstrap.php';
require_once __DIR__ . '/../../config/cors.php';
require_once __DIR__ . '/../../controllers/orderController.php';
require_once __DIR__ . '/../../middleware/authmiddleware.php';

$db = db();
$order = new OrderController($db);

$method = $_SERVER['REQUEST_METHOD'];
$user = AuthMiddleware::authenticate();

switch ($method) {
    case 'GET':
        if (isset($_GET['id'])) {
            echo json_encode($order->getOrderDetails($_GET['id'], $user['user_id']));
        } elseif (isset($_GET['admin']) && $user['role'] === 'admin') {
            echo json_encode($order->getAllOrders($_GET));
        } else {
            echo json_encode($order->getUserOrders($user['user_id']));
        }
        break;
        
    case 'POST':
        $post_data = json_decode(file_get_contents('php://input'), true);
        echo json_encode($order->createOrder($user['user_id'], $post_data));
        break;
        
    case 'PUT':
        if (!isset($_GET['id'])) {
            http_response_code(400);
            echo json_encode(['message' => 'Order ID required']);
            break;
        }
        
        if ($user['role'] !== 'admin') {
            http_response_code(403);
            echo json_encode(['message' => 'Admin access required']);
            break;
        }
        
        $put_data = json_decode(file_get_contents('php://input'), true);
        echo json_encode($order->updateStatus($_GET['id'], $put_data, $user['user_id']));
        break;
        
    default:
        http_response_code(405);
        echo json_encode(['message' => 'Method not allowed']);
}
?>
