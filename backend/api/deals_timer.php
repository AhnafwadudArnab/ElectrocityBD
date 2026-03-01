<?php
header('Content-Type: application/json');
require_once __DIR__ . '/bootstrap.php';
require_once __DIR__ . '/../config/cors.php';
require_once __DIR__ . '/../middleware/authmiddleware.php';

$db = db();
$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';

if ($method === 'OPTIONS') {
    http_response_code(200);
    echo json_encode(['ok' => true]);
    exit;
}

if ($method === 'GET') {
    try {
        // Get current timer configuration
        $stmt = $db->prepare('
            SELECT days, hours, minutes, seconds, is_active, updated_at
            FROM deals_timer
            WHERE timer_id = 1
        ');
        $stmt->execute();
        $timer = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if (!$timer) {
            // Return default if not found
            $timer = [
                'days' => 3,
                'hours' => 11,
                'minutes' => 15,
                'seconds' => 0,
                'is_active' => true
            ];
        }
        
        echo json_encode([
            'success' => true,
            'timer' => $timer
        ]);
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode([
            'success' => false,
            'error' => 'Failed to fetch timer'
        ]);
    }
    exit;
}

if ($method === 'PUT' || $method === 'POST') {
    // Admin only
    try {
        $admin = AuthMiddleware::authenticateAdmin();
    } catch (Exception $e) {
        http_response_code(401);
        echo json_encode(['error' => 'Unauthorized']);
        exit;
    }
    
    $data = json_decode(file_get_contents('php://input'), true);
    
    if (!is_array($data)) {
        http_response_code(400);
        echo json_encode(['error' => 'Invalid request data']);
        exit;
    }
    
    try {
        $days = isset($data['days']) ? (int)$data['days'] : 3;
        $hours = isset($data['hours']) ? (int)$data['hours'] : 11;
        $minutes = isset($data['minutes']) ? (int)$data['minutes'] : 15;
        $seconds = isset($data['seconds']) ? (int)$data['seconds'] : 0;
        $is_active = isset($data['is_active']) ? (bool)$data['is_active'] : true;
        
        // Update or insert timer
        $stmt = $db->prepare('
            INSERT INTO deals_timer (timer_id, days, hours, minutes, seconds, is_active)
            VALUES (1, :days, :hours, :minutes, :seconds, :is_active)
            ON DUPLICATE KEY UPDATE
                days = VALUES(days),
                hours = VALUES(hours),
                minutes = VALUES(minutes),
                seconds = VALUES(seconds),
                is_active = VALUES(is_active)
        ');
        
        $stmt->execute([
            ':days' => $days,
            ':hours' => $hours,
            ':minutes' => $minutes,
            ':seconds' => $seconds,
            ':is_active' => $is_active ? 1 : 0
        ]);
        
        echo json_encode([
            'success' => true,
            'message' => 'Timer updated successfully',
            'timer' => [
                'days' => $days,
                'hours' => $hours,
                'minutes' => $minutes,
                'seconds' => $seconds,
                'is_active' => $is_active
            ]
        ]);
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode([
            'success' => false,
            'error' => 'Failed to update timer: ' . $e->getMessage()
        ]);
    }
    exit;
}

http_response_code(405);
echo json_encode(['error' => 'Method not allowed']);
