<?php
header('Content-Type: application/json');
require_once __DIR__ . '/bootstrap.php';
require_once __DIR__ . '/../config/cors.php';
require_once __DIR__ . '/../controllers/productController.php';
require_once __DIR__ . '/../middleware/authmiddleware.php';

$db = db();
$product = new ProductController($db);
$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    if (isset($_GET['id'])) {
        echo json_encode($product->getById($_GET['id']));
        exit;
    }
    if (isset($_GET['action'])) {
        switch ($_GET['action']) {
            case 'best-sellers':
                echo json_encode($product->getBestSellers($_GET));
                exit;
            case 'trending':
                echo json_encode($product->getTrending($_GET));
                exit;
            case 'deals':
                echo json_encode($product->getDealsOfDay($_GET));
                exit;
            case 'flash-sale':
                echo json_encode($product->getFlashSale($_GET));
                exit;
            case 'search':
                echo json_encode($product->search($_GET));
                exit;
            case 'categories':
                echo json_encode($product->getCategories());
                exit;
            case 'brands':
                echo json_encode($product->getBrands());
                exit;
        }
    }
    echo json_encode(['products' => $product->getAll($_GET), 'total' => count($product->getAll($_GET))]);
    exit;
}

if ($method === 'POST') {
    $admin = AuthMiddleware::authenticateAdmin();
    $data = $_POST;
    if (!empty($_FILES['image'])) {
        $path = saveUploadedImage($_FILES['image']);
        if ($path) $data['image_url'] = $path;
    }
    $created = $product->create($data);
    if (is_array($created) && isset($created['product_id'])) {
        $created['productId'] = $created['product_id'];
    }
    echo json_encode($created);
    exit;
}

if ($method === 'PUT') {
    $admin = AuthMiddleware::authenticateAdmin();
    if (!isset($_GET['id'])) {
        http_response_code(400);
        echo json_encode(['message' => 'Product ID required']);
        exit;
    }
    $data = getJsonBody();
    echo json_encode($product->update($_GET['id'], $data));
    exit;
}

if ($method === 'DELETE') {
    $admin = AuthMiddleware::authenticateAdmin();
    if (!isset($_GET['id'])) {
        http_response_code(400);
        echo json_encode(['message' => 'Product ID required']);
        exit;
    }
    echo json_encode($product->delete($_GET['id']));
    exit;
}

http_response_code(405);
echo json_encode(['message' => 'Method not allowed']);
