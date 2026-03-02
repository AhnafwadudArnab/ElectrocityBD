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
        if (isset($_GET['id'])) {
            // Get single flash sale with products
            $id = (int)$_GET['id'];
            $stmt = $db->prepare("SELECT * FROM flash_sales WHERE flash_sale_id = ?");
            $stmt->execute([$id]);
            $flashSale = $stmt->fetch(PDO::FETCH_ASSOC);
            
            if (!$flashSale) {
                http_response_code(404);
                echo json_encode(['error' => 'Flash sale not found']);
                exit;
            }
            
            // Get products in flash sale
            $stmt = $db->prepare("
                SELECT p.*, fsp.flash_price 
                FROM products p
                INNER JOIN flash_sale_products fsp ON p.product_id = fsp.product_id
                WHERE fsp.flash_sale_id = ?
            ");
            $stmt->execute([$id]);
            $flashSale['products'] = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            echo json_encode($flashSale);
        } else {
            // Get active flash sales with products
            $stmt = $db->query("
                SELECT * FROM flash_sales 
                WHERE active = 1 AND end_time > NOW()
                ORDER BY start_time DESC
            ");
            $flashSales = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            foreach ($flashSales as &$sale) {
                $stmt = $db->prepare("
                    SELECT p.*, fsp.flash_price 
                    FROM products p
                    INNER JOIN flash_sale_products fsp ON p.product_id = fsp.product_id
                    WHERE fsp.flash_sale_id = ?
                ");
                $stmt->execute([$sale['flash_sale_id']]);
                $sale['products'] = $stmt->fetchAll(PDO::FETCH_ASSOC);
            }
            
            echo json_encode($flashSales);
        }
        break;
        
    case 'POST':
        $data = json_decode(file_get_contents('php://input'), true);
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
                INSERT INTO flash_sale_products (flash_sale_id, product_id, flash_price)
                VALUES (?, ?, ?)
            ");
            foreach ($data['products'] as $product) {
                $stmt->execute([
                    $flashSaleId,
                    $product['product_id'],
                    $product['flash_price']
                ]);
            }
        }
        
        echo json_encode(['message' => 'Flash sale created', 'id' => $flashSaleId]);
        break;
        
    case 'PUT':
        $id = (int)$_GET['id'];
        $data = json_decode(file_get_contents('php://input'), true);
        $stmt = $db->prepare("
            UPDATE flash_sales 
            SET title = ?, start_time = ?, end_time = ?, active = ?
            WHERE flash_sale_id = ?
        ");
        $stmt->execute([
            $data['title'],
            $data['start_time'],
            $data['end_time'],
            $data['active'] ?? 1,
            $id
        ]);
        echo json_encode(['message' => 'Flash sale updated']);
        break;
        
    case 'DELETE':
        $id = (int)$_GET['id'];
        $stmt = $db->prepare("DELETE FROM flash_sales WHERE flash_sale_id = ?");
        $stmt->execute([$id]);
        echo json_encode(['message' => 'Flash sale deleted']);
        break;
}
