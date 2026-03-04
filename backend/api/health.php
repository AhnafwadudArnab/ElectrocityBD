<?php
require_once __DIR__ . '/bootstrap.php';

// Simple health check endpoint
$response = [
    'status' => 'ok',
    'timestamp' => time(),
    'service' => 'ElectroCityBD API',
    'version' => '1.0.0'
];

// Check database connection
try {
    $db = db();
    $stmt = $db->query("SELECT 1");
    $response['database'] = 'connected';
} catch (Exception $e) {
    $response['database'] = 'disconnected';
    $response['status'] = 'degraded';
}

http_response_code(200);
echo json_encode($response);
