<?php
// /api/admin

$headers = getallheaders();
$authHeader = $headers['Authorization'] ?? '';
$token = '';
if (preg_match('/Bearer\s(\S+)/', $authHeader, $matches)) {
    $token = $matches[1];
}

if (!$token) {
    http_response_code(401);
    echo json_encode(['error' => 'No token provided.']);
    exit;
}

$payload = JWTHelper::verify($token);
if (!$payload || $payload['role'] !== 'admin') {
    http_response_code(403);
    echo json_encode(['error' => 'Access denied. Admin only.']);
    exit;
}

$method = $_SERVER['REQUEST_METHOD'];
$pathParts = explode('/', $_SERVER['REQUEST_URI']);
$subPath = end($pathParts);
if (strpos($subPath, '?') !== false) {
    $subPath = explode('?', $subPath)[0];
}

try {
    if ($subPath === 'dashboard' && $method === 'GET') {
        $totalProducts = $pdo->query('SELECT COUNT(*) FROM products')->fetchColumn();
        $totalOrders = $pdo->query('SELECT COUNT(*) FROM orders')->fetchColumn();
        $totalCustomers = $pdo->query("SELECT COUNT(*) FROM users WHERE role = 'customer'")->fetchColumn();
        $totalRevenue = $pdo->query("SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE payment_status = 'paid'")->fetchColumn();
        $pendingOrders = $pdo->query("SELECT COUNT(*) FROM orders WHERE order_status = 'pending'")->fetchColumn();
        $deliveredOrders = $pdo->query("SELECT COUNT(*) FROM orders WHERE order_status = 'delivered'")->fetchColumn();

        $stmtRecent = $pdo->query(
            "SELECT o.order_id, o.total_amount, o.order_status, o.order_date, u.email, u.full_name
             FROM orders o JOIN users u ON o.user_id = u.user_id
             ORDER BY o.order_date DESC LIMIT 10"
        );
        $recentOrders = $stmtRecent->fetchAll();

        $stmtMonthly = $pdo->query(
            "SELECT DATE_FORMAT(order_date, '%Y-%m') as month,
             COUNT(*) as order_count, SUM(total_amount) as revenue
             FROM orders WHERE payment_status = 'paid'
             GROUP BY month ORDER BY month DESC LIMIT 12"
        );
        $monthlySales = $stmtMonthly->fetchAll();

        echo json_encode([
            'totalProducts' => (int)$totalProducts,
            'totalOrders' => (int)$totalOrders,
            'totalCustomers' => (int)$totalCustomers,
            'totalRevenue' => (float)$totalRevenue,
            'pendingOrders' => (int)$pendingOrders,
            'deliveredOrders' => (int)$deliveredOrders,
            'recentOrders' => $recentOrders,
            'monthlySales' => $monthlySales,
        ]);

    } else if ($subPath === 'customers' && $method === 'GET') {
        $stmt = $pdo->query("SELECT user_id, full_name, last_name, email, phone_number, role, created_at FROM users WHERE role = 'customer' ORDER BY created_at DESC");
        echo json_encode($stmt->fetchAll());

    } else if ($subPath === 'section-filters' && $method === 'GET') {
        $stmt = $pdo->query('SELECT setting_key, setting_value FROM site_settings WHERE setting_key LIKE "section_filter_%"');
        $rows = $stmt->fetchAll();
        $obj = [];
        foreach ($rows as $r) {
            $obj[$r['setting_key']] = json_decode($r['setting_value'], true) ?: $r['setting_value'];
        }
        echo json_encode($obj);
    }

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Server error: ' . $e->getMessage()]);
}
?>
