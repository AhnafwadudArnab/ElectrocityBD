<?php
$config = require_once __DIR__ . '/config.php';

try {
    $dsn = sprintf(
        'mysql:host=%s;port=%s;dbname=%s;charset=%s',
        $config['db']['host'],
        $config['db']['port'],
        $config['db']['name'],
        $config['db']['charset']
    );
    
    $conn = new PDO($dsn, $config['db']['user'], $config['db']['pass']);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    $sql = file_get_contents(__DIR__ . '/../databaseMysql/add_payment_methods_table.sql');
    $conn->exec($sql);
    echo "Payment methods table created successfully!\n";
    echo "Default payment methods added: bKash (enabled), Nagad (disabled), Cash on Delivery (enabled)\n";
} catch (PDOException $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
?>
