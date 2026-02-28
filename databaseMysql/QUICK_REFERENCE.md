# Database Quick Reference

## 🚀 Quick Setup

```bash
# Windows
cd databaseMysql
setup_database.bat

# Mac/Linux
cd databaseMysql
./setup_database.sh

# Manual
mysql -u root -p < COMPLETE_DATABASE_SETUP.sql
```

## 📊 Database Stats

| Item | Count |
|------|-------|
| Tables | 24 |
| Products | 10 |
| Categories | 6 |
| Brands | 5 |
| Collections | 14 |
| Collection Items | 10+ |
| Banners | 7 |

## 🗂️ Key Tables

### Collections
```sql
-- Get all collections
SELECT * FROM collections WHERE is_active = TRUE ORDER BY display_order;

-- Get collection with items
SELECT c.*, COUNT(ci.item_id) as item_count
FROM collections c
LEFT JOIN collection_items ci ON c.collection_id = ci.collection_id
WHERE c.slug = 'fans'
GROUP BY c.collection_id;

-- Get products in collection
SELECT p.* FROM products p
JOIN collection_products cp ON p.product_id = cp.product_id
JOIN collections c ON cp.collection_id = c.collection_id
WHERE c.slug = 'fans';
```

### Banners
```sql
-- Get active hero banners
SELECT * FROM banners 
WHERE banner_type = 'hero' 
AND active = TRUE
AND (start_date IS NULL OR start_date <= CURDATE())
AND (end_date IS NULL OR end_date >= CURDATE())
ORDER BY display_order;

-- Get all active banners by type
SELECT * FROM banners 
WHERE active = TRUE 
AND banner_type = 'sidebar'
ORDER BY display_order;
```

### Search
```sql
-- Track search
INSERT INTO search_history (user_id, search_query, results_count)
VALUES (1, 'rice cooker', 5);

-- Get popular searches
SELECT search_query, COUNT(*) as search_count
FROM search_history
WHERE searched_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
GROUP BY search_query
ORDER BY search_count DESC
LIMIT 10;
```

### Products
```sql
-- Get products with all details
SELECT p.*, c.category_name, b.brand_name,
       COALESCE(d.discount_percent, 0) as discount,
       (p.price - (p.price * COALESCE(d.discount_percent, 0) / 100)) as final_price
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN brands b ON p.brand_id = b.brand_id
LEFT JOIN discounts d ON p.product_id = d.product_id 
  AND d.valid_from <= CURDATE() 
  AND d.valid_to >= CURDATE();

-- Get products with reviews
SELECT p.*, AVG(r.rating) as avg_rating, COUNT(r.review_id) as review_count
FROM products p
LEFT JOIN reviews r ON p.product_id = r.product_id
GROUP BY p.product_id;
```

## 🔗 API Endpoints

### Collections
```
GET  /api/collections                    # All collections
GET  /api/collections/{slug}             # Single collection
GET  /api/collections/{slug}/items       # Collection items
GET  /api/collections/{slug}/products    # Products in collection
POST /api/collections                    # Create (admin)
PUT  /api/collections/{id}               # Update (admin)
DELETE /api/collections/{id}             # Delete (admin)
```

### Banners
```
GET  /api/banners                        # All banners
GET  /api/banners?type=hero              # Hero banners
GET  /api/banners?type=mid               # Mid banners
GET  /api/banners?type=sidebar           # Sidebar banners
POST /api/banners                        # Create (admin)
PUT  /api/banners/{id}                   # Update (admin)
DELETE /api/banners/{id}                 # Delete (admin)
```

### Search
```
GET  /api/search?q={query}               # Search products
GET  /api/search/suggestions             # Popular searches
GET  /api/search/history                 # User search history
```

### Products
```
GET  /api/products                       # All products
GET  /api/products/{id}                  # Single product
GET  /api/products/{id}/specifications   # Product specs
GET  /api/products?category={id}         # By category
GET  /api/products?brand={id}            # By brand
GET  /api/products?search={query}        # Search
POST /api/products                       # Create (admin)
PUT  /api/products/{id}                  # Update (admin)
DELETE /api/products/{id}                # Delete (admin)
```

## 🎨 Collection Icons

| Collection | Icon Name | Material Icon |
|------------|-----------|---------------|
| Fans | air | Icons.air |
| Cookers | soup_kitchen | Icons.soup_kitchen |
| Blenders | blender | Icons.blender |
| Phone Related | phone | Icons.phone |
| Massager Items | spa | Icons.spa |
| Trimmer | content_cut | Icons.content_cut |
| Electric Chula | local_fire_department | Icons.local_fire_department |
| Iron | iron | Icons.iron |
| Chopper | cut | Icons.cut |
| Grinder | settings | Icons.settings |
| Kettle | coffee_maker | Icons.coffee_maker |
| Hair Dryer | air | Icons.air |
| Oven | microwave | Icons.microwave |
| Air Fryer | kitchen | Icons.kitchen |

## 🔐 Default Credentials

```
Admin Account:
Email: admin@electrocitybd.com
Password: admin123

Database:
Host: 127.0.0.1
Port: 3306
Database: electrocity_db
User: root
Password: (your MySQL password)
```

## 🛠️ Common Commands

### Backup
```bash
mysqldump -u root -p electrocity_db > backup_$(date +%Y%m%d).sql
```

### Restore
```bash
mysql -u root -p electrocity_db < backup_20260228.sql
```

### Reset
```bash
mysql -u root -p -e "DROP DATABASE IF EXISTS electrocity_db;"
mysql -u root -p < COMPLETE_DATABASE_SETUP.sql
```

### Check Status
```bash
mysql -u root -p -e "USE electrocity_db; SHOW TABLES; SELECT COUNT(*) FROM products;"
```

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| MySQL not found | Add MySQL to PATH or install |
| Access denied | Check credentials in backend/.env |
| Database exists | Drop and recreate or use different name |
| Tables not created | Check MySQL user privileges |
| Backend can't connect | Verify MySQL is running |
| Products not loading | Check backend server is running on port 8000 |

## 📱 Flutter Integration

### Fetch Collections
```dart
final collections = await ApiService.get('/collections');
```

### Navigate to Collection
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => CollectionDetailPage(
      collectionName: collection['name'],
      collectionSlug: collection['slug'],
      icon: _getIconData(collection['icon']),
    ),
  ),
);
```

### Display Banners
```dart
final banners = await ApiService.get('/banners?type=hero');
```

### Search Products
```dart
final results = await ApiService.get('/search?q=$query');
```

## 📊 Performance Tips

1. **Use Indexes** - Already created on key columns
2. **Limit Results** - Use `LIMIT` in queries
3. **Cache Data** - Cache collections and banners
4. **Optimize Images** - Compress banner images
5. **Use CDN** - Serve static assets from CDN

## 🔄 Update Queries

### Add Product to Collection
```sql
INSERT INTO collection_products (collection_id, product_id)
VALUES (1, 10);
```

### Update Collection Item Count
```sql
UPDATE collections c
SET item_count = (
  SELECT COUNT(*) FROM collection_products cp
  WHERE cp.collection_id = c.collection_id
)
WHERE c.collection_id = 1;
```

### Activate/Deactivate Banner
```sql
UPDATE banners SET active = FALSE WHERE banner_id = 1;
```

### Add Product Specification
```sql
INSERT INTO product_specifications (product_id, spec_key, spec_value, display_order)
VALUES (1, 'Power', '9W', 1);
```

---

**Quick Reference v2.0.0**
**Last Updated:** February 28, 2026
