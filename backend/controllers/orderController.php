<?php
require_once __DIR__ . '/../models/orders.php';
require_once __DIR__ . '/../models/carts.php';

class OrderController {
    private $db;
    private $order;
    
    public function __construct($db) {
        $this->db = $db;
        $this->order = new Order($db);
    }
    
    public function createOrder($user_id, $data) {
        if (!isset($data['payment_method']) || !isset($data['delivery_address'])) {
            http_response_code(400);
            return ['message' => 'Payment method and delivery address required'];
        }
        
        // Get cart items
        $cart = new Cart($this->db);
        $cart_items = $cart->getUserCart($user_id);
        
        if (empty($cart_items)) {
            http_response_code(400);
            return ['message' => 'Cart is empty'];
        }
        
        $total = $cart->getCartTotal($user_id);
        $couponDiscount = 0.0;
        if (isset($data['coupon_discount'])) {
            $couponDiscount = max(0.0, (float)$data['coupon_discount']);
        }
        $total = max(0.0, (float)$total - $couponDiscount);
        
        $this->order->user_id = $user_id;
        $this->order->total_amount = $total;
        $this->order->payment_method = $data['payment_method'];
        $this->order->delivery_address = $data['delivery_address'];
        $this->order->transaction_id = $data['transaction_id'] ?? null;
        $this->order->estimated_delivery = $data['estimated_delivery'] ?? '7-10 business days';
        
        if ($this->order->create($cart_items)) {
            return [
                'message' => 'Order created successfully',
                'order_id' => $this->order->order_id
            ];
        }
        
        http_response_code(500);
        return ['message' => 'Failed to create order'];
    }
    
    public function getUserOrders($user_id) {
        return $this->order->getUserOrders($user_id);
    }
    
    public function getOrderDetails($order_id, $user_id = null) {
        $order = $this->order->getOrderDetails($order_id, $user_id);
        
        if (!$order) {
            http_response_code(404);
            return ['message' => 'Order not found'];
        }
        
        return $order;
    }
    
    public function getAllOrders($data) {
        $limit = $data['limit'] ?? 100;
        $page = $data['page'] ?? 1;
        $offset = ($page - 1) * $limit;
        
        return $this->order->getAllOrders($limit, $offset);
    }
    
    public function updateStatus($order_id, $data, $admin_id) {
        if (!isset($data['status'])) {
            http_response_code(400);
            return ['message' => 'Status required'];
        }
        
        if ($this->order->updateStatus($order_id, $data['status'], $admin_id)) {
            return ['message' => 'Order status updated'];
        }
        
        http_response_code(500);
        return ['message' => 'Failed to update order'];
    }
}
?>
