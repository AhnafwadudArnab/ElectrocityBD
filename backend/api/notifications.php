<?php
header('Content-Type: application/json');
require_once __DIR__ . '/bootstrap.php';
require_once __DIR__ . '/../config/cors.php';

$db = db();
$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';

if ($method === 'OPTIONS') {
    http_response_code(200);
    echo json_encode(['ok' => true]);
    exit;
}

// Get user notifications
if ($method === 'GET') {
    $token = getBearerToken();
    if (!$token) {
        http_response_code(401);
        echo json_encode(['message' => 'Unauthorized']);
        exit;
    }
    
    $decoded = JWT::verify($token);
    if (!$decoded) {
        http_response_code(401);
        echo json_encode(['message' => 'Invalid token']);
        exit;
    }
    
    $userId = $decoded['user_id'];
    
    // Get user's notifications
    $stmt = $db->prepare('
        SELECT * FROM notifications 
        WHERE user_id = ? OR user_id IS NULL
        ORDER BY created_at DESC
        LIMIT 50
    ');
    $stmt->execute([$userId]);
    $notifications = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode(['notifications' => $notifications]);
    exit;
}

// Create notification (Admin only)
if ($method === 'POST') {
    $token = getBearerToken();
    if (!$token) {
        http_response_code(401);
        echo json_encode(['message' => 'Unauthorized']);
        exit;
    }
    
    $decoded = JWT::verify($token);
    if (!$decoded || $decoded['role'] !== 'admin') {
        http_response_code(403);
        echo json_encode(['message' => 'Admin access required']);
        exit;
    }
    
    $data = json_decode(file_get_contents('php://input'), true);
    
    if (!isset($data['title']) || !isset($data['message'])) {
        http_response_code(400);
        echo json_encode(['message' => 'Title and message required']);
        exit;
    }
    
    $userId = $data['user_id'] ?? null; // null = broadcast to all
    $type = $data['type'] ?? 'general';
    $relatedId = $data['related_id'] ?? null;
    
    $stmt = $db->prepare('
        INSERT INTO notifications (user_id, type, title, message, related_id, created_at)
        VALUES (?, ?, ?, ?, ?, NOW())
    ');
    $stmt->execute([
        $userId,
        $type,
        $data['title'],
        $data['message'],
        $relatedId
    ]);
    
    $notificationId = $db->lastInsertId();
    
    echo json_encode([
        'message' => 'Notification created',
        'notification_id' => $notificationId
    ]);
    exit;
}

// Mark notification as read
if ($method === 'PUT') {
    $token = getBearerToken();
    if (!$token) {
        http_response_code(401);
        echo json_encode(['message' => 'Unauthorized']);
        exit;
    }
    
    $decoded = JWT::verify($token);
    if (!$decoded) {
        http_response_code(401);
        echo json_encode(['message' => 'Invalid token']);
        exit;
    }
    
    $notificationId = $_GET['id'] ?? null;
    if (!$notificationId) {
        http_response_code(400);
        echo json_encode(['message' => 'Notification ID required']);
        exit;
    }
    
    $stmt = $db->prepare('
        UPDATE notifications 
        SET is_read = 1, read_at = NOW()
        WHERE notification_id = ? AND (user_id = ? OR user_id IS NULL)
    ');
    $stmt->execute([$notificationId, $decoded['user_id']]);
    
    echo json_encode(['message' => 'Notification marked as read']);
    exit;
}

// Delete notification
if ($method === 'DELETE') {
    $token = getBearerToken();
    if (!$token) {
        http_response_code(401);
        echo json_encode(['message' => 'Unauthorized']);
        exit;
    }
    
    $decoded = JWT::verify($token);
    if (!$decoded) {
        http_response_code(401);
        echo json_encode(['message' => 'Invalid token']);
        exit;
    }
    
    $notificationId = $_GET['id'] ?? null;
    if (!$notificationId) {
        http_response_code(400);
        echo json_encode(['message' => 'Notification ID required']);
        exit;
    }
    
    // Admin can delete any, users can only delete their own
    if ($decoded['role'] === 'admin') {
        $stmt = $db->prepare('DELETE FROM notifications WHERE notification_id = ?');
        $stmt->execute([$notificationId]);
    } else {
        $stmt = $db->prepare('DELETE FROM notifications WHERE notification_id = ? AND user_id = ?');
        $stmt->execute([$notificationId, $decoded['user_id']]);
    }
    
    echo json_encode(['message' => 'Notification deleted']);
    exit;
}

http_response_code(405);
echo json_encode(['message' => 'Method not allowed']);
