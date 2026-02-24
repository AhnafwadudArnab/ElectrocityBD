<?php
// Main Router for PHP Backend

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header("Content-Type: application/json");

// Handle preflight requests
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    exit;
}

require_once __DIR__ . '/config/db.php';
require_once __DIR__ . '/middleware/jwt_helper.php';

// Helper for environments where getallheaders() is not defined
if (!function_exists('getallheaders')) {
    function getallheaders()
    {
        $headers = [];
        foreach ($_SERVER as $name => $value) {
            if (substr($name, 0, 5) == 'HTTP_') {
                $headers[str_replace(' ', '-', ucwords(strtolower(str_replace('_', ' ', substr($name, 5)))))] = $value;
            }
        }
        return $headers;
    }
}

// Helper to get request body
function getRequestBody()
{
    return json_decode(file_get_contents('php://input'), true) ?? [];
}

// Simple Router
$requestUri = $_SERVER['REQUEST_URI'];
$scriptName = $_SERVER['SCRIPT_NAME'];
$basePath = str_replace('index.php', '', $scriptName);
$path = str_replace($basePath, '', $requestUri);
$path = explode('?', $path)[0]; // Remove query params

// Support /api/ prefix
if (strpos($path, 'api/') === 0) {
    $path = substr($path, 4);
}

// Define routes
$routes = [
    'health' => 'health.php',
    'auth/register' => 'auth/register.php',
    'auth/login' => 'auth/login.php',
    'auth/admin-login' => 'auth/admin_login.php',
    'auth/me' => 'auth/me.php',
    'products' => 'products/list.php',
    'products/detail' => 'products/detail.php', // Will handle /products/:id manually
    'categories' => 'categories/list.php',
    'cart' => 'cart/cart.php',
    'orders' => 'orders/orders.php',
    'wishlist' => 'wishlist/wishlist.php',
    'discounts' => 'discounts/discounts.php',
    'deals' => 'deals/deals.php',
    'flash-sales' => 'flash_sales/flash_sales.php',
    'promotions' => 'promotions/promotions.php',
    'admin' => 'admin/admin.php',
];

// Handle /products/:id and /api/products/:id
if (preg_match('/^products\/(\d+)$/', $path, $matches)) {
    $_GET['id'] = $matches[1];
    $path = 'products/detail';
}

// Handle /cart/:id and /wishlist/:id
if (preg_match('/^(cart|wishlist)\/(\d+)$/', $path, $matches)) {
    $_GET['id'] = $matches[2];
    $path = $matches[1];
}

// Handle /categories/:id/products
if (preg_match('/^categories\/(\d+)\/products$/', $path, $matches)) {
    $_GET['id'] = $matches[1];
    $path = 'categories';
}

if (isset($routes[$path])) {
    $file = __DIR__ . '/api/' . $routes[$path];
    if (file_exists($file)) {
        require_once $file;
    } else {
        http_response_code(404);
        echo json_encode(['error' => "Endpoint file not found: $path"]);
    }
} else {
    // Check if it's a root request
    if ($path === '' || $path === '/') {
        echo json_encode([
            'message' => 'Welcome to ElectrocityBD PHP Backend API',
            'timestamp' => date('c')
        ]);
    } else {
        http_response_code(404);
        echo json_encode(['error' => "Route $path not found."]);
    }
}
