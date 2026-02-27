# Order Database Update Fix

## সমস্যা (Problem)
অর্ডার প্লেস করার পর ডাটাবেসে আপডেট হচ্ছিল না এবং ইউজার প্রোফাইলের My Orders সেকশনে দেখাচ্ছিল না।

## মূল কারণ (Root Causes)

### 1. Cart Dependency Issue
`Order::create()` method এ `Cart` class এর instance তৈরি করা হচ্ছিল যা dependency issue তৈরি করতে পারে।

### 2. Error Logging Missing
Order creation fail হলে কোন error log ছিল না, তাই debug করা কঠিন ছিল।

### 3. Stock Update Logic
Stock update এ check ছিল না যে যথেষ্ট stock আছে কিনা।

### 4. Order Items Missing
`getAllOrders()` এবং `getUserOrders()` method order items return করছিল না।

## সমাধান (Solutions)

### 1. Direct Cart Clear Query
Cart class dependency remove করে direct SQL query ব্যবহার করা হয়েছে:

```php
// Before
$cart = new Cart($this->conn);
$cart->clearCart($this->user_id);

// After
$clear_query = "DELETE FROM cart WHERE user_id = :user_id";
$clear_stmt = $this->conn->prepare($clear_query);
$clear_stmt->bindParam(":user_id", $this->user_id);
$clear_stmt->execute();
```

### 2. Error Logging Added
Exception catch করার সময় error log করা হচ্ছে:

```php
catch (Exception $e) {
    $this->conn->rollBack();
    error_log("Order creation failed: " . $e->getMessage());
    return false;
}
```

### 3. Stock Update with Validation
Stock update এ check করা হচ্ছে যে যথেষ্ট stock আছে কিনা:

```php
$stock_query = "UPDATE products SET stock_quantity = stock_quantity - :qty
               WHERE product_id = :product_id AND stock_quantity >= :qty";
```

### 4. Order Items Included
`getAllOrders()` এবং `getUserOrders()` method এ order items fetch করা হচ্ছে:

```php
// Get items for each order
foreach ($orders as &$order) {
    $item_query = "SELECT * FROM order_items WHERE order_id = :order_id";
    $item_stmt = $this->conn->prepare($item_query);
    $item_stmt->bindParam(':order_id', $order['order_id']);
    $item_stmt->execute();
    $order['items'] = $item_stmt->fetchAll(PDO::FETCH_ASSOC);
}
```

### 5. User Phone Number Added
`getAllOrders()` method এ user phone number যোগ করা হয়েছে:

```php
SELECT o.*, u.full_name, u.email, u.phone_number
FROM orders o
JOIN users u ON o.user_id = u.user_id
```

## পরীক্ষা (Testing)

### 1. Order Placement Test
```
1. Customer হিসেবে login করুন
2. Cart এ product add করুন
3. Checkout করুন এবং payment complete করুন
4. Order completion page দেখুন
```

### 2. Database Verification
```sql
-- Check if order was created
SELECT * FROM orders ORDER BY order_date DESC LIMIT 1;

-- Check if order items were created
SELECT * FROM order_items WHERE order_id = [last_order_id];

-- Check if cart was cleared
SELECT * FROM cart WHERE user_id = [user_id];

-- Check if stock was updated
SELECT product_id, product_name, stock_quantity 
FROM products 
WHERE product_id IN (SELECT product_id FROM order_items WHERE order_id = [last_order_id]);
```

### 3. User Profile Test
```
1. User profile এ যান
2. My Orders section এ click করুন
3. সব orders দেখা যাচ্ছে কিনা verify করুন
4. Order details সঠিক আছে কিনা check করুন
```

### 4. Admin Panel Test
```
1. Admin হিসেবে login করুন
2. Orders page এ যান
3. সব user orders দেখা যাচ্ছে কিনা verify করুন
4. Order status update করুন
5. User profile এ গিয়ে updated status দেখুন
```

## ফাইল পরিবর্তন (Files Modified)

### backend/models/orders.php
- ✅ Cart dependency removed from `create()` method
- ✅ Error logging added
- ✅ Stock update validation added
- ✅ `getAllOrders()` now includes order items
- ✅ `getUserOrders()` now includes order items
- ✅ User phone number added to admin orders

## API Endpoints

### POST /orders
Creates a new order
- Requires authentication
- Accepts order data with items
- Returns order_id and order_code

### GET /orders
Returns user's orders with items
- Requires authentication
- Returns array of orders

### GET /orders?admin=true
Returns all orders (admin only)
- Requires admin authentication
- Returns array of all orders with user details

### PUT /orders?id={order_id}
Updates order status (admin only)
- Requires admin authentication
- Accepts status in request body

## Database Tables

### orders
```sql
- order_id (PK)
- user_id (FK)
- total_amount
- order_status
- payment_method
- payment_status
- delivery_address
- transaction_id
- estimated_delivery
- order_date
```

### order_items
```sql
- order_item_id (PK)
- order_id (FK)
- product_id (FK)
- product_name
- quantity
- price_at_purchase
- color
- image_url
```

## Expected Behavior

### After Order Placement:
1. ✅ Order saved to `orders` table
2. ✅ Order items saved to `order_items` table
3. ✅ Cart cleared for user
4. ✅ Product stock updated
5. ✅ Best sellers updated
6. ✅ Trending products updated
7. ✅ Order appears in user's My Orders
8. ✅ Order appears in admin panel
9. ✅ Order includes all items with details

### Error Handling:
1. ✅ Transaction rollback on failure
2. ✅ Error logged to PHP error log
3. ✅ User sees appropriate error message
4. ✅ Cart not cleared if order fails

## Debugging

### Check PHP Error Log
```bash
# Linux/Mac
tail -f /var/log/php/error.log

# Windows (XAMPP)
tail -f C:\xampp\php\logs\php_error_log

# Check for "Order creation failed" messages
```

### Enable Debug Mode
Add to `backend/api/bootstrap.php`:
```php
ini_set('display_errors', '1');
error_reporting(E_ALL);
```

### Test Order Creation Directly
```php
// Test script
require_once 'backend/api/bootstrap.php';
require_once 'backend/models/orders.php';

$db = db();
$order = new Order($db);
$order->user_id = 1;
$order->total_amount = 100.00;
$order->payment_method = 'bKash';
$order->delivery_address = 'Test Address';
$order->transaction_id = 'TEST123';
$order->estimated_delivery = '5 days';

$items = [
    [
        'product_id' => 1,
        'product_name' => 'Test Product',
        'quantity' => 1,
        'price' => 100.00,
        'image_url' => 'test.jpg'
    ]
];

$result = $order->create($items);
echo $result ? "Success: Order ID " . $order->order_id : "Failed";
```

## সমাপ্তি (Conclusion)
এই পরিবর্তনগুলির মাধ্যমে:
- ✅ Orders এখন সঠিকভাবে database এ save হচ্ছে
- ✅ User profile এ My Orders দেখাচ্ছে
- ✅ Admin panel এ সব orders দেখাচ্ছে
- ✅ Order items সহ সব details পাওয়া যাচ্ছে
- ✅ Error handling উন্নত হয়েছে
- ✅ Stock management সঠিকভাবে কাজ করছে
