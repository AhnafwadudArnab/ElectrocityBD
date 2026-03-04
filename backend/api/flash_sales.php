<?php
require_once __DIR__ . '/bootstrap.php';

$db = db();
$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';

if ($method === 'OPTIONS') {
    http_response_code(200);
    exit;
}

switch ($method) {
    case 'GET':
        if (isset($_GET['active'])) {
            // Get currently active flash sale with timer info
            $stmt = $db->query("
                SELECT 
                    fs.*,
                    UNIX_TIMESTAMP(fs.start_time) as start_timestamp,
                    UNIX_TIMESTAMP(fs.end_time) as end_timestamp,
                    UNIX_TIMESTAMP(NOW()) as current_timestamp,
                    CASE 
                        WHEN NOW() < fs.start_time THEN 'upcoming'
                        WHEN NOW() BETWEEN fs.start_time AND fs.end_time THEN 'active'
                        ELSE 'ended'
                    END as status,
                    TIMESTAMPDIFF(SECOND, NOW(), fs.end_time) as seconds_remaining
                FROM flash_sales fs
                WHERE fs.active = 1 
                AND fs.end_time > NOW()
                ORDER BY fs.start_time ASC
                LIMIT 1
            ");
            $flashSale = $stmt->fetch(PDO::FETCH_ASSOC);
            
            if (!$flashSale) {
                echo json_encode([
                    'active' => false,
                    'message' => 'No active flash sale'
                ]);
                exit;
            }
            
            // Get products in flash sale with discount calculation
            $stmt = $db->prepare("
                SELECT 
                    p.*,
                    c.category_name,
                    b.brand_name,
                    fsp.flash_price,
                    fsp.display_order,
                    ROUND(((p.price - fsp.flash_price) / p.price) * 100) as discount_percent,
                    p.stock_quantity
                FROM flash_sale_products fsp
                INNER JOIN products p ON fsp.product_id = p.product_id
                LEFT JOIN categories c ON p.category_id = c.category_id
                LEFT JOIN brands b ON p.brand_id = b.brand_id
                WHERE fsp.flash_sale_id = ?
                AND p.stock_quantity > 0
                ORDER BY fsp.display_order ASC, fsp.created_at DESC
            ");
            $stmt->execute([$flashSale['flash_sale_id']]);
            $flashSale['products'] = $stmt->fetchAll(PDO::FETCH_ASSOC);
            $flashSale['active'] = true;
            
            echo json_encode($flashSale);
            
        } elseif (isset($_GET['id'])) {
            // Get single flash sale with products
            $id = (int)$_GET['id'];
            $stmt = $db->prepare("
                SELECT 
                    fs.*,
                    UNIX_TIMESTAMP(fs.start_time) as start_timestamp,
                    UNIX_TIMESTAMP(fs.end_time) as end_timestamp,
                    UNIX_TIMESTAMP(NOW()) as current_timestamp,
                    TIMESTAMPDIFF(SECOND, NOW(), fs.end_time) as seconds_remaining
                FROM flash_sales fs
                WHERE fs.flash_sale_id = ?
            ");
            $stmt->execute([$id]);
            $flashSale = $stmt->fetch(PDO::FETCH_ASSOC);
            
            if (!$flashSale) {
                http_response_code(404);
                echo json_encode(['error' => 'Flash sale not found']);
                exit;
            }
            
            // Get products in flash sale
            $stmt = $db->prepare("
                SELECT 
                    p.*,
                    c.category_name,
                    b.brand_name,
                    fsp.flash_price,
                    fsp.display_order,
                    ROUND(((p.price - fsp.flash_price) / p.price) * 100) as discount_percent
                FROM flash_sale_products fsp
                INNER JOIN products p ON fsp.product_id = p.product_id
                LEFT JOIN categories c ON p.category_id = c.category_id
                LEFT JOIN brands b ON p.brand_id = b.brand_id
                WHERE fsp.flash_sale_id = ?
                ORDER BY fsp.display_order ASC
            ");
            $stmt->execute([$id]);
            $flashSale['products'] = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            echo json_encode($flashSale);
            
        } else {
            // Get all flash sales (admin view)
            $stmt = $db->query("
                SELECT 
                    fs.*,
                    COUNT(fsp.product_id) as product_count,
                    CASE 
                        WHEN NOW() < fs.start_time THEN 'upcoming'
                        WHEN NOW() BETWEEN fs.start_time AND fs.end_time THEN 'active'
                        ELSE 'ended'
                    END as status
                FROM flash_sales fs
                LEFT JOIN flash_sale_products fsp ON fs.flash_sale_id = fsp.flash_sale_id
                GROUP BY fs.flash_sale_id
                ORDER BY fs.start_time DESC
            ");
            $flashSales = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            echo json_encode(['flash_sales' => $flashSales]);
        }
        break;
        
    case 'POST':
        // Admin only - create flash sale
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
        
        if (!isset($data['title']) || !isset($data['start_time']) || !isset($data['end_time'])) {
            http_response_code(400);
            echo json_encode(['message' => 'Title, start_time, and end_time required']);
            exit;
        }
        
        $stmt = $db->prepare("
            INSERT INTO flash_sales (title, start_time, end_time, active)
            VALUES (?, ?, ?, ?)
        ");
        $stmt->execute([
            $data['title'],
            $data['start_time'],
            $data['end_time'],
            $data['active'] ?? 1
        ]);
        $flashSaleId = $db->lastInsertId();
        
        // Add products to flash sale
        if (isset($data['products']) && is_array($data['products'])) {
            $stmt = $db->prepare("
                INSERT INTO flash_sale_products (flash_sale_id, product_id, flash_price, display_order)
                VALUES (?, ?, ?, ?)
            ");
            foreach ($data['products'] as $index => $product) {
                $stmt->execute([
                    $flashSaleId,
                    $product['product_id'],
                    $product['flash_price'],
                    $product['display_order'] ?? $index
                ]);
            }
        }
        
        http_response_code(201);
        echo json_encode([
            'message' => 'Flash sale created',
            'flash_sale_id' => $flashSaleId
        ]);
        break;
        
    case 'PUT':
        // Admin only - update flash sale
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
        
        if (!isset($_GET['id'])) {
            http_response_code(400);
            echo json_encode(['message' => 'Flash sale ID required']);
            exit;
        }
        
        $id = (int)$_GET['id'];
        $data = json_decode(file_get_contents('php://input'), true);
        
        $updates = [];
        $params = [];
        
        if (isset($data['title'])) {
            $updates[] = "title = ?";
            $params[] = $data['title'];
        }
        if (isset($data['start_time'])) {
            $updates[] = "start_time = ?";
            $params[] = $data['start_time'];
        }
        if (isset($data['end_time'])) {
            $updates[] = "end_time = ?";
            $params[] = $data['end_time'];
        }
        if (isset($data['active'])) {
            $updates[] = "active = ?";
            $params[] = (int)$data['active'];
        }
        
        if (empty($updates)) {
            http_response_code(400);
            echo json_encode(['message' => 'No fields to update']);
            exit;
        }
        
        $params[] = $id;
        $sql = "UPDATE flash_sales SET " . implode(', ', $updates) . " WHERE flash_sale_id = ?";
        
        $stmt = $db->prepare($sql);
        $stmt->execute($params);
        
        echo json_encode(['message' => 'Flash sale updated']);
        break;
        
    case 'DELETE':
        // Admin only - delete flash sale
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
        
        if (!isset($_GET['id'])) {
            http_response_code(400);
            echo json_encode(['message' => 'Flash sale ID required']);
            exit;
        }
        
        $id = (int)$_GET['id'];
        
        // Delete flash sale (cascade will delete products)
        $stmt = $db->prepare("DELETE FROM flash_sales WHERE flash_sale_id = ?");
        $stmt->execute([$id]);
        
        echo json_encode(['message' => 'Flash sale deleted']);
        break;
        
    default:
        http_response_code(405);
        echo json_encode(['message' => 'Method not allowed']);
}
