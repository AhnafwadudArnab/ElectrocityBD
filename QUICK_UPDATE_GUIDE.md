# Quick Update Guide - Replace Image.network with OptimizedImageWidget

## বাকি যেসব files update করতে হবে

এই files গুলোতে এখনও `Image.network` ব্যবহার হচ্ছে। এগুলো update করলে সব pages এ fast loading হবে।

### 1. Flash Sale All Page
**File**: `lib/Front-end/widgets/Sections/Flash Sale/Flash_sale_all.dart`

```dart
// Line 149 এর কাছে
// পুরাতন:
return Image.network(url, fit: BoxFit.contain, ...);

// নতুন:
import '../../../utils/optimized_image_widget.dart';

return OptimizedImageWidget(
  imageUrl: url,
  fit: BoxFit.contain,
  width: double.infinity,
  height: double.infinity,
);
```

### 2. Trending Items
**File**: `lib/Front-end/widgets/Sections/Trendings/TrendingItems.dart`

```dart
// Line 283 এর কাছে
// পুরাতন:
Image.network(adminProducts[index]['imageUrl'] as String, fit: BoxFit.cover)

// নতুন:
import '../../../utils/optimized_image_widget.dart';

OptimizedImageWidget(
  imageUrl: adminProducts[index]['imageUrl'] as String,
  fit: BoxFit.cover,
  width: double.infinity,
  height: double.infinity,
)
```

### 3. Tech Part
**File**: `lib/Front-end/widgets/Sections/TechPart.dart`

```dart
// Line 312 এর কাছে
// পুরাতন:
return Image.network(imageUrl, fit: BoxFit.cover, ...);

// নতুন:
import '../../utils/optimized_image_widget.dart';

return OptimizedImageWidget(
  imageUrl: imageUrl,
  fit: BoxFit.cover,
  width: double.infinity,
  height: double.infinity,
);
```

### 4. Featured Brands Strip
**File**: `lib/Front-end/widgets/Sections/FeaturedBrandsStrip.dart`

```dart
// Line 222 এর কাছে
// পুরাতন:
Image.network('http://localhost:8000/$logoPath', fit: BoxFit.contain)

// নতুন:
import '../../utils/optimized_image_widget.dart';

OptimizedImageWidget(
  imageUrl: 'http://localhost:8000/$logoPath',
  fit: BoxFit.contain,
  width: 80,
  height: 80,
)
```

### 5. Deals of the Day
**File**: `lib/Front-end/widgets/Sections/Deals_of_the_day.dart`

```dart
// Line 309 এর কাছে
// পুরাতন:
imageWidget = Image.network(p['imageUrl'] as String, fit: BoxFit.cover);

// নতুন:
import '../../utils/optimized_image_widget.dart';

imageWidget = OptimizedImageWidget(
  imageUrl: p['imageUrl'] as String,
  fit: BoxFit.cover,
  width: double.infinity,
  height: double.infinity,
);
```

### 6. Item Details
**File**: `lib/Front-end/widgets/Item details/Item_details.dart`

```dart
// Line 30 এর কাছে
// পুরাতন:
child: Image.network(imageUrl, height: 220, ...)

// নতুন:
import '../../utils/optimized_image_widget.dart';

child: OptimizedImageWidget(
  imageUrl: imageUrl,
  height: 220,
  fit: BoxFit.cover,
  borderRadius: BorderRadius.circular(12),
)
```

### 7. Product Page
**File**: `lib/Front-end/pages/Services/product_page.dart`

```dart
// Line 24 এর কাছে
// পুরাতন:
child: Image.network(imageUrl, height: 220, ...)

// নতুন:
import '../../utils/optimized_image_widget.dart';

child: OptimizedImageWidget(
  imageUrl: imageUrl,
  height: 220,
  fit: BoxFit.cover,
  borderRadius: BorderRadius.circular(8),
)
```

### 8. Promotions Page
**File**: `lib/Front-end/pages/Services/promotions_page.dart`

```dart
// Line 16 এর কাছে
// পুরাতন:
child: Image.network('https://picsum.photos/800/300?random=21', ...)

// নতুন:
import '../../utils/optimized_image_widget.dart';

child: OptimizedImageWidget(
  imageUrl: 'https://picsum.photos/800/300?random=21',
  height: 180,
  fit: BoxFit.cover,
  borderRadius: BorderRadius.circular(8),
)
```

### 9. Cart Pages
**File**: `lib/Front-end/All Pages/CART/Main_carting.dart`

