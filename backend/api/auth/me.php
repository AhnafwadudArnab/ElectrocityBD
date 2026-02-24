<?php
// /api/auth/me
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

$userId = $payload['userId'];
$method = $_SERVER['REQUEST_METHOD'];

try {
    if ($method === 'GET') {
        $stmt = $pdo->prepare('
            SELECT 
                u.user_id, u.full_name, u.last_name, u.email, 
                COALESCE(up.phone_number, u.phone_number) AS phone_number,
                COALESCE(up.address, u.address) AS address,
                COALESCE(up.gender, u.gender) AS gender,
                u.role, u.created_at
            FROM users u
            LEFT JOIN user_profile up ON up.user_id = u.user_id
            WHERE u.user_id = ?
        ');
        $stmt->execute([$userId]);
        $user = $stmt->fetch();

        if (!$user) {
            http_response_code(404);
            echo json_encode(['error' => 'User not found.']);
            exit;
        }

        echo json_encode([
            'user' => [
                'userId' => (int)$user['user_id'],
                'firstName' => $user['full_name'],
                'lastName' => $user['last_name'],
                'email' => $user['email'],
                'phone' => $user['phone_number'],
                'address' => $user['address'],
                'gender' => $user['gender'],
                'role' => $user['role'],
                'createdAt' => $user['created_at'],
            ]
        ]);
    } else if ($method === 'PUT') {
        $body = getRequestBody();
        $firstName = $body['firstName'] ?? $body['full_name'] ?? null;
        $lastName = $body['lastName'] ?? $body['last_name'] ?? null;
        $phone = $body['phone'] ?? $body['phone_number'] ?? null;
        $address = $body['address'] ?? null;
        $gender = $body['gender'] ?? null;

        // Prepare dynamic update query
        $updates = [];
        $params = [];

        if ($firstName !== null) {
            $updates[] = "full_name = ?";
            $params[] = $firstName;
        }
        if ($lastName !== null) {
            $updates[] = "last_name = ?";
            $params[] = $lastName;
        }
        if ($phone !== null) {
            $updates[] = "phone_number = ?";
            $params[] = $phone;
        }
        if ($address !== null) {
            $updates[] = "address = ?";
            $params[] = $address;
        }
        if ($gender !== null) {
            $updates[] = "gender = ?";
            $params[] = $gender;
        }

        if (empty($updates)) {
            http_response_code(400);
            echo json_encode(['error' => 'No fields to update.']);
            exit;
        }

        $params[] = $userId;
        $sql = "UPDATE users SET " . implode(', ', $updates) . " WHERE user_id = ?";
        $stmt = $pdo->prepare($sql);
        $stmt->execute($params);

        // Upsert user_profile to ensure row exists
        $stmtProfileUpsert = $pdo->prepare("
            INSERT INTO user_profile (user_id, full_name, last_name, phone_number, address, gender)
            VALUES (?, ?, ?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE
                full_name = VALUES(full_name),
                last_name = VALUES(last_name),
                phone_number = VALUES(phone_number),
                address = VALUES(address),
                gender = VALUES(gender)
        ");
        $stmtProfileUpsert->execute([
            $userId,
            $firstName ?? '',
            $lastName ?? '',
            $phone ?? '',
            $address ?? '',
            $gender ?? 'Male'
        ]);

        // Return updated user payload
        $stmt2 = $pdo->prepare('SELECT user_id, full_name, last_name, email, phone_number, address, gender, role, created_at FROM users WHERE user_id = ?');
        $stmt2->execute([$userId]);
        $user = $stmt2->fetch();
        echo json_encode([
            'message' => 'Profile updated successfully.',
            'user' => [
                'userId' => (int)$user['user_id'],
                'firstName' => $user['full_name'],
                'lastName' => $user['last_name'],
                'email' => $user['email'],
                'phone' => $user['phone_number'],
                'address' => $user['address'],
                'gender' => $user['gender'],
                'role' => $user['role'],
                'createdAt' => $user['created_at'],
            ]
        ]);
    } else {
        http_response_code(405);
        echo json_encode(['error' => 'Method Not Allowed']);
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Server error: ' . $e->getMessage()]);
}
