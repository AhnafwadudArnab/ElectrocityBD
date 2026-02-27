<?php
header('Content-Type: application/json');
require_once __DIR__ . '/bootstrap.php';
require_once __DIR__ . '/../config/cors.php';

$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';
if ($method === 'OPTIONS') {
    http_response_code(200);
    echo json_encode(['ok' => true]);
    exit;
}

if ($method !== 'POST') {
    http_response_code(405);
    echo json_encode(['message' => 'Method not allowed']);
    exit;
}

if (!isset($_FILES['image'])) {
    http_response_code(400);
    echo json_encode(['message' => 'No file', 'field' => 'image']);
    exit;
}

try {
    $url = saveUploadedImage($_FILES['image']);
    if (!$url) {
        http_response_code(500);
        echo json_encode(['message' => 'Upload failed']);
        exit;
    }
    echo json_encode(['url' => $url]);
} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode(['message' => 'Upload error']);
}
