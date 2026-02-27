<?php
require_once __DIR__ . '/../util/JWT.php';

class AuthMiddleware {
    
    public static function authenticate() {
        $headers = getallheaders();
        
        // Check both capitalized and lowercase versions
        $authHeader = $headers['Authorization'] ?? $headers['authorization'] ?? null;
        
        if (!$authHeader) {
            http_response_code(401);
            echo json_encode(['message' => 'No token provided']);
            exit;
        }
        
        $token = str_replace('Bearer ', '', $authHeader);
        
        $user_data = JWT::verify($token);
        
        if (!$user_data) {
            http_response_code(401);
            echo json_encode(['message' => 'Invalid or expired token']);
            exit;
        }
        
        return $user_data;
    }
    
    public static function authenticateAdmin() {
        $user_data = self::authenticate();
        
        if (!isset($user_data['role']) || $user_data['role'] !== 'admin') {
            http_response_code(403);
            echo json_encode(['message' => 'Admin access required']);
            exit;
        }
        
        return $user_data;
    }
}
?>
