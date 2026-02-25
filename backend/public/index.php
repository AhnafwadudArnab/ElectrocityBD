<?php
declare(strict_types=1);

require __DIR__ . '/../api/bootstrap.php';
baseHeaders();

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

$uri = $_SERVER['REQUEST_URI'] ?? '/';
$path = parse_url($uri, PHP_URL_PATH) ?: '/';
$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';

if ($method === 'GET' && ($path === '/api' || $path === '/api/')) {
    jsonResponse([
        'status' => 'ok',
        'base' => '/api',
        'endpoints' => [
            'GET /api/health',
            'POST /api/auth/register',
            'POST /api/auth/login',
            'POST /api/auth/admin-login',
            'GET /api/auth/refresh',
            'GET /api/auth/me',
            'PUT /api/auth/change-password',
            'GET /api/products',
            'GET /api/products/{id}',
            'POST /api/products',
            'PUT /api/products/{id}',
            'DELETE /api/products/{id}',
            'PUT /api/products/{id}/sections',
            'GET /api/cart',
            'POST /api/cart',
            'PUT /api/cart/{cartId}',
            'DELETE /api/cart/{cartId}',
            'DELETE /api/cart',
            'GET /api/cart/admin/all',
            'GET /api/orders',
            'POST /api/orders',
        ],
    ]);
}

if (strpos($path, '/api/') === 0) {
    $path = substr($path, 4);
}

function route(string $method, string $path, callable $handler) {
    global $method, $path;
    static $handled = false;
    if ($handled) return;
    if ($method !== $_SERVER['REQUEST_METHOD']) return;
    if (preg_match($path, $_SERVER['REQUEST_URI'], $m)) {
        $handled = true;
        $handler($m);
    }
}

function segmentPath(): string {
    $p = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH) ?: '';
    return $p;
}

// Health
if ($method === 'GET' && $path === '/health') {
    jsonResponse(['status' => 'ok']);
}

// Auth: register
if ($method === 'POST' && $path === '/auth/register') {
    $b = getJsonBody();
    $first = trim((string)($b['firstName'] ?? ''));
    $last = trim((string)($b['lastName'] ?? ''));
    $email = strtolower(trim((string)($b['email'] ?? '')));
    $pass = (string)($b['password'] ?? '');
    $phone = trim((string)($b['phone'] ?? ''));
    $gender = trim((string)($b['gender'] ?? 'Male'));
    if ($first === '' || $email === '' || $pass === '') errorResponse('Missing fields', 422);
    $hash = password_hash($pass, PASSWORD_BCRYPT);
    $pdo = db();
    $pdo->beginTransaction();
    try {
        $stmt = $pdo->prepare('INSERT INTO users(full_name, last_name, email, password, phone_number, gender, role) VALUES (?,?,?,?,?,?,?)');
        $stmt->execute([$first, $last, $email, $hash, $phone, $gender, 'customer']);
        $uid = (int)$pdo->lastInsertId();
        $stmt2 = $pdo->prepare('INSERT INTO user_profile(user_id, full_name, last_name, phone_number, gender) VALUES (?,?,?,?,?)');
        $stmt2->execute([$uid, $first, $last, $phone, $gender]);
        $pdo->commit();
        $token = issueToken($uid, 'customer');
        jsonResponse(['token' => $token, 'user' => ['user_id' => $uid, 'email' => $email, 'full_name' => $first, 'last_name' => $last]]);
    } catch (Throwable $e) {
        $pdo->rollBack();
        if (str_contains(strtolower($e->getMessage()), 'duplicate')) errorResponse('Email already registered', 409);
        errorResponse('Failed to register', 500);
    }
}

// Auth: login
if ($method === 'POST' && $path === '/auth/login') {
    $b = getJsonBody();
    $email = strtolower(trim((string)($b['email'] ?? '')));
    $pass = (string)($b['password'] ?? '');
    $stmt = db()->prepare('SELECT user_id, email, password, role, full_name, last_name FROM users WHERE email = ?');
    $stmt->execute([$email]);
    $u = $stmt->fetch();
    if (!$u || !password_verify($pass, $u['password'])) errorResponse('Invalid credentials', 401);
    $token = issueToken((int)$u['user_id'], (string)$u['role']);
    jsonResponse(['token' => $token, 'user' => ['user_id' => (int)$u['user_id'], 'email' => $u['email'], 'full_name' => $u['full_name'], 'last_name' => $u['last_name'], 'role' => $u['role']]]);
}

