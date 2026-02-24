<?php
// PUT /api/auth/change-password
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

if ($_SERVER['REQUEST_METHOD'] !== 'PUT') {
    http_response_code(405);
    echo json_encode(['error' => 'Method Not Allowed']);
    exit;
}

$userId = $payload['userId'];
$body = getRequestBody();
$currentPassword = $body['currentPassword'] ?? '';
$newPassword = $body['newPassword'] ?? '';

if (!$currentPassword || !$newPassword) {
    http_response_code(400);
    echo json_encode(['error' => 'currentPassword and newPassword are required.']);
    exit;
}

try {
    $stmt = $pdo->prepare('SELECT password FROM users WHERE user_id = ?');
    $stmt->execute([$userId]);
    $row = $stmt->fetch();
    if (!$row) {
        http_response_code(404);
        echo json_encode(['error' => 'User not found.']);
        exit;
    }

    if (!password_verify($currentPassword, $row['password'])) {
        http_response_code(401);
        echo json_encode(['error' => 'Current password is incorrect.']);
        exit;
    }

    $hashed = password_hash($newPassword, PASSWORD_BCRYPT);
    $stmtUp = $pdo->prepare('UPDATE users SET password = ? WHERE user_id = ?');
    $stmtUp->execute([$hashed, $userId]);

    echo json_encode(['message' => 'Password changed successfully.']);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Server error: ' . $e->getMessage()]);
}
?>
