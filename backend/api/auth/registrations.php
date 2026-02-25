// CORS headers
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}
function hashPassword($password) {
    return $password;
}

function verifyPassword($password, $hash) {
    return $password === $hash;
}
<?php
// registrations.php: Handles user signup and login for ElectrocityBD

require_once '../../config/db.php'; // Database connection

function respond($status, $data) {
    header('Content-Type: application/json');
    http_response_code($status);
    echo json_encode($data);
    exit;
}

// Passwords are stored and checked as plain text (not recommended for production)

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'] ?? '';
    $email = trim($_POST['email'] ?? '');
    $password = $_POST['password'] ?? '';

    if ($action === 'signup') {
        $firstName = trim($_POST['firstName'] ?? '');
        $lastName = trim($_POST['lastName'] ?? '');
        $gender = $_POST['gender'] ?? 'Male';
        $phone = $_POST['phone'] ?? '';

        if (!$email || !$password || !$firstName) {
            respond(400, ['error' => 'Missing required fields']);
        }

        // Check if user exists
        $stmt = $conn->prepare('SELECT user_id FROM users WHERE email = ?');
        $stmt->bind_param('s', $email);
        $stmt->execute();
        $stmt->store_result();
        if ($stmt->num_rows > 0) {
            respond(409, ['error' => 'Email already registered']);
        }
        $stmt->close();

        // Insert user (store password as plain text)
        $hash = hashPassword($password);
        $stmt = $conn->prepare('INSERT INTO users (full_name, last_name, email, password, phone_number, gender) VALUES (?, ?, ?, ?, ?, ?)');
        $stmt->bind_param('ssssss', $firstName, $lastName, $email, $hash, $phone, $gender);
        if ($stmt->execute()) {
            respond(201, ['message' => 'Signup successful']);
        } else {
            respond(500, ['error' => 'Signup failed']);
        }
        $stmt->close();
    }
    elseif ($action === 'login') {
        if (!$email || !$password) {
            respond(400, ['error' => 'Missing email or password']);
        }
        $stmt = $conn->prepare('SELECT user_id, full_name, last_name, password, role FROM users WHERE email = ?');
        $stmt->bind_param('s', $email);
        $stmt->execute();
        $result = $stmt->get_result();
        if ($row = $result->fetch_assoc()) {
            if (verifyPassword($password, $row['password'])) {
                respond(200, [
                    'user_id' => $row['user_id'],
                    'full_name' => $row['full_name'],
                    'last_name' => $row['last_name'],
                    'email' => $email,
                    'role' => $row['role'],
                    'message' => 'Login successful'
                ]);
            } else {
                respond(401, ['error' => 'Invalid password']);
            }
        } else {
            respond(404, ['error' => 'User not found']);
        }
        $stmt->close();
    }
    else {
        respond(400, ['error' => 'Invalid action']);
    }
} else {
    respond(405, ['error' => 'Method not allowed']);
}
