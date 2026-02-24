<?php
// POST /api/auth/admin-login
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Method Not Allowed']);
    exit;
}

$body = getRequestBody();
$username = $body['username'] ?? '';
$password = $body['password'] ?? '';

if (!$username || !$password) {
    http_response_code(400);
    echo json_encode(['error' => 'Username and password are required.']);
    exit;
}

try {
    $stmt = $pdo->prepare("SELECT * FROM users WHERE (LOWER(TRIM(email)) = LOWER(TRIM(?)) OR LOWER(TRIM(full_name)) = LOWER(TRIM(?))) AND role = 'admin'");
    $stmt->execute([$username, $username]);
    $admin = $stmt->fetch();

    if (!$admin || !password_verify($password, $admin['password'])) {
        http_response_code(401);
        echo json_encode(['error' => 'Invalid admin credentials.']);
        exit;
    }

    $token = JWTHelper::sign([
        'userId' => (int)$admin['user_id'],
        'email' => $admin['email'],
        'role' => 'admin',
        'exp' => time() + (7 * 24 * 60 * 60) // 7 days
    ]);

    echo json_encode([
        'message' => 'Admin login successful',
        'token' => $token,
        'user' => [
            'userId' => (int)$admin['user_id'],
            'firstName' => $admin['full_name'],
            'lastName' => $admin['last_name'],
            'email' => $admin['email'],
            'role' => 'admin',
        ]
    ]);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Server error: ' . $e->getMessage()]);
}
?>
