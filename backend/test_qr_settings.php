<?php
// Simple test script to check QR code settings
header('Content-Type: text/html; charset=utf-8');

require_once __DIR__ . '/api/bootstrap.php';

$db = db();

echo "<h1>QR Code Settings Test</h1>";

// Check if table exists
try {
    $stmt = $db->query("SHOW TABLES LIKE 'site_settings'");
    $tableExists = $stmt->fetch();
    
    if ($tableExists) {
        echo "<p style='color: green;'>✓ Table 'site_settings' exists</p>";
        
        // Get all settings
        $stmt = $db->query("SELECT * FROM site_settings");
        $settings = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        echo "<h2>All Settings:</h2>";
        echo "<pre>" . print_r($settings, true) . "</pre>";
        
        // Get QR code specifically
        $stmt = $db->prepare("SELECT * FROM site_settings WHERE setting_key = 'qr_code_image'");
        $stmt->execute();
        $qrSetting = $stmt->fetch(PDO::FETCH_ASSOC);
        
        echo "<h2>QR Code Setting:</h2>";
        if ($qrSetting) {
            echo "<pre>" . print_r($qrSetting, true) . "</pre>";
            
            if (!empty($qrSetting['setting_value'])) {
                echo "<h3>QR Code Image:</h3>";
                echo "<img src='" . htmlspecialchars($qrSetting['setting_value']) . "' style='max-width: 300px; border: 2px solid #ccc;' />";
            } else {
                echo "<p style='color: orange;'>⚠ QR code setting exists but value is empty</p>";
            }
        } else {
            echo "<p style='color: red;'>✗ No QR code setting found</p>";
        }
        
    } else {
        echo "<p style='color: red;'>✗ Table 'site_settings' does not exist</p>";
        echo "<p>Run this SQL to create it:</p>";
        echo "<pre>
CREATE TABLE IF NOT EXISTS site_settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(100) UNIQUE NOT NULL,
    setting_value TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        </pre>";
    }
} catch (Exception $e) {
    echo "<p style='color: red;'>Error: " . $e->getMessage() . "</p>";
}

echo "<hr>";
echo "<p><a href='/api/site_settings?key=qr_code_image'>Test API Endpoint</a></p>";
?>
