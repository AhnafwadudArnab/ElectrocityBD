# Collections Page - App Restart Required

## ✅ Code Update সম্পন্ন হয়েছে

Collections page এ ২০টা collection যোগ করা হয়েছে কিন্তু app restart করতে হবে changes দেখার জন্য।

## 🔄 App Restart করুন

### Option 1: VS Code থেকে
1. VS Code এ `Ctrl + Shift + P` চাপুন
2. "Flutter: Hot Restart" select করুন
3. অথবা Debug toolbar এ restart button (🔄) click করুন

### Option 2: Terminal থেকে
```bash
# App stop করুন (Ctrl + C)
# তারপর আবার run করুন
flutter run
```

### Option 3: Device থেকে
1. App close করুন
2. App আবার open করুন

## 📱 Verify করুন

App restart করার পর:

1. **Home page এ যান**
2. **Collections section scroll করুন**
3. **২০টা collection card দেখা যাবে:**

### Collections List:
1. Charger Fan - 12 items
2. Mini Hand Fan - 8 items
3. Trimmer - 15 items
4. Rice Cooker - 20 items
5. Electric Chula - 10 items
6. Telephone Set - 6 items
7. Sim Telephone - 8 items
8. Iron - 18 items
9. Mini Cooker - 14 items
10. Hand Blender - 16 items
11. Chopper - 12 items
12. Grinder - 10 items
13. Blender - 22 items
14. Kettle - 25 items
15. Hair Dryer - 14 items
16. Oven - 8 items
17. Air Fryer - 18 items
18. Curry Cooker - 12 items
19. Massage Gun - 10 items
20. Head Massage - 8 items

## 🔧 পরবর্তী ধাপ: Database Integration

এখন items count hardcoded আছে। Database থেকে dynamic করতে:

### 1. Backend API তৈরি করুন

`backend/api/collections.php`:
```php
<?php
header('Content-Type: application/json');
require_once __DIR__ . '/bootstrap.php';
require_once __DIR__ . '/../config/cors.php';

$db = db();
$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    // Get all collections with product count
    $query = "SELECT 
                c.collection_id,
                c.collection_name,
                c.collection_slug,
                c.icon,
                COUNT(cp.product_id) as product_count
              FROM collections c
              LEFT JOIN collection_products cp ON c.collection_id = cp.collection_id
              WHERE c.is_active = TRUE
              GROUP BY c.collection_id
              ORDER BY c.display_order";
    
    $stmt = $db->prepare($query);
    $stmt->execute();
    $collections = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode($collections);
    exit;
}

http_response_code(405);
echo json_encode(['message' => 'Method not allowed']);
?>
```

### 2. Frontend API Service Update

`lib/Front-end/utils/api_service.dart` এ যোগ করুন:
```dart
// Get all collections
static Future<List<dynamic>> getCollections() async {
  return await get('/collections') as List<dynamic>;
}
```

### 3. Collections Page Update করুন

```dart
class _CollectionsPageState extends State<CollectionsPage> {
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _gadgetCollections = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCollections();
  }

  Future<void> _loadCollections() async {
    try {
      final data = await ApiService.getCollections();
      setState(() {
        _gadgetCollections = data.map((c) => {
          'title': c['collection_name'],
          'count': c['product_count'],
          'icon': _getIconFromString(c['icon']),
          'page': _getPageFromSlug(c['collection_slug']),
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading collections: $e');
      // Fallback to hardcoded data
      setState(() {
        _gadgetCollections = _getDefaultCollections();
        _isLoading = false;
      });
    }
  }

  IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'air': return Icons.air;
      case 'toys': return Icons.toys;
      case 'content_cut': return Icons.content_cut;
      case 'rice_bowl': return Icons.rice_bowl;
      case 'local_fire_department': return Icons.local_fire_department;
      case 'phone': return Icons.phone;
      case 'phone_android': return Icons.phone_android;
      case 'iron': return Icons.iron;
      case 'soup_kitchen': return Icons.soup_kitchen;
      case 'blender': return Icons.blender;
      case 'cut': return Icons.cut;
      case 'settings': return Icons.settings;
      case 'blender_outlined': return Icons.blender_outlined;
      case 'coffee_maker': return Icons.coffee_maker;
      case 'microwave': return Icons.microwave;
      case 'kitchen': return Icons.kitchen;
      case 'restaurant': return Icons.restaurant;
      case 'spa': return Icons.spa;
      case 'self_improvement': return Icons.self_improvement;
      default: return Icons.category;
    }
  }

  Widget _getPageFromSlug(String slug) {
    // Map slug to appropriate page
    if (slug.contains('kitchen') || slug.contains('cooker') || 
        slug.contains('blender') || slug.contains('kettle')) {
      return KitchenAppliancesPage();
    } else if (slug.contains('personal') || slug.contains('trimmer') || 
               slug.contains('massage')) {
      return PersonalCareLifestylePage();
    } else {
      return HomeComfortUtilityPage();
    }
  }

  List<Map<String, dynamic>> _getDefaultCollections() {
    // Return current hardcoded list as fallback
    return [
      // ... existing hardcoded collections
    ];
  }
}
```

### 4. Database Schema Apply করুন

```bash
mysql -u root -p electrocity_db < COLLECTIONS_SCHEMA.sql
```

## 🎯 Current Status

✅ Collections page code updated (20 collections)
✅ Hardcoded items count working
⏳ App restart required to see changes
⏳ Database integration pending
⏳ Backend API pending

## 📝 Note

এখন items count hardcoded আছে। Database integration করলে:
- Admin panel থেকে collections manage করা যাবে
- Real-time product count দেখাবে
- Dynamic collections add/remove করা যাবে