// Auth: admin-login
if ($method === 'POST' && $path === '/auth/admin-login') {
    $b = getJsonBody();
    $username = strtolower(trim((string)($b['username'] ?? '')));
    $pass = (string)($b['password'] ?? '');
    $stmt = db()->prepare('SELECT user_id, email, password, role, full_name, last_name FROM users WHERE email = ? AND role = "admin"');
    $stmt->execute([$username]);
    $u = $stmt->fetch();
    if (!$u || !password_verify($pass, $u['password'])) errorResponse('Invalid credentials', 401);
    $token = issueToken((int)$u['user_id'], 'admin');
    jsonResponse(['token' => $token, 'user' => ['user_id' => (int)$u['user_id'], 'email' => $u['email'], 'full_name' => $u['full_name'], 'last_name' => $u['last_name'], 'role' => 'admin']]);
}

// Auth: refresh
if ($method === 'GET' && $path === '/auth/refresh') {
    $u = requireAuth();
    $token = issueToken((int)$u['user_id'], (string)$u['role']);
    jsonResponse(['token' => $token]);
}

// Auth: me
if ($method === 'GET' && $path === '/auth/me') {
    $u = requireAuth();
    jsonResponse(['user' => $u]);
}

// Auth: change-password
if ($method === 'PUT' && $path === '/auth/change-password') {
    $u = requireAuth();
    $b = getJsonBody();
    $current = (string)($b['currentPassword'] ?? '');
    $new = (string)($b['newPassword'] ?? '');
    $stmt = db()->prepare('SELECT password FROM users WHERE user_id = ?');
    $stmt->execute([(int)$u['user_id']]);
    $row = $stmt->fetch();
    if (!$row || !password_verify($current, $row['password'])) errorResponse('Invalid current password', 400);
    $hash = password_hash($new, PASSWORD_BCRYPT);
    $upd = db()->prepare('UPDATE users SET password=? WHERE user_id=?');
    $upd->execute([$hash, (int)$u['user_id']]);
    jsonResponse(['ok' => true]);
}

// Products: list
if ($method === 'GET' && $path === '/products') {
    $q = $_GET;
    $limit = isset($q['limit']) ? max(1, min(100, (int)$q['limit'])) : 50;
    $offset = isset($q['offset']) ? max(0, (int)$q['offset']) : 0;
    $categoryId = isset($q['category_id']) ? (int)$q['category_id'] : null;
    $search = isset($q['search']) ? trim((string)$q['search']) : '';
    $sort = isset($q['sort']) ? trim((string)$q['sort']) : '';
    $section = isset($q['section']) ? trim((string)$q['section']) : '';
    $where = [];
    $params = [];
    if ($categoryId) { $where[] = 'p.category_id = ?'; $params[] = $categoryId; }
    if ($search !== '') { $where[] = '(p.product_name LIKE ? OR p.description LIKE ?)'; $params[] = "%$search%"; $params[] = "%$search%"; }
    $join = '';
    if ($section !== '') {
        if ($section === 'best_sellers') $join = 'JOIN best_sellers s ON s.product_id = p.product_id';
        elseif ($section === 'trending') $join = 'JOIN trending_products s ON s.product_id = p.product_id';
        elseif ($section === 'deals') $join = 'JOIN deals_of_the_day s ON s.product_id = p.product_id';
        elseif ($section === 'flash_sale') $join = 'JOIN flash_sale_products s ON s.product_id = p.product_id';
        elseif ($section === 'tech_part') $join = 'JOIN tech_part_products s ON s.product_id = p.product_id';
    }
    $order = 'p.created_at DESC';
    if ($sort === 'newest') $order = 'p.created_at DESC';
    if ($sort === 'price_asc') $order = 'p.price ASC';
    if ($sort === 'price_desc') $order = 'p.price DESC';
    $sql = "SELECT p.* FROM products p $join";
    if ($where) $sql .= ' WHERE ' . implode(' AND ', $where);
    $sql .= " ORDER BY $order LIMIT ? OFFSET ?";
    $params[] = $limit;
    $params[] = $offset;
    $stmt = db()->prepare($sql);
    $stmt->execute($params);
    $rows = $stmt->fetchAll();
    jsonResponse(['data' => $rows, 'count' => count($rows)]);
}

