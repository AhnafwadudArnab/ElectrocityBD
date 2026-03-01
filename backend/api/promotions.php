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
        // Get active promotions from database
        $stmt = $db->prepare('
            SELECT promotion_id, title, description, discount_percent, start_date, end_date
            FROM promotions
            WHERE active = TRUE
            AND (start_date IS NULL OR start_date <= CURDATE())
            AND (end_date IS NULL OR end_date >= CURDATE())
            ORDER BY discount_percent DESC
        ');
        $stmt->execute();
        $promotions = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        // Format for frontend (offers_upto_90 section)
        $offers = [];
        $images = [
            'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=900&q=60',
            'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=900&q=60',
            'https://images.unsplash.com/photo-1493666438817-866a91353ca9?auto=format&fit=crop&w=900&q=60',
            'https://images.unsplash.com/photo-1521334884684-d80222895322?auto=format&fit=crop&w=900&q=60',
        ];
        
        foreach ($promotions as $index => $promo) {
            $offers[] = [
                'label' => $promo['title'],
                'image' => $images[$index % count($images)],
                'discount' => $promo['discount_percent'] . '% OFF',
                'description' => $promo['description']
            ];
        }
        
        echo json_encode([
            'promotions' => $promotions,
            'offers' => $offers
        ]);
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(['error' => 'Failed to fetch promotions']);
    }
    exit;
}

http_response_code(405);
echo json_encode(['message' => 'Method not allowed']);
