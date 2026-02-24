<?php
$env = array_merge($_SERVER, $_ENV);
$get = function ($key, $default = null) use ($env) {
    $v = $env[$key] ?? getenv($key);
    return ($v !== false && $v !== null && $v !== '') ? $v : $default;
};
$url = $get('DB_URL');
$host = $get('DB_HOST', 'localhost');
$db   = $get('DB_NAME', 'electrocity_db');
$user = $get('DB_USER', 'root');
$pass = $get('DB_PASS', '');
$charset = $get('DB_CHARSET', 'utf8mb4');
$port = $get('DB_PORT', '3306');
if ($url) {
    $parts = parse_url($url);
    if ($parts !== false) {
        $host = $parts['host'] ?? $host;
        $db = ltrim($parts['path'] ?? "/$db", '/');
        if (isset($parts['user'])) $user = $parts['user'];
        if (isset($parts['pass'])) $pass = $parts['pass'];
        if (isset($parts['port'])) $port = (string)$parts['port'];
        if (isset($parts['query'])) {
            parse_str($parts['query'], $q);
            if (!empty($q['charset'])) $charset = $q['charset'];
        }
    }
}
$dsn = "mysql:host=$host;port=$port;dbname=$db;charset=$charset";
$options = [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES => false,
];
try {
    $pdo = new PDO($dsn, $user, $pass, $options);
} catch (\PDOException $e) {
    header('Content-Type: application/json', true, 500);
    echo json_encode(['error' => 'Database connection failed: ' . $e->getMessage()]);
    exit;
}
?>