// Products: get one
if ($method === 'GET' && preg_match('#^/products/(\d+)$#', $path, $m)) {
    $id = (int)$m[1];
    $stmt = db()->prepare('SELECT * FROM products WHERE product_id = ?');
    $stmt->execute([$id]);
    $row = $stmt->fetch();
    if (!$row) errorResponse('Not found', 404);
    jsonResponse($row);
}

// Products: create (JSON or multipart)
if ($method === 'POST' && $path === '/products') {
    $pdo = db();
    $pdo->beginTransaction();
    try {
        if (isset($_FILES['image'])) {
            $imagePath = saveUploadedImage($_FILES['image']);
            $fields = $_POST;
            $name = trim((string)($fields['product_name'] ?? ''));
            $desc = (string)($fields['description'] ?? '');
            $price = (float)($fields['price'] ?? 0);
            $stock = (int)($fields['stock_quantity'] ?? 0);
            $category_id = isset($fields['category_id']) ? (int)$fields['category_id'] : null;
            $brand_id = isset($fields['brand_id']) ? (int)$fields['brand_id'] : null;
            $stmt = $pdo->prepare('INSERT INTO products(product_name, description, price, stock_quantity, category_id, brand_id, image_url) VALUES (?,?,?,?,?,?,?)');
            $stmt->execute([$name, $desc, $price, $stock, $category_id, $brand_id, $imagePath]);
        } else {
            $b = getJsonBody();
            $name = trim((string)($b['product_name'] ?? ''));
            $desc = (string)($b['description'] ?? '');
            $price = (float)($b['price'] ?? 0);
            $stock = (int)($b['stock_quantity'] ?? 0);
            $category_id = isset($b['category_id']) ? (int)$b['category_id'] : null;
            $brand_id = isset($b['brand_id']) ? (int)$b['brand_id'] : null;
            $image_url = (string)($b['image_url'] ?? '');
            $stmt = $pdo->prepare('INSERT INTO products(product_name, description, price, stock_quantity, category_id, brand_id, image_url) VALUES (?,?,?,?,?,?,?)');
            $stmt->execute([$name, $desc, $price, $stock, $category_id, $brand_id, $image_url ?: null]);
        }
        $id = (int)$pdo->lastInsertId();
        $pdo->commit();
        jsonResponse(['product_id' => $id], 201);
    } catch (Throwable $e) {
        $pdo->rollBack();
        errorResponse('Failed to create product', 500);
    }
}

// Products: update
if ($method === 'PUT' && preg_match('#^/products/(\d+)$#', $path, $m)) {
    $id = (int)$m[1];
    $b = getJsonBody();
    $fields = [];
    $params = [];
    foreach (['product_name','description','price','stock_quantity','category_id','brand_id','image_url'] as $k) {
        if (array_key_exists($k, $b)) {
            $fields[] = "$k = ?";
            $params[] = $b[$k];
        }
    }
    if (!$fields) errorResponse('No fields', 400);
    $params[] = $id;
    $stmt = db()->prepare('UPDATE products SET ' . implode(',', $fields) . ' WHERE product_id = ?');
    $stmt->execute($params);
    jsonResponse(['ok' => true]);
}

// Products: delete
if ($method === 'DELETE' && preg_match('#^/products/(\d+)$#', $path, $m)) {
    $id = (int)$m[1];
    $stmt = db()->prepare('DELETE FROM products WHERE product_id = ?');
    $stmt->execute([$id]);
    jsonResponse(['ok' => true]);
}

