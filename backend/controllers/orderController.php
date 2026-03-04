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
        // Log the incoming request for debugging
        error_log("Order creation attempt - User ID: $user_id");
        error_log("Order data: " . json_encode($data));
        
        if (!isset($data['payment_method']) || !isset($data['delivery_address'])) {
            http_response_code(400);
            error_log("Order creation failed: Missing payment_method or delivery_address");
            return ['message' => 'Payment method and delivery address required'];
        }
        
        // Prefer items provided by client; fallback to server cart
        $cart_items = [];
        $total = 0.0;
        if (isset($data['items']) && is_array($data['items']) && count($data['items']) > 0) {
            foreach ($data['items'] as $it) {
                $pid = isset($it['product_id']) ? (int)$it['product_id'] : 0;
                $name = ($it['product_name'] ?? $it['name'] ?? '');
                $qty = (int)($it['quantity'] ?? 1);
                $price = (float)($it['price'] ?? 0);
                $disc = isset($it['discounted_price']) ? (float)$it['discounted_price'] : null;
                $img = ($it['image_url'] ?? $it['imageUrl'] ?? '');
                if ($qty <= 0) continue;
                
                // ✅ Stock Validation - Check if product has enough stock
                if ($pid > 0) {
                    $stock_query = "SELECT stock_quantity FROM products WHERE product_id = ?";
                    $stmt = $this->db->prepare($stock_query);
                    $stmt->execute([$pid]);
                    $product = $stmt->fetch(PDO::FETCH_ASSOC);
                    
                    if ($product) {
                        $available_stock = (int)$product['stock_quantity'];
                        if ($available_stock < $qty) {
                            http_response_code(400);
                            error_log("Order creation failed: Insufficient stock for product $pid. Requested: $qty, Available: $available_stock");
                            return [
                                'message' => "Insufficient stock for $name. Available: $available_stock, Requested: $qty",
                                'error_type' => 'insufficient_stock',
                                'product_id' => $pid,
                                'product_name' => $name,
                                'available_stock' => $available_stock,
                                'requested_quantity' => $qty
                            ];
                        }
                    }
                }
                
                $cart_items[] = [
                    'product_id' => $pid, // 0 allowed for non-DB items
                    'product_name' => $name,
                    'quantity' => $qty,
                    'price' => $price,
                    'discounted_price' => $disc,
                    'image_url' => $img,
                ];
                $line = ($disc !== null ? $disc : $price) * $qty;
                $total += $line;
            }
            if (empty($cart_items)) {
                http_response_code(400);
                error_log("Order creation failed: No valid items in request");
                return ['message' => 'No valid items in request'];
            }
        } else {
            // Fallback: use server-side cart with stock validation
            $cart = new Cart($this->db);
            $cart_items = $cart->getUserCart($user_id);
            if (empty($cart_items)) {
                http_response_code(400);
                error_log("Order creation failed: Cart is empty for user $user_id");
                return ['message' => 'Cart is empty'];
            }
            
            // ✅ Validate stock for cart items
            foreach ($cart_items as $item) {
                $pid = (int)$item['product_id'];
                $qty = (int)$item['quantity'];
                
                if ($pid > 0) {
                    $stock_query = "SELECT stock_quantity, product_name FROM products WHERE product_id = ?";
                    $stmt = $this->db->prepare($stock_query);
                    $stmt->execute([$pid]);
                    $product = $stmt->fetch(PDO::FETCH_ASSOC);
                    
                    if ($product) {
                        $available_stock = (int)$product['stock_quantity'];
                        if ($available_stock < $qty) {
                            http_response_code(400);
                            error_log("Order creation failed: Insufficient stock for product $pid");
                            return [
                                'message' => "Insufficient stock for {$product['product_name']}. Available: $available_stock, Requested: $qty",
                                'error_type' => 'insufficient_stock',
                                'product_id' => $pid,
                                'product_name' => $product['product_name'],
                                'available_stock' => $available_stock,
                                'requested_quantity' => $qty
                            ];
                        }
                    }
                }
            }
            
            $total = $cart->getCartTotal($user_id);
        }
        
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
            $orderId = $this->order->order_id;
            $code = 'EC-' . date('Ymd') . '-' . $orderId;
            error_log("Order created successfully - Order ID: $orderId, Code: $code");
            return [
                'message' => 'Order created successfully',
                'order_id' => $orderId,
                'order_code' => $code,
            ];
        }
        
        http_response_code(500);
        error_log("Order creation failed: Database error");
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
