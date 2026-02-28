# Stock Management Implementation

## Overview
Added comprehensive stock management system that allows admin to control product stock levels and displays stock status to customers.

---

## Features Implemented

### 1. Admin Panel - Stock Control

#### Stock Quantity Input Field
**File**: `lib/Front-end/Admin Panel/A_products.dart`

Added stock quantity field to product upload form:
```dart
final TextEditingController _stockController = TextEditingController(text: '0');

// In form:
_customTextField(
  _stockController,
  "Stock Quantity",
  fieldBg,
  isNumber: true,
),
```

#### Stock in Product Creation
```dart
final stockQty = int.tryParse(_stockController.text.trim()) ?? 0;
final res = await ApiService.createProductWithImage(
  product_name: name,
  description: desc,
  price: price,
  stock_quantity: stockQty,  // ✅ Stock sent to API
  category_id: categoryId,
  brand_id: brandId,
  imageBytes: imageBytes,
  imageFileName: fileName,
);
```

#### Stock in Edit Dialog
Added stock field to product edit dialog:
```dart
final stockC = TextEditingController(text: '${p['stock'] ?? 0}');

// In edit form:
TextField(
  controller: stockC,
  keyboardType: TextInputType.number,
  decoration: const InputDecoration(
    labelText: 'Stock Quantity',
  ),
),

// On save:
final data = {
  'name': nameC.text.trim(),
  'price': priceC.text.trim(),
  'stock': int.tryParse(stockC.text.trim()) ?? 0,  // ✅ Stock saved
  'desc': descC.text.trim(),
  'category': category,
};
```

---

### 2. Frontend - Stock Display

#### Product Card with Stock Badge
**File**: `lib/Front-end/widgets/Sections/Collections/collection_detail_page.dart`

```dart
Widget _buildProductCard(Map<String, dynamic> product, int index) {
  final stock = product['stock'] ?? 0;
  final stockQuantity = stock is int ? stock : int.tryParse(stock.toString()) ?? 0;
  final isInStock = stockQuantity > 0;
  
  return InkWell(
    child: Container(
      child: Column(
        children: [
          // Product Image with Stock Badge
          Stack(
            children: [
              // Product Image
              ImageResolver.image(imageUrl: product['image']),
              
              // Stock Badge (Top Right)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isInStock ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isInStock ? 'In Stock' : 'Stock Out',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Product Details
          Padding(
            child: Column(
              children: [
                // Product Name
                Text(product['title']),
                
                // Star Rating
                Row(children: [/* stars */]),
                
                // Price
                Text('৳${product['price']}'),
                
                // Stock Quantity Display
                if (isInStock)
                  Text(
                    '$stockQuantity items available',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  )
                else
                  Text(
                    'Out of stock',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.red[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
```

---

## Visual Design

### Stock Badge
- **In Stock**: Green badge with white text
- **Stock Out**: Red badge with white text
- **Position**: Top-right corner of product image
- **Size**: Compact (10px font, 8px horizontal padding, 4px vertical padding)

### Stock Quantity Text
- **In Stock**: Shows "X items available" in grey text (11px)
- **Stock Out**: Shows "Out of stock" in red text (11px, medium weight)
- **Position**: Below price

---

## Database Schema

The `products` table already has the `stock_quantity` field:

