<?php
require_once __DIR__ . '/../util/JWT.php';
require_once __DIR__ . '/../util/ApiResponse.php';

class AuthMiddleware {
    
    public static function authenticate() {
        $headers = getallheaders();
        
        // Check both capitalized and lowercase versions
        $authHeader = $headers['Authorization'] ?? $headers['authorization'] ?? null;
        
        if (!$authHeader) {
            ApiResponse::unauthorized('Authentication required', 'No token provided');
        }
        
        $token = str_replace('Bearer ', '', $authHeader);
        
        $user_data = JWT::verify($token);
        
        if (!$user_data) {
            ApiResponse::unauthorized('Authentication required', 'Invalid or expired token');
        }
        
        return $user_data;
    }
    
    public static function authenticateAdmin() {
        $user_data = self::authenticate();
        
        if (!isset($user_data['role']) || $user_data['role'] !== 'admin') {
            ApiResponse::forbidden('Access denied', 'Admin privileges required');
        }
        
        return $user_data;
    }
}
?>
