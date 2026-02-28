# Database Changelog

## Version 2.0.0 - February 28, 2026

### ✅ Added Features

#### New Tables
1. **collection_items** - Store collection categories (e.g., Charger Fan, Mini Hand Fan under Fans)
2. **search_history** - Track user searches for analytics and suggestions
3. **product_specifications** - Detailed product specifications

#### Enhanced Tables

**collections**
- Added `slug` field for URL-friendly names
- Added `icon` field for Material Icons
- Added `item_count` field to track number of items
- Added `is_active` field for enable/disable
- Added `display_order` field for sorting

**banners**
- Added `button_text` field for CTA buttons
- Added `start_date` and `end_date` for scheduling
- Added `updated_at` timestamp

### 📊 Updated Sample Data

#### Collections (14 total)
- Fans (20 items)
- Cookers (46 items)
- Blenders (38 items)
- Phone Related (14 items)
- Massager Items (18 items)
- Trimmer (15 items)
- Electric Chula (10 items)
- Iron (18 items)
- Chopper (12 items)
- Grinder (10 items)
- Kettle (25 items)
- Hair Dryer (14 items)
- Oven (8 items)
- Air Fryer (18 items)

#### Collection Items
- Charger Fan, Mini Hand Fan (under Fans)
- Rice Cooker, Mini Cooker, Curry Cooker (under Cookers)
- Hand Blender, Blender (under Blenders)
- Telephone Set, Sim Telephone (under Phone Related)
- Massage Gun, Head Massage (under Massager Items)

#### Banners (7 total)
- 3 Hero banners (Kitchen Sale, Smart Home, Personal Care)
- 2 Mid banners (Daily Deals, New Arrivals)
- 2 Sidebar banners (Flash Sale, Free Shipping)
- All with proper dates and CTA buttons

### 🗑️ Removed Files
- `All_db.sql` (legacy file)
- `electrocity_db (1).sql` (duplicate backup)
- `electrocity_assets_products.sql` (old assets data)

### 🔧 Database Structure

**Total Tables:** 24 (was 22)
- Core: 6 tables
- E-commerce: 6 tables
- Marketing: 6 tables
- Homepage Sections: 9 tables
- Admin & Settings: 7 tables

### 📈 Improvements

1. **Better Collections Management**
   - Collections now have slugs for URLs
   - Icons for UI display
   - Active/inactive status
   - Display ordering
   - Item count tracking

2. **Enhanced Banners**
   - Scheduled banners with start/end dates
   - CTA button text customization
   - Better tracking with updated_at

3. **Search Functionality**
   - Search history tracking
   - Results count for analytics
   - User-specific search tracking

4. **Product Specifications**
   - Detailed specs storage
   - Flexible key-value pairs
   - Display ordering

### 🔄 Migration Notes

If upgrading from v1.0.0:
```sql
-- Add new columns to collections
ALTER TABLE collections 
  ADD COLUMN slug VARCHAR(100) UNIQUE AFTER name,
  ADD COLUMN icon VARCHAR(50) AFTER description,
  ADD COLUMN item_count INT DEFAULT 0 AFTER icon,
  ADD COLUMN is_active BOOLEAN DEFAULT TRUE AFTER item_count,
  ADD COLUMN display_order INT DEFAULT 0 AFTER is_active;

-- Add new columns to banners
ALTER TABLE banners
  ADD COLUMN button_text VARCHAR(50) AFTER description,
  ADD COLUMN start_date DATE AFTER active,
  ADD COLUMN end_date DATE AFTER start_date,
  ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER created_at;

-- Create new tables
CREATE TABLE collection_items (...);
CREATE TABLE search_history (...);
CREATE TABLE product_specifications (...);
```

### 🎯 API Endpoints Updated

#### New Endpoints
- `GET /api/collections` - Get all collections with items
- `GET /api/collections/{slug}` - Get collection by slug
- `GET /api/collections/{slug}/items` - Get collection items
- `GET /api/collections/{slug}/products` - Get products in collection
- `GET /api/search?q={query}` - Search products (tracks history)
- `GET /api/search/suggestions` - Get search suggestions
- `GET /api/banners?type={hero|mid|sidebar}` - Get banners by type
- `GET /api/products/{id}/specifications` - Get product specs

#### Updated Endpoints
- `GET /api/collections` - Now includes slug, icon, item_count
- `GET /api/banners` - Now includes button_text, dates

### 📱 Frontend Integration

#### Collections Page
```dart
// Fetch collections
final collections = await ApiService.get('/collections');

// Navigate to collection
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

#### Search Functionality
```dart
// Search products (auto-tracked)
final results = await ApiService.get('/search?q=$query');

// Get suggestions
final suggestions = await ApiService.get('/search/suggestions');
```

#### Banners
```dart
// Fetch hero banners
final heroBanners = await ApiService.get('/banners?type=hero');

// Display with CTA
ElevatedButton(
  onPressed: () => _navigateTo(banner['link_url']),
  child: Text(banner['button_text'] ?? 'Learn More'),
);
```

### 🔐 Security Updates

- All tables use `utf8mb4_unicode_ci` collation
- Foreign keys with proper CASCADE/SET NULL
- Indexes on frequently queried columns
- Prepared statements in PHP backend

### 📊 Performance Optimizations

- Added indexes on:
  - `collections.slug`
  - `search_history.search_query`
  - `search_history.searched_at`
  - `product_specifications.product_id`
  - `collection_items.collection_id`

### 🧪 Testing

Run these queries to verify setup:
```sql
-- Check collections
SELECT COUNT(*) FROM collections; -- Should be 14

-- Check collection items
SELECT COUNT(*) FROM collection_items; -- Should be 10+

-- Check banners
SELECT COUNT(*) FROM banners; -- Should be 7

-- Verify collection structure
SELECT c.name, c.slug, c.icon, c.item_count, COUNT(ci.item_id) as actual_items
FROM collections c
LEFT JOIN collection_items ci ON c.collection_id = ci.collection_id
GROUP BY c.collection_id;
```

### 📝 Notes

- All sample data uses realistic values
- Collections match the Flutter app UI
- Banners include proper scheduling
- Search history ready for analytics
- Product specs support flexible attributes

### 🚀 Next Steps

1. Import the updated database
2. Update backend API to support new endpoints
3. Test collections page in Flutter app
4. Verify banner scheduling works
5. Test search functionality

---

**Database Version:** 2.0.0
**Release Date:** February 28, 2026
**Compatibility:** Flutter App v1.0.0+, PHP Backend v1.0.0+
