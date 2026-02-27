<?php
header('Content-Type: application/json');
require_once __DIR__ . '/bootstrap.php';
require_once __DIR__ . '/../config/cors.php';

$db = db();
$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';

function get_setting(PDO $db, string $key, $default) {
    $stmt = $db->prepare('SELECT setting_value FROM site_settings WHERE setting_key = ?');
    $stmt->execute([$key]);
    $row = $stmt->fetch();
    if (!$row || !isset($row['setting_value'])) return $default;
    $val = json_decode($row['setting_value'], true);
    return $val !== null ? $val : $default;
}

function set_setting(PDO $db, string $key, $value) {
    $json = json_encode($value, JSON_UNESCAPED_UNICODE);
    $stmt = $db->prepare('INSERT INTO site_settings (setting_key, setting_value) VALUES (?, ?) ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value)');
    $stmt->execute([$key, $json]);
}

if ($method === 'OPTIONS') {
    http_response_code(200);
    echo json_encode(['ok' => true]);
    exit;
}

if ($method === 'GET') {
    $hero = get_setting($db, 'banners_hero', []);
    $mid = get_setting($db, 'banners_mid', []);
    $sidebar = get_setting($db, 'banners_sidebar', ['title'=>'FLASH SALE','subtitle'=>'Up to 40% Off on Earbuds','buttonText'=>'VIEW ALL']);
    echo json_encode([
        'hero' => $hero,
        'mid' => $mid,
        'sidebar' => $sidebar,
    ]);
    exit;
}

if ($method === 'PUT' || $method === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    if (!is_array($data)) $data = [];
    try {
        if (isset($data['hero'])) {
            $hero = is_array($data['hero']) ? $data['hero'] : [];
            set_setting($db, 'banners_hero', array_values($hero));
        }
        if (isset($data['mid'])) {
            $mid = is_array($data['mid']) ? $data['mid'] : [];
            set_setting($db, 'banners_mid', array_values($mid));
        }
        if (isset($data['sidebar'])) {
            $sidebar = is_array($data['sidebar']) ? $data['sidebar'] : [];
            set_setting($db, 'banners_sidebar', $sidebar);
        }
        echo json_encode(['message' => 'Saved']);
    } catch (Throwable $e) {
        http_response_code(500);
        echo json_encode(['message' => 'Save failed']);
    }
    exit;
}

http_response_code(405);
echo json_encode(['message' => 'Method not allowed']);