```dart
// Line 198 এর কাছে
// পুরাতন:
return Image.network(path, fit: BoxFit.cover, ...);

// নতুন:
import '../../utils/optimized_image_widget.dart';

return OptimizedImageWidget(
  imageUrl: path,
  fit: BoxFit.cover,
  width: 60,
  height: 60,
);
```

**File**: `lib/Front-end/All Pages/CART/Track_ur_orders.dart`

```dart
// Line 856 এর কাছে
// পুরাতন:
? Image.network(imageUrl, width: ..., ...)

// নতুন:
import '../../utils/optimized_image_widget.dart';

? OptimizedImageWidget(
    imageUrl: imageUrl,
    width: AppDimensions.imageSize(context) * 0.4,
    height: AppDimensions.imageSize(context) * 0.4,
    fit: BoxFit.cover,
  )
```

### 10. Admin Panel Files

**File**: `lib/Front-end/Admin Panel/A_brands.dart`
**File**: `lib/Front-end/Admin Panel/A_carts.dart`
**File**: `lib/Front-end/Admin Panel/A_banners.dart`

```dart
// সব জায়গায় একই pattern:
// পুরাতন:
Image.network(url, ...)

// নতুন:
import '../utils/optimized_image_widget.dart';

OptimizedImageWidget(
  imageUrl: url,
  fit: BoxFit.cover,
  width: width,
  height: height,
)
```

## একসাথে সব update করার জন্য

### Step 1: Import Statement Add করুন
প্রতিটি file এর উপরে:
```dart
import 'package:electrocitybd1/Front-end/utils/optimized_image_widget.dart';
// অথবা relative path অনুযায়ী
import '../../utils/optimized_image_widget.dart';
```

### Step 2: Replace Pattern
```dart
// Find:
Image.network(
  imageUrl,
  fit: BoxFit.cover,
)

// Replace with:
OptimizedImageWidget(
  imageUrl: imageUrl,
  fit: BoxFit.cover,
  width: double.infinity,
  height: double.infinity,
)
```

### Step 3: Test করুন
```bash
# Flutter app restart করুন
flutter clean
flutter pub get
flutter run
```

## Benefits After Update

✅ All pages এ fast image loading
✅ Automatic caching
✅ Shimmer loading animation
✅ Better error handling
✅ Offline support
✅ Memory optimization

## Priority Order (কোনটা আগে update করবেন)

1. **High Priority** (Most visible):
   - ✅ product_card.dart (Done)
   - ✅ common_product_card.dart (Done)
   - ✅ flash_sale.dart (Done)
   - Flash_sale_all.dart
   - TrendingItems.dart
   - Deals_of_the_day.dart

2. **Medium Priority**:
   - Item_details.dart
   - product_page.dart
   - Main_carting.dart
   - Track_ur_orders.dart

3. **Low Priority** (Admin/Less visible):
   - A_brands.dart
   - A_carts.dart
   - A_banners.dart
   - promotions_page.dart

## Testing Checklist

After updating each file:
- [ ] App compiles without errors
- [ ] Images load properly
- [ ] Shimmer animation shows during loading
- [ ] Error placeholder shows for broken images
- [ ] Images cache properly (second load is instant)
- [ ] No memory leaks

## Common Issues & Solutions

### Issue 1: Import Error
```
Error: Can't find optimized_image_widget.dart
```
**Solution**: Check relative path
```dart
// From widgets folder
import '../../utils/optimized_image_widget.dart';

// From pages folder
import '../utils/optimized_image_widget.dart';
```

### Issue 2: Width/Height Required
```
Error: The argument type 'double?' can't be assigned to 'double'
```
**Solution**: Make width/height optional or provide default
```dart
OptimizedImageWidget(
  imageUrl: imageUrl,
  fit: BoxFit.cover,
  width: width ?? double.infinity,
  height: height ?? 200,
)
```

### Issue 3: BorderRadius Not Working
```dart
// Wrong:
ClipRRect(
  borderRadius: BorderRadius.circular(8),
  child: OptimizedImageWidget(...),
)

// Right:
OptimizedImageWidget(
  imageUrl: imageUrl,
  borderRadius: BorderRadius.circular(8),
  ...
)
```

## Final Notes

- Update করার সময় একটা একটা file করুন
- প্রতিটি update এর পর test করুন
- Git commit করে রাখুন যাতে rollback করা যায়
- Performance improvement measure করুন

Happy Optimizing! 🚀
