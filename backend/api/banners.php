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

if ($method === 'GET') {
    try {
        // Get banners from database
        $stmt = $db->prepare('
            SELECT banner_type, image_url, link_url, title, description, button_text, display_order
            FROM banners
            WHERE active = TRUE
            AND (start_date IS NULL OR start_date <= CURDATE())
            AND (end_date IS NULL OR end_date >= CURDATE())
            ORDER BY banner_type, display_order
        ');
        $stmt->execute();
        $banners = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        // Group by banner type
        $hero = [];
        $mid = [];
        $sidebar = [];
        
        foreach ($banners as $banner) {
            $item = [
                'img' => $banner['image_url'],
                'link' => $banner['link_url'],
                'title' => $banner['title'],
                'description' => $banner['description'],
                'buttonText' => $banner['button_text']
            ];
            
            switch ($banner['banner_type']) {
                case 'hero':
                    $hero[] = $item;
                    break;
                case 'mid':
                    $mid[] = $item;
                    break;
                case 'sidebar':
                    $sidebar[] = $item;
                    break;
            }
        }
        
        echo json_encode([
            'hero' => $hero,
            'mid' => $mid,
            'sidebar' => $sidebar,
        ]);
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(['error' => 'Failed to fetch banners']);
    }
    exit;
}

if ($method === 'PUT' || $method === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    if (!is_array($data)) $data = [];
    try {
        // Admin can update banners here if needed
        echo json_encode(['message' => 'Banners update not implemented yet']);
    } catch (Throwable $e) {
        http_response_code(500);
        echo json_encode(['message' => 'Save failed']);
    }
    exit;
}

http_response_code(405);
echo json_encode(['message' => 'Method not allowed']);

