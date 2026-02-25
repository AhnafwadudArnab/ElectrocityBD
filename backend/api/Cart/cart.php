<?php
header('Content-Type: application/json');
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../config/cors.php';
require_once __DIR__ . '/../controllers/CartController.php';
require_once __DIR__ . '/../middleware/AuthMiddleware.php';

$database = new Database();
$db = $database->getConnection();
$cart = new CartController($db);

$method = $_SERVER['REQUEST_METHOD'];
$user = AuthMiddleware::authenticate();

switch ($method) {
    case 'GET':
        echo json_encode($cart->getCart($user['user_id']));
        break;
        
    case 'POST':
        $post_data = json_decode(file_get_contents('php://input'), true);
        echo json_encode($cart->addItem($user['user_id'], $post_data));
        break;
        
    case 'PUT':
        $put_data = json_decode(file_get_contents('php://input'), true);
        echo json_encode($cart->updateQuantity($user['user_id'], $put_data));
        break;
        
    case 'DELETE':
        $delete_data = json_decode(file_get_contents('php://input'), true);
        if (isset($_GET['clear']) && $_GET['clear'] == 'true') {
            echo json_encode($cart->clearCart($user['user_id']));
        } else {
            echo json_encode($cart->removeItem($user['user_id'], $delete_data));
        }
        break;
        
    default:
        http_response_code(405);
        echo json_encode(['message' => 'Method not allowed']);
}
?>