// Products: sections update
if ($method === 'PUT' && preg_match('#^/products/(\d+)/sections$#', $path, $m)) {
    $id = (int)$m[1];
    $b = getJsonBody();
    $maps = [
        'best_sellers' => 'best_sellers',
        'trending' => 'trending_products',
        'deals' => 'deals_of_the_day',
        'flash_sale' => 'flash_sale_products',
        'tech_part' => 'tech_part_products',
    ];
    foreach ($maps as $key => $table) {
        if (!array_key_exists($key, $b)) continue;
        $enabled = (bool)$b[$key];
        if ($table === 'deals_of_the_day') {
            if ($enabled) {
                $exists = db()->prepare('SELECT 1 FROM deals_of_the_day WHERE product_id=?');
                $exists->execute([$id]);
                if (!$exists->fetch()) {
                    $ins = db()->prepare('INSERT INTO deals_of_the_day(product_id, deal_price, start_date, end_date) VALUES (?,?,NOW(),DATE_ADD(NOW(), INTERVAL 7 DAY))');
                    $priceRow = db()->prepare('SELECT price FROM products WHERE product_id=?');
                    $priceRow->execute([$id]);
                    $p = (float)($priceRow->fetch()['price'] ?? 0);
                    $ins->execute([$id, max(0.0, $p * 0.9)]);
                }
            } else {
                $del = db()->prepare('DELETE FROM deals_of_the_day WHERE product_id=?');
                $del->execute([$id]);
            }
            continue;
        }
        if ($enabled) {
            $exists = db()->prepare("SELECT 1 FROM $table WHERE product_id=?");
            $exists->execute([$id]);
            if (!$exists->fetch()) {
                $ins = db()->prepare("INSERT INTO $table(product_id) VALUES (?)");
                $ins->execute([$id]);
            }
        } else {
            $del = db()->prepare("DELETE FROM $table WHERE product_id=?");
            $del->execute([$id]);
        }
    }
    jsonResponse(['ok' => true]);
}

// Cart: get
if ($method === 'GET' && $path === '/cart') {
    $u = requireAuth();
    $stmt = db()->prepare('SELECT c.*, p.product_name, p.price, p.image_url FROM cart c JOIN products p ON p.product_id = c.product_id WHERE c.user_id = ? ORDER BY c.added_at DESC');
    $stmt->execute([(int)$u['user_id']]);
    $rows = $stmt->fetchAll();
    jsonResponse(['items' => $rows]);
}

// Cart: add
if ($method === 'POST' && $path === '/cart') {
    $u = requireAuth();
    $b = getJsonBody();
    $pid = (int)($b['product_id'] ?? 0);
    $qty = max(1, (int)($b['quantity'] ?? 1));
    if ($pid <= 0) errorResponse('Invalid product', 422);
    $exists = db()->prepare('SELECT cart_id, quantity FROM cart WHERE user_id=? AND product_id=?');
    $exists->execute([(int)$u['user_id'], $pid]);
    $row = $exists->fetch();
    if ($row) {
        $upd = db()->prepare('UPDATE cart SET quantity=? WHERE cart_id=?');
        $upd->execute([$row['quantity'] + $qty, (int)$row['cart_id']]);
    } else {
        $ins = db()->prepare('INSERT INTO cart(user_id, product_id, quantity) VALUES (?,?,?)');
        $ins->execute([(int)$u['user_id'], $pid, $qty]);
    }
    jsonResponse(['ok' => true]);
}

// Cart: update quantity
if ($method === 'PUT' && preg_match('#^/cart/(\d+)$#', $path, $m)) {
    $u = requireAuth();
    $cid = (int)$m[1];
    $b = getJsonBody();
    $qty = max(0, (int)($b['quantity'] ?? 1));
    $own = db()->prepare('SELECT user_id FROM cart WHERE cart_id=?');
    $own->execute([$cid]);
    $row = $own->fetch();
    if (!$row) errorResponse('Not found', 404);
    if ((int)$row['user_id'] !== (int)$u['user_id'] && ($u['role'] ?? 'customer') !== 'admin') errorResponse('Forbidden', 403);
    if ($qty <= 0) {
        $del = db()->prepare('DELETE FROM cart WHERE cart_id=?');
        $del->execute([$cid]);
    } else {
        $upd = db()->prepare('UPDATE cart SET quantity=? WHERE cart_id=?');
        $upd->execute([$qty, $cid]);
    }
    jsonResponse(['ok' => true]);
}

