<?php
// registrations.php: Handles user registration and login for ElectrocityBD

header('Content-Type: application/json');
require_once '../../config/db.php';

function respond($status, $message, $data = null) {
    echo json_encode([
        'status' => $status,
        'message' => $message,
        'data' => $data
    ]);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'] ?? '';
    $email = $_POST['email'] ?? '';
    $password = $_POST['password'] ?? '';
    $name = $_POST['name'] ?? '';

    if ($action === 'signup') {
        // Registration
        if (!$email || !$password || !$name) {
            respond('error', 'Missing required fields');
        }
        $hashed = password_hash($password, PASSWORD_BCRYPT);
        $stmt = $conn->prepare('INSERT INTO users (name, email, password) VALUES (?, ?, ?)');
        $stmt->bind_param('sss', $name, $email, $hashed);
        if ($stmt->execute()) {
            respond('success', 'User registered successfully');
        } else {
            respond('error', 'Registration failed: ' . $conn->error);
        }
    } elseif ($action === 'login') {
        // Login
        if (!$email || !$password) {
            respond('error', 'Missing required fields');
        }
        $stmt = $conn->prepare('SELECT id, name, email, password FROM users WHERE email = ?');
        $stmt->bind_param('s', $email);
        $stmt->execute();
        $result = $stmt->get_result();
        if ($row = $result->fetch_assoc()) {
            if (password_verify($password, $row['password'])) {
                respond('success', 'Login successful', [
                    'id' => $row['id'],
                    'name' => $row['name'],
                    'email' => $row['email']
                ]);
            } else {
                respond('error', 'Invalid password');
            }
        } else {
            respond('error', 'User not found');
        }
    } else {
        respond('error', 'Invalid action');
    }
} else {
    respond('error', 'Invalid request method');
}
