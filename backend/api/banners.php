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
    require_once __DIR__ . '/../middleware/authmiddleware.php';
    $admin = AuthMiddleware::authenticateAdmin();
    
    $data = json_decode(file_get_contents('php://input'), true);
    if (!is_array($data)) $data = [];
    
    try {
        // Clear existing banners if updating all
        if (isset($data['clearAll']) && $data['clearAll']) {
            $db->exec('DELETE FROM banners');
        }
        
        // Update hero banners
        if (isset($data['hero']) && is_array($data['hero'])) {
            // Delete existing hero banners
            $db->exec("DELETE FROM banners WHERE banner_type = 'hero'");
            
            // Insert new hero banners
            $stmt = $db->prepare('
                INSERT INTO banners (banner_type, image_url, link_url, title, description, button_text, display_order, active)
                VALUES (?, ?, ?, ?, ?, ?, ?, TRUE)
            ');
            
            foreach ($data['hero'] as $index => $banner) {
                $stmt->execute([
                    'hero',
                    $banner['image'] ?? $banner['img'] ?? '',
                    $banner['link'] ?? '',
                    $banner['label'] ?? $banner['title'] ?? '',
                    $banner['description'] ?? '',
                    $banner['buttonText'] ?? '',
                    $index
                ]);
            }
        }
        
        // Update mid banners
        if (isset($data['mid']) && is_array($data['mid'])) {
            $db->exec("DELETE FROM banners WHERE banner_type = 'mid'");
            
            $stmt = $db->prepare('
                INSERT INTO banners (banner_type, image_url, link_url, title, description, button_text, display_order, active)
                VALUES (?, ?, ?, ?, ?, ?, ?, TRUE)
            ');
            
            foreach ($data['mid'] as $index => $banner) {
                $stmt->execute([
                    'mid',
                    $banner['img'] ?? $banner['image'] ?? '',
                    $banner['link'] ?? '',
                    $banner['title'] ?? '',
                    $banner['description'] ?? '',
                    $banner['buttonText'] ?? '',
                    $index
                ]);
            }
        }
        
        // Update sidebar promo
        if (isset($data['sidebar']) && is_array($data['sidebar'])) {
            $db->exec("DELETE FROM banners WHERE banner_type = 'sidebar'");
            
            $stmt = $db->prepare('
                INSERT INTO banners (banner_type, image_url, link_url, title, description, button_text, display_order, active)
                VALUES (?, ?, ?, ?, ?, ?, ?, TRUE)
            ');
            
            $stmt->execute([
                'sidebar',
                $data['sidebar']['image'] ?? $data['sidebar']['img'] ?? '',
                $data['sidebar']['link'] ?? '',
                $data['sidebar']['title'] ?? 'FLASH SALE',
                $data['sidebar']['subtitle'] ?? $data['sidebar']['description'] ?? '',
                $data['sidebar']['buttonText'] ?? 'VIEW ALL',
                0
            ]);
        }
        
        echo json_encode(['success' => true, 'message' => 'Banners updated successfully']);
    } catch (Throwable $e) {
        error_log("Banner save error: " . $e->getMessage());
        http_response_code(500);
        echo json_encode(['message' => 'Save failed: ' . $e->getMessage()]);
    }
    exit;
}

http_response_code(405);
echo json_encode(['message' => 'Method not allowed']);