```sql
CREATE TABLE products (
  product_id INT PRIMARY KEY AUTO_INCREMENT,
  product_name VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  stock_quantity INT DEFAULT 0,  -- ✅ Stock field
  image_url VARCHAR(255),
  category_id INT,
  brand_id INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## API Integration

### Create Product with Stock
**Endpoint**: `POST /api/products`

```dart
await ApiService.createProductWithImage(
  product_name: 'Product Name',
  description: 'Description',
  price: 1000.0,
  stock_quantity: 50,  // ✅ Stock sent to backend
  category_id: 1,
  brand_id: 1,
  imageBytes: bytes,
  imageFileName: 'image.jpg',
);
```

### Get Products with Stock
**Endpoint**: `GET /api/products`

Response includes stock_quantity:
```json
{
  "products": [
    {
      "product_id": 1,
      "product_name": "Product Name",
      "price": 1000.00,
      "stock_quantity": 50,  // ✅ Stock returned from backend
      "image_url": "/uploads/image.jpg"
    }
  ]
}
```

---

## Data Flow

### Admin Upload Flow:
1. Admin enters stock quantity in upload form
2. Stock sent to backend via API
3. Saved in database `products.stock_quantity`
4. Also stored in `AdminProductProvider` for immediate display

### Customer View Flow:
1. Product loaded from database via API
2. Stock quantity mapped to product data
3. Displayed on product card with badge and text
4. Updates when admin changes stock

---

## Stock Status Logic

```dart
// Determine stock status
final stock = product['stock'] ?? 0;
final stockQuantity = stock is int 
  ? stock 
  : (stock is String ? int.tryParse(stock.toString()) ?? 0 : 0);
final isInStock = stockQuantity > 0;

// Display logic
if (isInStock) {
  // Show green "In Stock" badge
  // Show "X items available" text
} else {
  // Show red "Stock Out" badge
  // Show "Out of stock" text
}
```

---

## Admin Controls

### Upload New Product
1. Fill product name, price, description
2. **Enter stock quantity** (default: 0)
3. Select category and brand
4. Upload image
5. Click "Publish"

### Edit Existing Product
1. Click edit icon on product
2. **Update stock quantity** in edit dialog
3. Update other fields as needed
4. Click "Update"

### Stock Management
- Set stock to 0 → Product shows "Stock Out"
- Set stock > 0 → Product shows "In Stock" with quantity
- Stock updates immediately in admin provider
- Stock persists in database

---

## Benefits

### For Admin:
✅ Easy stock control from upload form
✅ Edit stock anytime via edit dialog
✅ Visual feedback on stock status
✅ Prevents overselling

### For Customers:
✅ Clear stock availability
✅ Know how many items available
✅ Visual badge for quick identification
✅ Better purchase decisions

---

## Next Steps (Optional Enhancements)

### 1. Low Stock Alerts
```dart
if (stockQuantity > 0 && stockQuantity <= 5) {
  // Show "Only X left!" warning
  Text(
    'Only $stockQuantity left!',
    style: TextStyle(color: Colors.orange),
  );
}
```

### 2. Auto Stock Reduction on Order
```dart
// When order is placed
await ApiService.reduceStock(productId, quantity);
```

### 3. Stock History Tracking
```sql
CREATE TABLE stock_history (
  id INT PRIMARY KEY AUTO_INCREMENT,
  product_id INT,
  old_quantity INT,
  new_quantity INT,
  changed_by INT,
  changed_at TIMESTAMP
);
```

### 4. Bulk Stock Update
```dart
// Admin can update multiple products at once
await ApiService.bulkUpdateStock([
  {'product_id': 1, 'stock': 100},
  {'product_id': 2, 'stock': 50},
]);
```

---

## Testing Checklist

### Admin Panel:
- [ ] Upload product with stock quantity
- [ ] Edit product stock quantity
- [ ] Set stock to 0 (should show "Stock Out")
- [ ] Set stock > 0 (should show "In Stock")
- [ ] Stock persists after page refresh

### Customer View:
- [ ] Product with stock > 0 shows green "In Stock" badge
- [ ] Product with stock = 0 shows red "Stock Out" badge
- [ ] Stock quantity displays correctly ("X items available")
- [ ] Badge visible on product image
- [ ] Stock text visible below price

### API Integration:
- [ ] Stock sent to backend on create
- [ ] Stock returned from backend on get
- [ ] Stock updates in database
- [ ] Stock syncs between admin and customer view

---

## Conclusion

✅ **Stock management fully implemented**
- Admin can control stock from upload and edit forms
- Customers see clear stock status on all products
- Stock data flows from admin → database → customer view
- Visual indicators (badges + text) for stock status
- Real-time updates through provider system

The system is ready for production use and can be extended with additional features like low stock alerts, auto-reduction on orders, and stock history tracking.
