<?php
// Simple test file to debug password reset
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

echo json_encode([
    'status' => 'API is reachable',
    'endpoint' => '/api/test_password_reset.php',
    'timestamp' => date('Y-m-d H:i:s')
]);
?>
