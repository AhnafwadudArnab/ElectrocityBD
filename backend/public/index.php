<?php
ini_set('display_errors', '0');
ini_set('display_startup_errors', '0');
ini_set('html_errors', '0');
error_reporting(0);
header('Content-Type: application/json');
require_once __DIR__ . '/../config/cors.php';

$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$segments = array_values(array_filter(explode('/', trim($path, '/'))));

// Allow direct access to installer if rewrite rules don't catch it
if (!empty($segments[0]) && $segments[0] === 'install.php') {
    $installer = __DIR__ . '/install.php';
    if (is_file($installer)) {
        require_once $installer;
        exit;
    }
}

if (!empty($segments[0]) && $segments[0] === 'uploads') {
    $local = __DIR__ . $path;
    if (is_file($local)) {
        $ext = strtolower(pathinfo($local, PATHINFO_EXTENSION));
        $types = [
            'jpg' => 'image/jpeg',
            'jpeg' => 'image/jpeg',
            'png' => 'image/png',
            'webp' => 'image/webp',
        ];
        header('Content-Type: ' . ($types[$ext] ?? 'application/octet-stream'));
        readfile($local);
        exit;
    }
}

// Serve images from assets folder (for Flutter assets)
if (!empty($segments[0]) && $segments[0] === 'assets') {
    // Construct path to Flutter assets folder
    $assetsPath = __DIR__ . '/../../assets/' . implode('/', array_slice($segments, 1));
    if (is_file($assetsPath)) {
        $ext = strtolower(pathinfo($assetsPath, PATHINFO_EXTENSION));
        $types = [
            'jpg' => 'image/jpeg',
            'jpeg' => 'image/jpeg',
            'png' => 'image/png',
            'webp' => 'image/webp',
        ];
        header('Content-Type: ' . ($types[$ext] ?? 'application/octet-stream'));
        readfile($assetsPath);
        exit;
    }
}

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
    
    // Handle routes with IDs (e.g., /api/payment_methods/1 or /api/products/123)
    if (count($segments) >= 3 && is_numeric($segments[2])) {
        // Extract ID and set it in $_GET
        $_GET['id'] = $segments[2];
        // Try the base file without the ID
        $file = $apiBase . '/' . $segments[1] . '.php';
    } elseif (count($segments) >= 3) {
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
    echo json_encode(['message' => 'Endpoint not found: ' . ($file ?? 'unknown')]);
    exit;
}

http_response_code(404);
echo json_encode(['message' => 'Endpoint not found']);
