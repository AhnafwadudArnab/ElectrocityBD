<?php
$uri = urldecode(parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH));
$publicDir = __DIR__ . '/public';
$filePath = $publicDir . $uri;
if ($uri !== '/' && is_file($filePath)) {
    return false;
}
require $publicDir . '/index.php';

