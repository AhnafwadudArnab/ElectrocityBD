<?php
// POST /api/auth/register
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Method Not Allowed']);
    exit;
}

$body = getRequestBody();
$firstName = $body['firstName'] ?? '';
$lastName = $body['lastName'] ?? '';
$email = $body['email'] ?? '';
$password = $body['password'] ?? '';
$phone = $body['phone'] ?? '';
$gender = $body['gender'] ?? 'Male';

if (!$firstName || !$email || !$password) {
    http_response_code(400);
    echo json_encode(['error' => 'firstName, email, and password are required.']);
    exit;
}

try {
    // Check if email already exists
    $stmt = $pdo->prepare('SELECT user_id FROM users WHERE email = ?');
    $stmt->execute([$email]);
    if ($stmt->fetch()) {
        http_response_code(409);
        echo json_encode(['error' => 'Email already registered.']);
        exit;
    }

    // Hash password
    $hashed = password_hash($password, PASSWORD_BCRYPT);

    // Insert user
    $stmt = $pdo->prepare('INSERT INTO users (full_name, last_name, email, password, phone_number, gender, role) VALUES (?, ?, ?, ?, ?, ?, "customer")');
    $stmt->execute([$firstName, $lastName, $email, $hashed, $phone, $gender]);
    $userId = $pdo->lastInsertId();

    // Insert user profile
    $stmt = $pdo->prepare('INSERT INTO user_profile (user_id, full_name, last_name, phone_number, address, gender) VALUES (?, ?, ?, ?, "", ?) ON DUPLICATE KEY UPDATE full_name = VALUES(full_name), last_name = VALUES(last_name), phone_number = VALUES(phone_number), gender = VALUES(gender)');
    $stmt->execute([$userId, $firstName, $lastName, $phone, $gender]);

    // Sign JWT
    $token = JWTHelper::sign([
        'userId' => (int)$userId,
        'email' => $email,
        'role' => 'customer',
        'exp' => time() + (7 * 24 * 60 * 60) // 7 days
    ]);

    http_response_code(201);
    echo json_encode([
        'message' => 'Registration successful',
        'token' => $token,
        'user' => [
            'userId' => (int)$userId,
            'firstName' => $firstName,
            'lastName' => $lastName,
            'email' => $email,
            'phone' => $phone,
            'address' => '',
            'gender' => $gender,
            'role' => 'customer',
        ]
    ]);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Server error: ' . $e->getMessage()]);
}
?>
