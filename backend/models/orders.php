<?php
class Order {
    private $conn;
    private $table_name = "orders";
    
    public $order_id;
    public $user_id;
    public $total_amount;
    public $order_status;
    public $payment_method;
    public $payment_status;
    public $delivery_address;
    public $transaction_id;
    public $estimated_delivery;
    
    public function __construct($db) {
        $this->conn = $db;
    }
    
    public function create($cart_items) {
        try {
            $this->conn->beginTransaction();
            
            // Insert order
            $query = "INSERT INTO " . $this->table_name . "
                      (user_id, total_amount, payment_method, delivery_address, transaction_id, estimated_delivery)
                      VALUES (:user_id, :total, :payment_method, :address, :transaction_id, :estimated_delivery)";
            
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(":user_id", $this->user_id);
            $stmt->bindParam(":total", $this->total_amount);
            $stmt->bindParam(":payment_method", $this->payment_method);
            $stmt->bindParam(":address", $this->delivery_address);
            $stmt->bindParam(":transaction_id", $this->transaction_id);
            $stmt->bindParam(":estimated_delivery", $this->estimated_delivery);
            
            if (!$stmt->execute()) {
                throw new Exception("Failed to create order");
            }
            
            $this->order_id = $this->conn->lastInsertId();
            
            // Insert order items
            foreach ($cart_items as $item) {
                $item_query = "INSERT INTO order_items
                              (order_id, product_id, product_name, quantity, price_at_purchase, image_url)
                              VALUES (:order_id, :product_id, :product_name, :quantity, :price, :image)";
                
                $item_stmt = $this->conn->prepare($item_query);
                $item_stmt->bindParam(":order_id", $this->order_id);
                $item_stmt->bindParam(":product_id", $item['product_id']);
                $item_stmt->bindParam(":product_name", $item['product_name']);
                $item_stmt->bindParam(":quantity", $item['quantity']);
                $item_stmt->bindParam(":price", $item['discounted_price'] ?? $item['price']);
                $item_stmt->bindParam(":image", $item['image_url']);
                
                if (!$item_stmt->execute()) {
                    throw new Exception("Failed to create order items");
                }
                
                // Update stock
                $stock_query = "UPDATE products SET stock_quantity = stock_quantity - :qty
                               WHERE product_id = :product_id";
                if ((int)$item['product_id'] > 0) {
                    $stock_stmt = $this->conn->prepare($stock_query);
                    $stock_stmt->bindParam(":qty", $item['quantity']);
                    $stock_stmt->bindParam(":product_id", $item['product_id']);
                    $stock_stmt->execute();
                }
                
                // Update best_sellers
                if ((int)$item['product_id'] > 0) {
                    $best_query = "INSERT INTO best_sellers (product_id, sales_count) 
                                   VALUES (:product_id, :qty)
                                   ON DUPLICATE KEY UPDATE 
                                   sales_count = sales_count + :qty, last_updated = NOW()";
                    $best_stmt = $this->conn->prepare($best_query);
                    $best_stmt->bindParam(":product_id", $item['product_id']);
                    $best_stmt->bindParam(":qty", $item['quantity']);
                    $best_stmt->execute();
                }
                
                // Update trending score (simple algorithm: +1 for each purchase)
                if ((int)$item['product_id'] > 0) {
                    $trend_query = "INSERT INTO trending_products (product_id, trending_score) 
                                   VALUES (:product_id, 1)
                                   ON DUPLICATE KEY UPDATE 
                                   trending_score = trending_score + 1, last_updated = NOW()";
                    $trend_stmt = $this->conn->prepare($trend_query);
                    $trend_stmt->bindParam(":product_id", $item['product_id']);
                    $trend_stmt->execute();
                }
            }
            
            // Clear cart
            $cart = new Cart($this->conn);
            $cart->clearCart($this->user_id);
            
            $this->conn->commit();
            return true;
            
        } catch (Exception $e) {
            $this->conn->rollBack();
            return false;
        }
    }
    
    public function getUserOrders($user_id) {
        $query = "SELECT o.*, 
                         COUNT(oi.order_item_id) as item_count
                  FROM " . $this->table_name . " o
                  LEFT JOIN order_items oi ON o.order_id = oi.order_id
                  WHERE o.user_id = :user_id
                  GROUP BY o.order_id
                  ORDER BY o.order_date DESC";
        
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':user_id', $user_id);
        $stmt->execute();
        
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    
    public function getOrderDetails($order_id, $user_id = null) {
        $query = "SELECT o.* FROM " . $this->table_name . " o WHERE o.order_id = :order_id";
        
        if ($user_id) {
            $query .= " AND o.user_id = :user_id";
        }
        
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':order_id', $order_id);
        
        if ($user_id) {
            $stmt->bindParam(':user_id', $user_id);
        }
        
        $stmt->execute();
        $order = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($order) {
            // Get items
            $item_query = "SELECT * FROM order_items WHERE order_id = :order_id";
            $item_stmt = $this->conn->prepare($item_query);
            $item_stmt->bindParam(':order_id', $order_id);
            $item_stmt->execute();
            $order['items'] = $item_stmt->fetchAll(PDO::FETCH_ASSOC);
        }
        
        return $order;
    }
    
    public function updateStatus($order_id, $status, $admin_id) {
        $query = "UPDATE " . $this->table_name . "
                  SET order_status = :status
                  WHERE order_id = :order_id";
        
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':status', $status);
        $stmt->bindParam(':order_id', $order_id);
        
        return $stmt->execute();
    }
    
    public function getAllOrders($limit = 100, $offset = 0) {
        $query = "SELECT o.*, u.full_name, u.email
                  FROM " . $this->table_name . " o
                  JOIN users u ON o.user_id = u.user_id
                  ORDER BY o.order_date DESC
                  LIMIT :limit OFFSET :offset";
        
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':limit', $limit, PDO::PARAM_INT);
        $stmt->bindParam(':offset', $offset, PDO::PARAM_INT);
        $stmt->execute();
        
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
}
?>
