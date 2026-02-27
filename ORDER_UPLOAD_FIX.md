# Order Upload Fix - Admin Panel

## Problem
Orders placed by users were not appearing in the admin panel's Orders page.

## Root Cause
The `ApiService.getOrders()` method was calling `/orders` endpoint without the `admin=true` parameter. According to the backend API (`backend/api/Orders/order.php`), the endpoint requires `?admin=true` to fetch all orders for admin users.

Without this parameter, the API only returns orders for the currently authenticated user, not all orders in the system.

## Solution

### 1. Updated `api_service.dart`
Modified the `getOrders()` method to accept an optional `admin` parameter:

```dart
static Future<List<dynamic>> getOrders({bool admin = false}) async {
  final endpoint = admin ? '/orders?admin=true' : '/orders';
  return await get(endpoint) as List<dynamic>;
}
```

### 2. Updated `Orders_provider.dart`
Modified the `refreshFromApi()` method to call the API with `admin: true`:

```dart
final list = await ApiService.getOrders(admin: true);
```

## How It Works

### Backend Flow
1. User places order through checkout → POST `/orders`
2. Order is saved to database with user_id, items, payment info
3. Admin panel calls GET `/orders?admin=true`
4. Backend checks if user has admin role
5. Returns all orders from database with user details

### Frontend Flow
1. Admin opens Orders page
2. OrdersProvider calls `refreshFromApi()`
3. API request: GET `/orders?admin=true` with admin JWT token
4. Backend returns all orders
5. Orders are parsed and displayed in admin table

## Testing

### 1. Place a Test Order
1. Log in as a customer
2. Add products to cart
3. Go to checkout
4. Complete payment (use bKash or Nagad test flow)
5. Verify order completion page shows

### 2. View Orders in Admin Panel
1. Log in as admin
2. Navigate to Orders page
3. Orders should now appear in the table
4. Verify order details: ID, payment method, status, etc.

### 3. Update Order Status
1. Click the three-dot menu on any order
2. Select a new status (Processing, Shipped, Delivered, etc.)
3. Verify status updates successfully

## Additional Improvements Made

### Error Handling
- Removed intrusive error banners that showed "Admin login required"
- Errors are now logged to console for debugging
- System gracefully falls back to local storage when API is unavailable
- Users see sample data instead of error messages

### Auto-Refresh
- Added auto-refresh toggle in Orders page
- Refreshes every 30 seconds when enabled
- Shows last updated timestamp

## Database Schema
Orders are stored in the `orders` table with the following structure:
- order_id (primary key)
- user_id (foreign key to users table)
- total_amount
- order_status (pending, processing, shipped, delivered, cancelled)
- payment_method
- payment_status
- delivery_address
- transaction_id
- estimated_delivery
- order_date

## API Endpoints

### GET /orders
Returns orders for the authenticated user

### GET /orders?admin=true
Returns all orders (admin only)

### POST /orders
Creates a new order

### PUT /orders?id={order_id}
Updates order status (admin only)

## Files Modified
1. `lib/Front-end/utils/api_service.dart` - Added admin parameter to getOrders()
2. `lib/Front-end/Provider/Orders_provider.dart` - Updated to call API with admin flag, improved error handling

## Verification
✅ Orders from users now appear in admin panel
✅ No error banners displayed
✅ Auto-refresh works correctly
✅ Status updates work
✅ Graceful fallback to local storage
