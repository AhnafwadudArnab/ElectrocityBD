<?php
declare(strict_types=1);

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
    exit;
}

require_once __DIR__ . '/db_connection.php';
require_once __DIR__ . '/../vendor/autoload.php';

use PHPMailer\PHPMailer\Exception;
use PHPMailer\PHPMailer\PHPMailer;

function jsonError(int $statusCode, string $message): void
{
    http_response_code($statusCode);
    echo json_encode(['success' => false, 'message' => $message]);
    exit;
}

try {
    $payload = json_decode(file_get_contents('php://input') ?: '', true);

    if (!is_array($payload)) {
        jsonError(400, 'Invalid JSON body');
    }

    $email = strtolower(trim((string)($payload['email'] ?? '')));
    if ($email === '' || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
        jsonError(422, 'Valid email is required');
    }

    $pdo = getDatabaseConnection();

    // Security: use prepared statement to avoid SQL injection.
    $userStmt = $pdo->prepare('SELECT id FROM users WHERE email = :email LIMIT 1');
    $userStmt->execute([':email' => $email]);
    $user = $userStmt->fetch();

    // Security: return generic success even if email does not exist
    // to reduce account enumeration risk.
    if (!$user) {
        http_response_code(200);
        echo json_encode(['success' => true, 'message' => 'Reset link sent']);
        exit;
    }

    // Security: remove previous tokens for the same email so only one valid token remains.
    $cleanupStmt = $pdo->prepare('DELETE FROM password_resets WHERE email = :email OR expires_at <= NOW()');
    $cleanupStmt->execute([':email' => $email]);

    // Security: cryptographically secure token generation.
    $token = bin2hex(random_bytes(32));

    // Security: token expires after 15 minutes.
    $insertStmt = $pdo->prepare(
        'INSERT INTO password_resets (email, token, expires_at, created_at) VALUES (:email, :token, DATE_ADD(NOW(), INTERVAL 15 MINUTE), NOW())'
    );
    $insertStmt->execute([
        ':email' => $email,
        ':token' => $token,
    ]);

    $config = require __DIR__ . '/../config.php';
    $appUrl = rtrim((string)(getenv('APP_URL') ?: 'https://yourdomain.com'), '/');
    $resetLink = $appUrl . '/reset_password.php?token=' . urlencode($token);

    $mailer = new PHPMailer(true);
    $mailer->isSMTP();
    $mailer->Host = (string)(getenv('SMTP_HOST') ?: 'smtp.gmail.com');
    $mailer->SMTPAuth = true;
    $mailer->Username = (string)(getenv('SMTP_USERNAME') ?: '');
    $mailer->Password = (string)(getenv('SMTP_PASSWORD') ?: '');
    $mailer->Port = (int)(getenv('SMTP_PORT') ?: 587);

    $smtpSecure = strtolower((string)(getenv('SMTP_SECURE') ?: 'tls'));
    if ($smtpSecure === 'ssl') {
        $mailer->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;
    } else {
        $mailer->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
    }

    $fromAddress = (string)(getenv('MAIL_FROM_ADDRESS') ?: 'noreply@example.com');
    $fromName = (string)(getenv('MAIL_FROM_NAME') ?: 'Password Reset');

    $mailer->setFrom($fromAddress, $fromName);
    $mailer->addAddress($email);
    $mailer->isHTML(true);
    $mailer->Subject = 'Reset your password';
    $mailer->Body = '<p>Click the link below to reset your password:</p><p><a href="' . htmlspecialchars($resetLink, ENT_QUOTES, 'UTF-8') . '">Reset Password</a></p><p>This link expires in 15 minutes.</p>';
    $mailer->AltBody = "Open this link to reset your password: {$resetLink}\nThis link expires in 15 minutes.";

    try {
        $mailer->send();
    } catch (Exception $mailException) {
        // Security: remove token when email delivery fails to prevent orphan valid tokens.
        $rollbackTokenStmt = $pdo->prepare('DELETE FROM password_resets WHERE token = :token');
        $rollbackTokenStmt->execute([':token' => $token]);

        jsonError(500, 'Failed to send reset email');
    }

    http_response_code(200);
    echo json_encode(['success' => true, 'message' => 'Reset link sent']);
} catch (RuntimeException $runtimeException) {
    jsonError(500, 'Server configuration error');
} catch (Throwable $throwable) {
    jsonError(500, 'Internal server error');
}
