<?php
$token = getBearerToken();
if (!$token) {
    http_response_code(401);
    echo json_encode(['error' => 'No token provided.']);
    exit;
}
$payload = JWTHelper::verify($token);
if (!$payload) {
    http_response_code(401);
    echo json_encode(['error' => 'Invalid or expired token.']);
    exit;
}
try {
    $userId = (int)$payload['userId'];
    $stmt = $pdo->prepare('SELECT user_id, full_name, last_name, email, phone_number, address, gender, role, created_at FROM users WHERE user_id = ?');
    $stmt->execute([$userId]);
    $user = $stmt->fetch();
    if (!$user) {
        http_response_code(404);
        echo json_encode(['error' => 'User not found.']);
        exit;
    }
    $newToken = JWTHelper::sign([
        'userId' => (int)$user['user_id'],
        'email' => $user['email'],
        'role' => $user['role'],
        'exp' => time() + (7 * 24 * 60 * 60)
    ]);
    echo json_encode([
        'message' => 'Token refreshed',
        'token' => $newToken,
        'user' => [
            'userId' => (int)$user['user_id'],
            'firstName' => $user['full_name'],
            'lastName' => $user['last_name'],
            'email' => $user['email'],
            'phone' => $user['phone_number'],
            'address' => $user['address'],
            'gender' => $user['gender'],
            'role' => $user['role'],
            'createdAt' => $user['created_at']
        ]
    ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Server error: ' . $e->getMessage()]);
}
?>
