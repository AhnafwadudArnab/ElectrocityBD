<?php
/**
 * bKash Payment Gateway Integration
 * 
 * This is a reference implementation. DO NOT use directly in production.
 * Update credentials, add proper error handling, and test thoroughly.
 */

header('Content-Type: application/json');
require_once __DIR__ . '/../../backend/api/bootstrap.php';
require_once __DIR__ . '/../../backend/config/cors.php';

class BkashPayment {
    private $db;
    private $username;
    private $password;
    private $app_key;
    private $app_secret;
    private $base_url;
    
    public function __construct($db) {
        $this->db = $db;
        
        // Load from .env file
        $this->username = getenv('BKASH_USERNAME') ?: 'sandboxTokenizedUser02';
        $this->password = getenv('BKASH_PASSWORD') ?: 'sandboxTokenizedUser02@12345';
        $this->app_key = getenv('BKASH_APP_KEY') ?: '4f6o0cjiki2rfm34kfdadl1eqq';
        $this->app_secret = getenv('BKASH_APP_SECRET') ?: '2is7hdktrekvrbljjh44ll3d9l1dtjo4pasmjvs5vl5qr3fug4b';
        $this->base_url = getenv('BKASH_BASE_URL') ?: 'https://tokenized.sandbox.bka.sh/v1.2.0-beta';
    }
    
    /**
     * Get grant token from bKash
     */
    public function grantToken() {
        $url = $this->base_url . '/tokenized/checkout/token/grant';
        
        $data = [
            'app_key' => $this->app_key,
            'app_secret' => $this->app_secret
        ];
        
        $headers = [
            'Content-Type: application/json',
            'username: ' . $this->app_key,
            'password: ' . $this->app_secret
        ];
        
        $response = $this->makeRequest($url, 'POST', $data, $headers);
        
        if (isset($response['id_token'])) {
            return $response['id_token'];
        }
        
        throw new Exception('Failed to get grant token: ' . json_encode($response));
    }
    
