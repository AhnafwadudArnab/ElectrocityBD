<?php
header('Content-Type: application/json');
require_once __DIR__ . '/../config/cors.php';

$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$segments = array_values(array_filter(explode('/', trim($path, '/'))));

if (empty($segments[0])) {
    echo json_encode([
        'name' => 'ElectrocityBD API',
        'version' => '1.0.0',
        'endpoints' => [
            '/api/auth/login' => 'User login',
            '/api/auth/register' => 'User registration',
            '/api/products' => 'Product endpoints',
            '/api/cart' => 'Cart endpoints',
            '/api/orders' => 'Order endpoints',
            '/api/users' => 'User endpoints'
        ]
    ]);
    exit;
}

if ($segments[0] === 'api') {
    if ((isset($segments[1]) && $segments[1] === 'health')) {
        echo json_encode(['status' => 'ok']);
        exit;
    }
    $apiBase = __DIR__ . '/../api';
    $file = null;
    if (count($segments) >= 3) {
        $file = $apiBase . '/' . $segments[1] . '/' . $segments[2] . '.php';
    } elseif (count($segments) >= 2) {
        $file = $apiBase . '/' . $segments[1] . '.php';
    }
    if ($file && file_exists($file)) {
        $_GET = array_merge($_GET, $_REQUEST);
        require_once $file;
        exit;
    }
    http_response_code(404);
    echo json_encode(['message' => 'Endpoint not found']);
    exit;
}

http_response_code(404);
echo json_encode(['message' => 'Endpoint not found']);
?>
