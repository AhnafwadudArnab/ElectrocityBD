<?php
/**
 * Password Reset API Endpoint
 * Clean architecture implementation with dependency injection
 */

// Define SECURE_ACCESS constant before including files
define('SECURE_ACCESS', true);

// Set headers
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

// Handle preflight requests
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Load dependencies
require_once __DIR__ . '/bootstrap.php';
require_once __DIR__ . '/../models/password_reset.php';
require_once __DIR__ . '/../services/EmailServiceInterface.php';
require_once __DIR__ . '/../services/EmailServiceFactory.php';
require_once __DIR__ . '/../controllers/PasswordResetController.php';

try {
    // Only allow POST requests
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        http_response_code(405);
        echo json_encode(['success' => false, 'message' => 'Method not allowed']);
        exit;
    }
    
    // Get database connection
    $conn = db();
    
    // Build configuration array from environment
    $config = [
        'smtp' => [
            'host' => getenv('SMTP_HOST') ?: 'smtp.gmail.com',
            'port' => (int)(getenv('SMTP_PORT') ?: 587),
            'secure' => getenv('SMTP_SECURE') ?: 'tls',
            'username' => getenv('SMTP_USERNAME') ?: '',
            'password' => getenv('SMTP_PASSWORD') ?: ''
        ],
        'mail' => [
            'from_address' => getenv('MAIL_FROM_ADDRESS') ?: 'noreply@electrocitybd.com',
            'from_name' => getenv('MAIL_FROM_NAME') ?: 'ElectroCityBD'
        ]
    ];
    
    // Create dependencies using factory pattern
    $passwordResetModel = new PasswordReset($conn);
    $emailServiceFactory = EmailServiceFactory::getInstance($config);
    $emailService = $emailServiceFactory->createEmailService();
    
    // Create controller with dependency injection
    $controller = new PasswordResetController($passwordResetModel, $emailService);
    
    // Get request input
    $input = json_decode(file_get_contents('php://input'), true);
    $action = $input['action'] ?? '';
    
    // Route to appropriate controller method
    switch ($action) {
        case 'request_reset':
            $result = $controller->requestReset($input);
            break;
            
        case 'verify_token':
            $result = $controller->verifyToken($input);
            break;
            
        case 'reset_password':
            $result = $controller->resetPassword($input);
            break;
            
        default:
            $result = [
                'success' => false,
                'message' => 'Invalid action',
                'http_code' => 400
            ];
            break;
    }
    
    // Send response
    $httpCode = $result['http_code'] ?? 200;
    unset($result['http_code']);
    
    http_response_code($httpCode);
    echo json_encode($result);
    
} catch (RuntimeException $e) {
    // Handle email service not available
    http_response_code(503);
    echo json_encode([
        'success' => false,
        'message' => 'Service temporarily unavailable. Please try again later.'
    ]);
    error_log('Password Reset API Error: ' . $e->getMessage());
    
} catch (Exception $e) {
    // Handle other errors
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'Server error occurred'
    ]);
    error_log('Password Reset API Error: ' . $e->getMessage());
}
?>
