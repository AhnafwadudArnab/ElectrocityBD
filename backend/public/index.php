<?php
header('Content-Type: application/json');
require_once __DIR__ . '/config/cors.php';

$request_uri = $_SERVER['REQUEST_URI'];
$script_name = $_SERVER['SCRIPT_NAME'];

// Remove script name from request URI
$base = str_replace('index.php', '', $script_name);
$path = str_replace($base, '', $request_uri);
$path = parse_url($path, PHP_URL_PATH);
$segments = explode('/', trim($path, '/'));

if (empty($segments[0])) {
    echo json_encode([
        'name' => 'ElectrocityBD API',
        'version' => '1.0.0',
        'endpoints' => [
            '/api/auth' => 'Authentication endpoints',
            '/api/products' => 'Product endpoints',
            '/api/cart' => 'Cart endpoints',
            '/api/orders' => 'Order endpoints',
            '/api/user' => 'User endpoints',
            '/api/admin' => 'Admin endpoints'
        ]
    ]);
    exit;
}

// Route to appropriate API file
$api_file = __DIR__ . '/api/' . $segments[0] . '.php';

if (file_exists($api_file)) {
    $_GET = array_merge($_GET, $_REQUEST);
    require_once $api_file;
} else {
    http_response_code(404);
    echo json_encode(['message' => 'Endpoint not found']);
}
?>