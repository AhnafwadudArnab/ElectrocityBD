<?php
header('Content-Type: text/html; charset=utf-8');
require_once __DIR__ . '/../api/bootstrap.php';
$configured = false;
$error = '';
$ok = false;
if (is_file(__DIR__ . '/../.env')) {
    $configured = true;
    try {
        db();
        $ok = true;
    } catch (Throwable $e) {
        $ok = false;
    }
}
if ($configured && $ok) {
    http_response_code(200);
    echo '<h2>Already configured</h2>';
    echo '<p>Database connection is working.</p>';
    echo '<p><a href="/api/health">API Health</a></p>';
    exit;
}
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $host = trim($_POST['db_host'] ?? '');
    $port = trim($_POST['db_port'] ?? '3306');
    $name = trim($_POST['db_name'] ?? '');
    $user = trim($_POST['db_user'] ?? '');
    $pass = $_POST['db_pass'] ?? '';
    if ($host === '' || $name === '' || $user === '') {
        $error = 'All fields except password are required';
    } else {
        try {
            $dsn = sprintf('mysql:host=%s;port=%s;dbname=%s;charset=utf8mb4', $host, $port, $name);
            $pdo = new PDO($dsn, $user, $pass, [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES => false,
            ]);
            $secret = bin2hex(random_bytes(32));
            $env = [];
            $env[] = 'DB_HOST=' . $host;
            $env[] = 'DB_PORT=' . $port;
            $env[] = 'DB_NAME=' . $name;
            $env[] = 'DB_USER=' . $user;
            $env[] = 'DB_PASSWORD=' . str_replace(["\r","\n"], '', $pass);
            $env[] = 'JWT_SECRET=' . $secret;
            $content = implode(PHP_EOL, $env) . PHP_EOL;
            file_put_contents(__DIR__ . '/../.env', $content, LOCK_EX);
            $configured = true;
            try {
                db();
                $ok = true;
            } catch (Throwable $e) {
                $ok = false;
            }
        } catch (Throwable $e) {
            $error = 'Connection failed. Check credentials and host.';
        }
    }
}
?>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>ElectrocityBD Installer</title>
<style>
body{font-family:Arial,Helvetica,sans-serif;background:#f7f7f9;margin:0;padding:24px}
.card{max-width:520px;margin:0 auto;background:#fff;border:1px solid #e5e7eb;border-radius:8px;box-shadow:0 1px 2px rgba(0,0,0,.06);padding:20px}
.row{display:flex;gap:12px}
.field{margin-bottom:12px}
label{display:block;font-size:14px;margin-bottom:6px}
input{width:100%;padding:10px;border:1px solid #d1d5db;border-radius:6px;font-size:14px}
button{padding:10px 16px;border:0;background:#2563eb;color:#fff;border-radius:6px;cursor:pointer}
.error{background:#fee2e2;border:1px solid #fecaca;color:#991b1b;padding:10px;border-radius:6px;margin-bottom:12px}
.success{background:#dcfce7;border:1px solid #bbf7d0;color:#065f46;padding:10px;border-radius:6px;margin-bottom:12px}
.hint{font-size:12px;color:#6b7280}
</style>
</head>
<body>
<div class="card">
    <h2>ElectrocityBD Database Setup</h2>
    <?php if ($error): ?>
        <div class="error"><?= htmlspecialchars($error) ?></div>
    <?php endif; ?>
    <?php if ($configured && $ok): ?>
        <div class="success">Configuration saved and database connection OK.</div>
        <p><a href="/api/health">Go to API Health</a></p>
        <p class="hint">For security, delete this file after setup.</p>
    <?php else: ?>
        <form method="post" action="">
            <div class="field">
                <label>DB Host</label>
                <input name="db_host" placeholder="localhost or sqlXXX.epizy.com" required>
            </div>
            <div class="field">
                <label>DB Port</label>
                <input name="db_port" value="3306" required>
            </div>
            <div class="field">
                <label>DB Name</label>
                <input name="db_name" required>
            </div>
            <div class="field">
                <label>DB User</label>
                <input name="db_user" required>
            </div>
            <div class="field">
                <label>DB Password</label>
                <input name="db_pass" type="password">
            </div>
            <button type="submit">Save & Test</button>
            <p class="hint">InfinityFree host looks like sqlXXX.epizy.com.</p>
        </form>
    <?php endif; ?>
</div>
</body>
</html>
