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

// Serve static files from uploads and assets
$requestUri = $_SERVER['REQUEST_URI'];
$scriptName = $_SERVER['SCRIPT_NAME'];
$basePath = str_replace('index.php', '', $scriptName);
$path = str_replace($basePath, '', $requestUri);
$path = explode('?', $path)[0]; // Remove query params

// Handle static files for /uploads and /assets
if (preg_match('/^\/(uploads|assets)\//', $path)) {
    // Prevent directory traversal
    $safePath = realpath(__DIR__ . ($path[1] === 'u' ? $path : '/..' . $path));
    $uploadsDir = realpath(__DIR__ . '/uploads');
    $assetsDir = realpath(__DIR__ . '/../assets');

    if (
        ($path[1] === 'u' && $safePath && strpos($safePath, $uploadsDir) === 0) ||
        ($path[1] === 'a' && $safePath && strpos($safePath, $assetsDir) === 0)
    ) {
        if (file_exists($safePath) && !is_dir($safePath)) {
            $ext = pathinfo($safePath, PATHINFO_EXTENSION);
            $mimeTypes = [
                'jpg' => 'image/jpeg',
                'jpeg' => 'image/jpeg',
                'png' => 'image/png',
                'gif' => 'image/gif',
                'webp' => 'image/webp',
                'css' => 'text/css',
                'js' => 'application/javascript',
            ];
            $contentType = $mimeTypes[strtolower($ext)] ?? 'application/octet-stream';
            header("Content-Type: $contentType");
            readfile($safePath);
            exit;
        }
    }
}

// Helper to extract Bearer token from headers or server variables
function getBearerToken() {
    // 1. Try SERVER variables (most reliable in PHP built-in server)
    $authHeader = $_SERVER['HTTP_AUTHORIZATION'] ?? $_SERVER['REDIRECT_HTTP_AUTHORIZATION'] ?? '';

    // 2. Try headers if server variables are empty
    if (empty($authHeader)) {
        $headers = [];
        if (function_exists('getallheaders')) {
            $headers = getallheaders();
        } elseif (function_exists('apache_request_headers')) {
            $headers = apache_request_headers();
        }
        
        // Normalize keys to lowercase for easier lookup
        $lowerHeaders = array_change_key_case($headers, CASE_LOWER);
        $authHeader = $lowerHeaders['authorization'] ?? '';
    }

    if (!empty($authHeader) && preg_match('/Bearer\s(\S+)/i', $authHeader, $matches)) {
        return $matches[1];
    }
    return null;
}

// Helper to get request body
function getRequestBody()
{
    return json_decode(file_get_contents('php://input'), true) ?? [];
}

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
    'auth/change-password' => 'auth/change_password.php',
    'auth/refresh' => 'auth/refresh.php',
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

// Handle /cart/:id, /wishlist/:id, /orders/:id
if (preg_match('/^(cart|wishlist|orders)\/(\d+)$/', $path, $matches)) {
    $_GET['id'] = $matches[2];
    $path = $matches[1];
}

// Handle /orders/:id/status
if (preg_match('/^orders\/(\d+)\/status$/', $path, $matches)) {
    $_GET['id'] = $matches[1];
    $path = 'orders';
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
