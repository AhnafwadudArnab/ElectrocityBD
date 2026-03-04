<?php
/**
 * Email Service using PHPMailer with SMTP
 * 
 * This service handles all email sending functionality including:
 * - Password reset emails
 * - Order confirmations
 * - Welcome emails
 * - Notifications
 */

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

class EmailService {
    private $mailer;
    private $config;
    
    public function __construct() {
        $this->mailer = new PHPMailer(true);
        $this->loadConfig();
        $this->setupSMTP();
    }
    
    /**
     * Load email configuration from environment or config file
     */
    private function loadConfig() {
        $this->config = [
            'smtp_host' => getenv('SMTP_HOST') ?: 'smtp.gmail.com',
            'smtp_port' => getenv('SMTP_PORT') ?: 587,
            'smtp_secure' => getenv('SMTP_SECURE') ?: 'tls', // tls or ssl
            'smtp_username' => getenv('SMTP_USERNAME') ?: '',
            'smtp_password' => getenv('SMTP_PASSWORD') ?: '',
            'from_email' => getenv('MAIL_FROM_ADDRESS') ?: 'noreply@electrocitybd.com',
            'from_name' => getenv('MAIL_FROM_NAME') ?: 'ElectroCityBD',
            'debug' => getenv('MAIL_DEBUG') === 'true',
        ];
    }
    
    /**
     * Setup SMTP configuration
     */
    private function setupSMTP() {
        try {
            // Server settings
            if ($this->config['debug']) {
                $this->mailer->SMTPDebug = SMTP::DEBUG_SERVER;
            }
            
            $this->mailer->isSMTP();
            $this->mailer->Host = $this->config['smtp_host'];
            $this->mailer->SMTPAuth = true;
            $this->mailer->Username = $this->config['smtp_username'];
            $this->mailer->Password = $this->config['smtp_password'];
            $this->mailer->SMTPSecure = $this->config['smtp_secure'];
            $this->mailer->Port = $this->config['smtp_port'];
            
            // Default sender
            $this->mailer->setFrom(
                $this->config['from_email'],
                $this->config['from_name']
            );
            
            // Character set
            $this->mailer->CharSet = 'UTF-8';
            
        } catch (Exception $e) {
            error_log("Email Service Setup Error: " . $e->getMessage());
        }
    }
    
    /**
     * Send password reset email
     * 
     * @param string $email Recipient email
     * @param string $code 6-digit reset code
     * @param string $userName User's name
     * @return array Result with success status and message
     */
    public function sendPasswordResetEmail($email, $code, $userName = '') {
        try {
            // Clear previous recipients
            $this->mailer->clearAddresses();
            $this->mailer->clearAttachments();
            
            // Recipient
            $this->mailer->addAddress($email, $userName);
            
            // Content
            $this->mailer->isHTML(true);
            $this->mailer->Subject = 'Password Reset Code - ElectroCityBD';
            
            // Email body with 6-digit code
            $this->mailer->Body = $this->getPasswordResetTemplate($userName, $code);
            $this->mailer->AltBody = $this->getPasswordResetTextTemplate($userName, $code);
            
            // Send email
            $this->mailer->send();
            
            return [
                'success' => true,
                'message' => 'Password reset code sent successfully'
            ];
            
        } catch (Exception $e) {
            error_log("Email Send Error: " . $this->mailer->ErrorInfo);
            return [
                'success' => false,
                'message' => 'Failed to send email: ' . $this->mailer->ErrorInfo
            ];
        }
    }
    
    /**
     * Send welcome email to new users
     */
    public function sendWelcomeEmail($email, $userName) {
        try {
            $this->mailer->clearAddresses();
            $this->mailer->clearAttachments();
            
            $this->mailer->addAddress($email, $userName);
            $this->mailer->isHTML(true);
            $this->mailer->Subject = 'Welcome to ElectroCityBD!';
            
            $this->mailer->Body = $this->getWelcomeTemplate($userName);
            $this->mailer->AltBody = "Welcome to ElectroCityBD, $userName! Thank you for joining us.";
            
            $this->mailer->send();
            
            return ['success' => true, 'message' => 'Welcome email sent'];
        } catch (Exception $e) {
            error_log("Welcome Email Error: " . $this->mailer->ErrorInfo);
            return ['success' => false, 'message' => $this->mailer->ErrorInfo];
        }
    }
    
    /**
     * Send order confirmation email
     */
    public function sendOrderConfirmationEmail($email, $userName, $orderDetails) {
        try {
            $this->mailer->clearAddresses();
            $this->mailer->clearAttachments();
            
            $this->mailer->addAddress($email, $userName);
            $this->mailer->isHTML(true);
            $this->mailer->Subject = 'Order Confirmation - ElectroCityBD';
            
            $this->mailer->Body = $this->getOrderConfirmationTemplate($userName, $orderDetails);
            $this->mailer->AltBody = "Your order has been confirmed. Order ID: " . $orderDetails['order_id'];
            
            $this->mailer->send();
            
            return ['success' => true, 'message' => 'Order confirmation sent'];
        } catch (Exception $e) {
            error_log("Order Email Error: " . $this->mailer->ErrorInfo);
            return ['success' => false, 'message' => $this->mailer->ErrorInfo];
        }
    }
    
