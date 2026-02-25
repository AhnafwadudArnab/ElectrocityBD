<?php
header('Content-Type: application/json');
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../config/cors.php';
require_once __DIR__ . '/../controllers/ProductController.php';
require_once __DIR__ . '/../middleware/AuthMiddleware.php';

$database = new Database();
$db = $database->getConnection();
$product = new ProductController($db);

$method = $_SERVER['REQUEST_METHOD'];
$data = $_GET;

switch ($method) {
    case 'GET':
        if (isset($_GET['id'])) {
            echo json_encode($product->getById($_GET['id']));
        } elseif (isset($_GET['action'])) {
            switch ($_GET['action']) {
                case 'best-sellers':
                    echo json_encode($product->getBestSellers($data));
                    break;
                case 'trending':
                    echo json_encode($product->getTrending($data));
                    break;
                case 'deals':
                    echo json_encode($product->getDealsOfDay($data));
                    break;
                case 'flash-sale':
                    echo json_encode($product->getFlashSale($data));
                    break;
                case 'search':
                    echo json_encode($product->search($data));
                    break;
                case 'categories':
                    echo json_encode($product->getCategories());
                    break;
                case 'brands':
                    echo json_encode($product->getBrands());
                    break;
                default:
                    echo json_encode($product->getAll($data));
            }
        } else {
            echo json_encode($product->getAll($data));
        }
        break;
        
    case 'POST':
        $user = AuthMiddleware::authenticateAdmin();
        $post_data = json_decode(file_get_contents('php://input'), true);
        echo json_encode($product->create($post_data));
        break;
        
    case 'PUT':
        $user = AuthMiddleware::authenticateAdmin();
        if (!isset($_GET['id'])) {
            http_response_code(400);
            echo json_encode(['message' => 'Product ID required']);
            break;
        }
        $put_data = json_decode(file_get_contents('php://input'), true);
        echo json_encode($product->update($_GET['id'], $put_data));
        break;
        
    case 'DELETE':
        $user = AuthMiddleware::authenticateAdmin();
        if (!isset($_GET['id'])) {
            http_response_code(400);
            echo json_encode(['message' => 'Product ID required']);
            break;
        }
        echo json_encode($product->delete($_GET['id']));
        break;
        
    default:
        http_response_code(405);
        echo json_encode(['message' => 'Method not allowed']);
}
?>