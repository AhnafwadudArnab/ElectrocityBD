<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

require_once __DIR__ . '/bootstrap.php';
require_once __DIR__ . '/../models/password_reset.php';

$passwordReset = new PasswordReset($conn);
$method = $_SERVER['REQUEST_METHOD'];
$input = json_decode(file_get_contents('php://input'), true);

try {
    if ($method !== 'POST') {
        http_response_code(405);
        echo json_encode(['success' => false, 'message' => 'Method not allowed']);
        exit;
    }
    
    $action = $input['action'] ?? '';
    
    switch ($action) {
        case 'request_reset':
            // Request password reset
            $email = $input['email'] ?? '';
            
            if (empty($email)) {
                http_response_code(400);
                echo json_encode(['success' => false, 'message' => 'Email is required']);
                exit;
            }
            
            if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
                http_response_code(400);
                echo json_encode(['success' => false, 'message' => 'Invalid email format']);
                exit;
            }
            
            $result = $passwordReset->createResetToken($email);
            
            // For security, always return success even if email doesn't exist
            // But include token only if email exists
            if ($result['success']) {
                echo json_encode([
                    'success' => true,
                    'message' => 'If this email exists, a reset link has been generated',
                    'token' => $result['token'], // In production, send this via email
                    'user_name' => $result['user_name'] ?? ''
                ]);
            } else {
                // Still return success to prevent email enumeration
                echo json_encode([
                    'success' => true,
                    'message' => 'If this email exists, a reset link has been generated'
                ]);
            }
            break;
            
        case 'verify_token':
            // Verify reset token
            $token = $input['token'] ?? '';
            
            if (empty($token)) {
                http_response_code(400);
                echo json_encode(['success' => false, 'message' => 'Token is required']);
                exit;
            }
            
            $result = $passwordReset->verifyToken($token);
            echo json_encode($result);
            break;
            
        case 'reset_password':
            // Reset password with token
            $token = $input['token'] ?? '';
            $newPassword = $input['new_password'] ?? '';
            
            if (empty($token) || empty($newPassword)) {
                http_response_code(400);
                echo json_encode(['success' => false, 'message' => 'Token and new password are required']);
                exit;
            }
            
            if (strlen($newPassword) < 4) {
                http_response_code(400);
                echo json_encode(['success' => false, 'message' => 'Password must be at least 4 characters']);
                exit;
            }
            
            $result = $passwordReset->resetPassword($token, $newPassword);
            echo json_encode($result);
            break;
            
        default:
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => 'Invalid action']);
            break;
    }
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'Server error: ' . $e->getMessage()
    ]);
}
?>