    /**
     * Generate reset link
     */
    private function getResetLink($token) {
        $baseUrl = getenv('APP_URL') ?: 'http://localhost:8000';
        return $baseUrl . '/reset-password?token=' . urlencode($token);
    }
    
    /**
     * HTML template for password reset email with 6-digit code
     */
    private function getPasswordResetTemplate($userName, $code) {
        $greeting = $userName ? "Hello $userName," : "Hello,";
        
        return <<<HTML
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
        .content { background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; }
        .code-box { background: #fff; border: 3px solid #667eea; padding: 20px; margin: 30px 0; border-radius: 10px; text-align: center; }
        .code { font-size: 48px; font-weight: bold; color: #667eea; letter-spacing: 10px; font-family: monospace; }
        .footer { text-align: center; margin-top: 30px; color: #666; font-size: 12px; }
        .warning { background: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 20px 0; }
        .info-box { background: #e3f2fd; border-left: 4px solid #2196F3; padding: 15px; margin: 20px 0; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🔐 Password Reset Code</h1>
        </div>
        <div class="content">
            <p>$greeting</p>
            
            <p>We received a request to reset your password for your ElectroCityBD account.</p>
            
            <p><strong>Your 6-digit reset code is:</strong></p>
            
            <div class="code-box">
                <div class="code">$code</div>
            </div>
            
            <div class="info-box">
                <strong>📝 How to use this code:</strong>
                <ol style="margin: 10px 0; padding-left: 20px;">
                    <li>Go back to the password reset page</li>
                    <li>Enter this 6-digit code</li>
                    <li>Enter your new password</li>
                    <li>Click "Reset Password"</li>
                </ol>
            </div>
            
            <div class="warning">
                <strong>⚠️ Security Notice:</strong>
                <ul style="margin: 10px 0; padding-left: 20px;">
                    <li>This code will expire in <strong>1 hour</strong></li>
                    <li>If you didn't request this, please ignore this email</li>
                    <li>Never share this code with anyone</li>
                    <li>Our team will never ask for this code</li>
                </ul>
            </div>
            
            <p>If you have any questions, please contact our support team.</p>
            
            <p>Best regards,<br>
            <strong>ElectroCityBD Team</strong></p>
        </div>
        <div class="footer">
            <p>© 2026 ElectroCityBD. All rights reserved.</p>
            <p>This is an automated email. Please do not reply.</p>
        </div>
    </div>
</body>
</html>
HTML;
    }
    
    /**
     * Plain text template for password reset email
     */
    private function getPasswordResetTextTemplate($userName, $code) {
        $greeting = $userName ? "Hello $userName," : "Hello,";
        
        return <<<TEXT
$greeting

We received a request to reset your password for your ElectroCityBD account.

Your 6-digit Reset Code: $code

How to use:
1. Go back to the password reset page
2. Enter this 6-digit code
3. Enter your new password
4. Click "Reset Password"

This code will expire in 1 hour.

If you didn't request this password reset, please ignore this email.

Best regards,
ElectroCityBD Team

---
© 2026 ElectroCityBD. All rights reserved.
This is an automated email. Please do not reply.
TEXT;
    }
    
    /**
     * Welcome email template
     */
    private function getWelcomeTemplate($userName) {
        return <<<HTML
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
        .content { background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🎉 Welcome to ElectroCityBD!</h1>
        </div>
        <div class="content">
            <p>Hello $userName,</p>
            <p>Thank you for joining ElectroCityBD! We're excited to have you as part of our community.</p>
            <p>Start exploring our wide range of electronic products and enjoy shopping with us!</p>
            <p>Best regards,<br><strong>ElectroCityBD Team</strong></p>
        </div>
    </div>
</body>
</html>
HTML;
    }
    
    /**
     * Order confirmation template
     */
    private function getOrderConfirmationTemplate($userName, $orderDetails) {
        $orderId = $orderDetails['order_id'] ?? 'N/A';
        $total = $orderDetails['total'] ?? '0';
        
        return <<<HTML
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
        .content { background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; }
        .order-box { background: white; border: 2px solid #667eea; padding: 20px; margin: 20px 0; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>✅ Order Confirmed!</h1>
        </div>
        <div class="content">
            <p>Hello $userName,</p>
            <p>Thank you for your order! We've received your order and it's being processed.</p>
            <div class="order-box">
                <p><strong>Order ID:</strong> $orderId</p>
                <p><strong>Total Amount:</strong> ৳$total</p>
            </div>
            <p>We'll send you another email when your order ships.</p>
            <p>Best regards,<br><strong>ElectroCityBD Team</strong></p>
        </div>
    </div>
</body>
</html>
HTML;
    }
    
    /**
     * Test email configuration
     */
    public function testConnection() {
        try {
            $this->mailer->smtpConnect();
            return [
                'success' => true,
                'message' => 'SMTP connection successful'
            ];
        } catch (Exception $e) {
            return [
                'success' => false,
                'message' => 'SMTP connection failed: ' . $e->getMessage()
            ];
        }
    }
}
?>
