<?php
/**
 * CORS Configuration - Production Ready
 * Handles Cross-Origin Resource Sharing with security
 */

// Get allowed origins from environment or use defaults
$allowedOriginsEnv = getenv('ALLOWED_ORIGINS');
$allowed_origins = [];

if ($allowedOriginsEnv) {
    $allowed_origins = array_map('trim', explode(',', $allowedOriginsEnv));
} else {
    // Default production origins
    $allowed_origins = [
        'https://yourdomain.com',
        'https://www.yourdomain.com',
        'https://app.yourdomain.com'
    ];
    
    // Development origins
    if (getenv('APP_ENV') === 'development') {
        $allowed_origins = array_merge($allowed_origins, [
            'http://localhost:3000',
            'http://localhost:8000',
            'http://localhost:8080',
            'http://127.0.0.1:3000',
            'http://127.0.0.1:8000',
            'http://127.0.0.1:8080'
        ]);
    }
}

$origin = $_SERVER['HTTP_ORIGIN'] ?? '';

if (in_array($origin, $allowed_origins)) {
    header("Access-Control-Allow-Origin: $origin");
    header('Access-Control-Allow-Credentials: true');
} else {
    // Log unauthorized access in production
    if ($origin && getenv('APP_ENV') === 'production') {
        error_log("Unauthorized CORS request from: $origin");
    }
    // In development, allow localhost variations
    if (getenv('APP_ENV') === 'development' && 
        (strpos($origin, 'localhost') !== false || strpos($origin, '127.0.0.1') !== false)) {
        header("Access-Control-Allow-Origin: $origin");
        header('Access-Control-Allow-Credentials: true');
    }
}

// Security headers
header("X-Content-Type-Options: nosniff");
header("X-Frame-Options: SAMEORIGIN");
header("X-XSS-Protection: 1; mode=block");
header("Referrer-Policy: strict-origin-when-cross-origin");
header('Access-Control-Max-Age: 3600');

// Handle OPTIONS requests
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_METHOD']))
        header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
    
    if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']))
        header("Access-Control-Allow-Headers: {$_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']}");
    
    exit(0);
}

header('Content-Type: application/json');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With, X-API-Key');