// Cart: remove item
if ($method === 'DELETE' && preg_match('#^/cart/(\d+)$#', $path, $m)) {
    $u = requireAuth();
    $cid = (int)$m[1];
    $own = db()->prepare('SELECT user_id FROM cart WHERE cart_id=?');
    $own->execute([$cid]);
    $row = $own->fetch();
    if (!$row) errorResponse('Not found', 404);
    if ((int)$row['user_id'] !== (int)$u['user_id'] && ($u['role'] ?? 'customer') !== 'admin') errorResponse('Forbidden', 403);
    $del = db()->prepare('DELETE FROM cart WHERE cart_id=?');
    $del->execute([$cid]);
    jsonResponse(['ok' => true]);
}

// Cart: clear
if ($method === 'DELETE' && $path === '/cart') {
    $u = requireAuth();
    $del = db()->prepare('DELETE FROM cart WHERE user_id=?');
    $del->execute([(int)$u['user_id']]);
    jsonResponse(['ok' => true]);
}

// Cart: admin all
if ($method === 'GET' && $path === '/cart/admin/all') {
    requireAdmin();
    $stmt = db()->query('SELECT c.*, u.email, u.full_name, p.product_name FROM cart c JOIN users u ON u.user_id=c.user_id JOIN products p ON p.product_id=c.product_id ORDER BY c.added_at DESC');
    $rows = $stmt->fetchAll();
    jsonResponse($rows);
}

// Orders: list for user
if ($method === 'GET' && $path === '/orders') {
    $u = requireAuth();
    $stmt = db()->prepare('SELECT * FROM orders WHERE user_id=? ORDER BY order_date DESC');
    $stmt->execute([(int)$u['user_id']]);
    $rows = $stmt->fetchAll();
    jsonResponse($rows);
}

// Orders: place
if ($method === 'POST' && $path === '/orders') {
    $u = requireAuth();
    $b = getJsonBody();
    $payment_method = (string)($b['payment_method'] ?? 'Cash on Delivery');
    $delivery_address = (string)($b['delivery_address'] ?? '');
    $pdo = db();
    $itemsStmt = $pdo->prepare('SELECT c.quantity, p.product_id, p.product_name, p.price, p.image_url FROM cart c JOIN products p ON p.product_id=c.product_id WHERE c.user_id=?');
    $itemsStmt->execute([(int)$u['user_id']]);
    $items = $itemsStmt->fetchAll();
    if (!$items) errorResponse('Cart empty', 400);
    $total = 0.0;
    foreach ($items as $it) $total += (float)$it['price'] * (int)$it['quantity'];
    $pdo->beginTransaction();
    try {
        $insOrder = $pdo->prepare('INSERT INTO orders(user_id, total_amount, order_status, payment_method, payment_status, delivery_address, transaction_id, estimated_delivery) VALUES (?,?,?,?,?,?,?,?)');
        $insOrder->execute([(int)$u['user_id'], $total, 'pending', $payment_method, 'unpaid', $delivery_address, null, '3-5 business days']);
        $orderId = (int)$pdo->lastInsertId();
        $insItem = $pdo->prepare('INSERT INTO order_items(order_id, product_id, product_name, quantity, price_at_purchase, image_url) VALUES (?,?,?,?,?,?)');
        foreach ($items as $it) {
            $insItem->execute([$orderId, (int)$it['product_id'], $it['product_name'], (int)$it['quantity'], (float)$it['price'], $it['image_url']]);
            $updStock = $pdo->prepare('UPDATE products SET stock_quantity = GREATEST(0, stock_quantity - ?) WHERE product_id=?');
            $updStock->execute([(int)$it['quantity'], (int)$it['product_id']]);
        }
        $clr = $pdo->prepare('DELETE FROM cart WHERE user_id=?');
        $clr->execute([(int)$u['user_id']]);
        $pdo->commit();
        jsonResponse(['order_id' => $orderId, 'total_amount' => $total], 201);
    } catch (Throwable $e) {
        $pdo->rollBack();
        errorResponse('Failed to place order', 500);
    }
}

errorResponse('Not Found', 404);
