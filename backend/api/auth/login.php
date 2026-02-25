<?php
header('Content-Type: application/json');
require_once __DIR__ . '/../bootstrap.php';
require_once __DIR__ . '/../../config/cors.php';
require_once __DIR__ . '/../../util/JWT.php';

$db = db();

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    
    $email = $data['email'] ?? '';
    $password = $data['password'] ?? '';
    
    if (empty($email) || empty($password)) {
        http_response_code(400);
        echo json_encode(['message' => 'Email and password required']);
        exit;
    }
    
    // Check if it's admin login attempt (based on email pattern or specific check)
    $isAdminAttempt = strpos($email, 'admin') !== false || $email === 'ahnaf@electrocitybd.com';
    
    $query = "SELECT user_id, full_name, last_name, email, password, phone_number, address, gender, role 
              FROM users WHERE email = :email";
    
    $stmt = $db->prepare($query);
    $stmt->bindParam(':email', $email);
    $stmt->execute();
    
    if ($stmt->rowCount() === 0) {
        http_response_code(401);
        echo json_encode(['message' => 'Invalid email or password']);
        exit;
    }
    
    $user = $stmt->fetch(PDO::FETCH_ASSOC);
    
    // Verify password (supports plaintext or existing bcrypt)
    if ($password !== $user['password'] && !password_verify($password, $user['password'])) {
        http_response_code(401);
        echo json_encode(['message' => 'Invalid email or password']);
        exit;
    }
    
    // For admin login, verify role is admin
    if ($isAdminAttempt && $user['role'] !== 'admin') {
        http_response_code(403);
        echo json_encode(['message' => 'Access denied. Admin only.']);
        exit;
    }
    
    $token = JWT::generate([
        'user_id' => (int)$user['user_id'],
        'email' => $user['email'],
        'role' => $user['role'],
        'exp' => time() + (7 * 24 * 60 * 60)
    ]);
    
    // Return user data (without password)
    unset($user['password']);
    
    echo json_encode([
        'token' => $token,
        'user' => [
            'user_id' => $user['user_id'],
            'firstName' => $user['full_name'],
            'lastName' => $user['last_name'],
            'email' => $user['email'],
            'phone' => $user['phone_number'],
            'gender' => $user['gender'],
            'role' => $user['role']
        ]
    ]);
    
} else {
    http_response_code(405);
    echo json_encode(['message' => 'Method not allowed']);
}
?>
