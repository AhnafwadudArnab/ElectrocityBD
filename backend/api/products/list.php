<?php
// GET /api/products

function imageFullUrl($imageUrl) {
    if (!$imageUrl || !is_string($imageUrl)) return $imageUrl ?? '';
    if (strpos($imageUrl, 'asset:') === 0) return $imageUrl;
    if (strpos($imageUrl, 'http://') === 0 || strpos($imageUrl, 'https://') === 0) return $imageUrl;
    
    $protocol = isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http";
    $host = $_SERVER['HTTP_HOST'] ?? 'localhost:3000';
    $base = "$protocol://$host";
    
    return strpos($imageUrl, '/') === 0 ? $base . $imageUrl : $base . '/' . $imageUrl;
}

$method = $_SERVER['REQUEST_METHOD'];

try {
    if ($method === 'POST') {
        // Admin only check
        $token = getBearerToken();
        $payload = $token ? JWTHelper::verify($token) : null;
        if (!$payload || $payload['role'] !== 'admin') {
            http_response_code(403);
            echo json_encode(['error' => 'Unauthorized. Admin only.']);
            exit;
        }

        $contentType = $_SERVER['CONTENT_TYPE'] ?? '';
        $isMultipart = stripos($contentType, 'multipart/form-data') !== false || !empty($_FILES);
        if ($isMultipart) {
            $name = $_POST['product_name'] ?? $_POST['name'] ?? '';
            $desc = $_POST['description'] ?? '';
            $price = $_POST['price'] ?? 0;
            $stock = $_POST['stock_quantity'] ?? $_POST['stock'] ?? 0;
            $catId = $_POST['category_id'] ?? null;
            $brandId = $_POST['brand_id'] ?? null;
            $imageUrl = $_POST['image_url'] ?? '';
            if (isset($_FILES['image']) && is_uploaded_file($_FILES['image']['tmp_name'])) {
                $uploadsDir = dirname(__DIR__, 2) . '/uploads';
                if (!is_dir($uploadsDir)) {
                    @mkdir($uploadsDir, 0777, true);
                }
                $orig = basename($_FILES['image']['name']);
                $ext = pathinfo($orig, PATHINFO_EXTENSION);
                $safeExt = preg_replace('/[^a-zA-Z0-9]/', '', $ext);
                $fname = 'prod_' . time() . '_' . bin2hex(random_bytes(4)) . ($safeExt ? ('.' . strtolower($safeExt)) : '');
                $target = $uploadsDir . '/' . $fname;
                if (move_uploaded_file($_FILES['image']['tmp_name'], $target)) {
                    $imageUrl = '/uploads/' . $fname;
                }
            }
        } else {
            $body = getRequestBody();
            $name = $body['product_name'] ?? $body['name'] ?? '';
            $desc = $body['description'] ?? '';
            $price = $body['price'] ?? 0;
            $stock = $body['stock_quantity'] ?? $body['stock'] ?? 0;
            $catId = $body['category_id'] ?? null;
            $brandId = $body['brand_id'] ?? null;
            $imageUrl = $body['image_url'] ?? '';
        }

        if (!$name || !$price) {
            http_response_code(400);
            echo json_encode(['error' => 'Product name and price are required.']);
            exit;
        }

            $stmt = $pdo->prepare("INSERT INTO products (category_id, brand_id, product_name, description, price, stock_quantity, image_url) VALUES (?, ?, ?, ?, ?, ?, ?)");
            $stmt->execute([$catId, $brandId, $name, $desc, $price, $stock, $imageUrl]);
        $newId = $pdo->lastInsertId();

        echo json_encode(['message' => 'Product created successfully', 'product_id' => (int)$newId]);
        exit;
    }

    // Existing GET logic
    $category_id = $_GET['category_id'] ?? null;
    $brand_id = $_GET['brand_id'] ?? null;
    $search = $_GET['search'] ?? null;
    $min_price = $_GET['min_price'] ?? null;
    $max_price = $_GET['max_price'] ?? null;
    $sort = $_GET['sort'] ?? null;
    $limit = $_GET['limit'] ?? 50;
    $offset = $_GET['offset'] ?? 0;
    $section = $_GET['section'] ?? null;

    $sql = "SELECT p.*, c.category_name, b.brand_name,
            d.discount_percent, d.valid_from, d.valid_to
            FROM products p
            LEFT JOIN categories c ON p.category_id = c.category_id
            LEFT JOIN brands b ON p.brand_id = b.brand_id
            LEFT JOIN discounts d ON p.product_id = d.product_id";
    $params = [];

    if ($section === 'best_sellers') {
        $sql .= ' INNER JOIN best_sellers bs ON p.product_id = bs.product_id';
    } else if ($section === 'trending') {
        $sql .= ' INNER JOIN trending_products tp ON p.product_id = tp.product_id';
    } else if ($section === 'deals') {
        $sql .= ' INNER JOIN deals_of_the_day dd ON p.product_id = dd.product_id';
    } else if ($section === 'flash_sale') {
        $sql .= ' INNER JOIN flash_sale_products fsp ON p.product_id = fsp.product_id';
    } else if ($section === 'tech_part') {
        $sql .= ' INNER JOIN tech_part_products tpp ON p.product_id = tpp.product_id';
    }

    $sql .= ' WHERE 1=1';

    // Load section filters from site_settings if section provided
    $sectionFilters = [];
    if ($section) {
        $sectionKeyMap = [
            'best_sellers' => 'section_filter_best_sellers',
            'trending' => 'section_filter_trending',
            'deals' => 'section_filter_deals',
            'flash_sale' => 'section_filter_flash_sale',
            'tech_part' => 'section_filter_tech_part',
        ];
        $settingKey = $sectionKeyMap[$section] ?? null;
        if ($settingKey) {
            $stmt = $pdo->prepare('SELECT setting_value FROM site_settings WHERE setting_key = ?');
            $stmt->execute([$settingKey]);
            $row = $stmt->fetch();
            if ($row && $row['setting_value']) {
                $sectionFilters = json_decode($row['setting_value'], true) ?? [];
            }
        }
    }

    if ($category_id) { $sql .= ' AND p.category_id = ?'; $params[] = $category_id; }
    if ($brand_id) { $sql .= ' AND p.brand_id = ?'; $params[] = $brand_id; }
    if ($search) { $sql .= ' AND (p.product_name LIKE ? OR p.description LIKE ?)'; $params[] = "%$search%"; $params[] = "%$search%"; }
    
    $effMin = $min_price ?? ($sectionFilters['min_price'] ?? null);
    $effMax = $max_price ?? ($sectionFilters['max_price'] ?? null);
    if ($effMin !== null) { $sql .= ' AND p.price >= ?'; $params[] = $effMin; }
    if ($effMax !== null) { $sql .= ' AND p.price <= ?'; $params[] = $effMax; }

    $effSort = $sort ?? ($sectionFilters['sort'] ?? null);
    if ($effSort === 'price_asc') $sql .= ' ORDER BY p.price ASC';
    else if ($effSort === 'price_desc') $sql .= ' ORDER BY p.price DESC';
    else if ($effSort === 'newest') $sql .= ' ORDER BY p.created_at DESC';
    else $sql .= ' ORDER BY p.product_id DESC';

    $effLimit = (int)($limit ?? ($sectionFilters['limit'] ?? 50));
    $effOffset = (int)$offset;
    $sql .= " LIMIT $effLimit OFFSET $effOffset";

    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    $rows = $stmt->fetchAll();

    // Get total count
    $total = 0;
    if (!$section) {
        $total = $pdo->query('SELECT COUNT(*) FROM products')->fetchColumn();
    } else {
        $countSql = "SELECT COUNT(p.product_id) FROM products p";
        if ($section === 'best_sellers') $countSql .= ' INNER JOIN best_sellers bs ON p.product_id = bs.product_id';
        else if ($section === 'trending') $countSql .= ' INNER JOIN trending_products tp ON p.product_id = tp.product_id';
        else if ($section === 'deals') $countSql .= ' INNER JOIN deals_of_the_day dd ON p.product_id = dd.product_id';
        else if ($section === 'flash_sale') $countSql .= ' INNER JOIN flash_sale_products fsp ON p.product_id = fsp.product_id';
        else if ($section === 'tech_part') $countSql .= ' INNER JOIN tech_part_products tpp ON p.product_id = tpp.product_id';
        
        $countSql .= ' WHERE 1=1';
        $countParams = [];
        if ($category_id) { $countSql .= ' AND p.category_id = ?'; $countParams[] = $category_id; }
        if ($brand_id) { $countSql .= ' AND p.brand_id = ?'; $countParams[] = $brand_id; }
        if ($search) { $countSql .= ' AND (p.product_name LIKE ? OR p.description LIKE ?)'; $countParams[] = "%$search%"; $countParams[] = "%$search%"; }
        if ($min_price) { $countSql .= ' AND p.price >= ?'; $countParams[] = $min_price; }
        if ($max_price) { $countSql .= ' AND p.price <= ?'; $countParams[] = $max_price; }
        
        $stmtCount = $pdo->prepare($countSql);
        $stmtCount->execute($countParams);
        $total = $stmtCount->fetchColumn();
    }

    $products = [];
    foreach ($rows as $r) {
        $r['image_url'] = imageFullUrl($r['image_url']);
        $products[] = $r;
    }

    echo json_encode(['products' => $products, 'total' => (int)$total]);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Server error: ' . $e->getMessage()]);
}
?>