    /**
     * Create payment
     */
    public function createPayment($amount, $orderId, $customerMobile, $callbackUrl) {
        $token = $this->grantToken();
        
        $url = $this->base_url . '/tokenized/checkout/create';
        
        $invoiceNumber = 'INV-' . $orderId . '-' . time();
        
        $data = [
            'mode' => '0011',
            'payerReference' => $customerMobile,
            'callbackURL' => $callbackUrl,
            'amount' => (string)$amount,
            'currency' => 'BDT',
            'intent' => 'sale',
            'merchantInvoiceNumber' => $invoiceNumber
        ];
        
        $headers = [
            'Content-Type: application/json',
            'Authorization: ' . $token,
            'X-APP-Key: ' . $this->app_key
        ];
        
        $response = $this->makeRequest($url, 'POST', $data, $headers);
        
        if (isset($response['paymentID'])) {
            // Save to database
            $stmt = $this->db->prepare('
                INSERT INTO bkash_transactions 
                (order_id, user_id, payment_id, amount, merchant_invoice_number, status)
                VALUES (?, ?, ?, ?, ?, ?)
            ');
            
            $userId = $this->getUserIdFromOrder($orderId);
            
            $stmt->execute([
                $orderId,
                $userId,
                $response['paymentID'],
                $amount,
                $invoiceNumber,
                'pending'
            ]);
            
            return [
                'success' => true,
                'paymentID' => $response['paymentID'],
                'bkashURL' => $response['bkashURL']
            ];
        }
        
        throw new Exception('Failed to create payment: ' . json_encode($response));
    }
    
    /**
     * Execute payment
     */
    public function executePayment($paymentId) {
        $token = $this->grantToken();
        
        $url = $this->base_url . '/tokenized/checkout/execute';
        
        $data = [
            'paymentID' => $paymentId
        ];
        
        $headers = [
            'Content-Type: application/json',
            'Authorization: ' . $token,
            'X-APP-Key: ' . $this->app_key
        ];
        
        $response = $this->makeRequest($url, 'POST', $data, $headers);
        
        if (isset($response['transactionStatus']) && $response['transactionStatus'] === 'Completed') {
            // Update database
            $stmt = $this->db->prepare('
                UPDATE bkash_transactions 
                SET trx_id = ?, status = ?, payment_execute_time = NOW(), updated_at = NOW()
                WHERE payment_id = ?
            ');
            
            $stmt->execute([
                $response['trxID'],
                'completed',
                $paymentId
            ]);
            
            // Update order status
            $this->updateOrderStatus($paymentId, 'paid');
            
            return [
                'success' => true,
                'trxID' => $response['trxID'],
                'amount' => $response['amount']
            ];
        }
        
        // Payment failed
        $stmt = $this->db->prepare('
            UPDATE bkash_transactions 
            SET status = ?, updated_at = NOW()
            WHERE payment_id = ?
        ');
        
        $stmt->execute(['failed', $paymentId]);
        
        throw new Exception('Payment execution failed: ' . json_encode($response));
    }
    
    /**
     * Query payment status
     */
    public function queryPayment($paymentId) {
        $token = $this->grantToken();
        
        $url = $this->base_url . '/tokenized/checkout/payment/status';
        
        $data = [
            'paymentID' => $paymentId
        ];
        
        $headers = [
            'Content-Type: application/json',
            'Authorization: ' . $token,
            'X-APP-Key: ' . $this->app_key
        ];
        
        $response = $this->makeRequest($url, 'POST', $data, $headers);
        
        return $response;
    }
    
    /**
     * Make HTTP request
     */
    private function makeRequest($url, $method, $data, $headers) {
        $ch = curl_init($url);
        
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        
        if ($method === 'POST') {
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
        }
        
        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        
        curl_close($ch);
        
        $decoded = json_decode($response, true);
        
        if ($httpCode >= 200 && $httpCode < 300) {
            return $decoded;
        }
        
        throw new Exception('HTTP Error ' . $httpCode . ': ' . $response);
    }
    
    /**
     * Get user ID from order
     */
    private function getUserIdFromOrder($orderId) {
        $stmt = $this->db->prepare('SELECT user_id FROM orders WHERE order_id = ?');
        $stmt->execute([$orderId]);
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['user_id'] ?? null;
    }
    
    /**
     * Update order status
     */
    private function updateOrderStatus($paymentId, $status) {
        $stmt = $this->db->prepare('
            UPDATE orders o
            INNER JOIN bkash_transactions bt ON o.order_id = bt.order_id
            SET o.payment_status = ?
            WHERE bt.payment_id = ?
        ');
        
        $stmt->execute([$status, $paymentId]);
    }
}

// API Endpoints
$db = db();
$bkash = new BkashPayment($db);
$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';

if ($method === 'OPTIONS') {
    http_response_code(200);
    exit;
}

try {
    // Create payment
    if ($method === 'POST' && isset($_GET['action']) && $_GET['action'] === 'create') {
        $token = getBearerToken();
        if (!$token) {
            throw new Exception('Unauthorized');
        }
        
        $decoded = JWT::verify($token);
        if (!$decoded) {
            throw new Exception('Invalid token');
        }
        
        $data = json_decode(file_get_contents('php://input'), true);
        
        $amount = $data['amount'] ?? 0;
        $orderId = $data['order_id'] ?? 0;
        $mobile = $data['mobile'] ?? '';
        $callbackUrl = $data['callback_url'] ?? '';
        
        if ($amount <= 0 || $orderId <= 0 || empty($mobile)) {
            throw new Exception('Invalid parameters');
        }
        
        $result = $bkash->createPayment($amount, $orderId, $mobile, $callbackUrl);
        
        echo json_encode($result);
        exit;
    }
    
    // Execute payment
    if ($method === 'POST' && isset($_GET['action']) && $_GET['action'] === 'execute') {
        $data = json_decode(file_get_contents('php://input'), true);
        
        $paymentId = $data['payment_id'] ?? '';
        
        if (empty($paymentId)) {
            throw new Exception('Payment ID required');
        }
        
        $result = $bkash->executePayment($paymentId);
        
        echo json_encode($result);
        exit;
    }
    
    // Query payment
    if ($method === 'GET' && isset($_GET['action']) && $_GET['action'] === 'query') {
        $paymentId = $_GET['payment_id'] ?? '';
        
        if (empty($paymentId)) {
            throw new Exception('Payment ID required');
        }
        
        $result = $bkash->queryPayment($paymentId);
        
        echo json_encode($result);
        exit;
    }
    
    throw new Exception('Invalid action');
    
} catch (Exception $e) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'message' => $e->getMessage()
    ]);
}
