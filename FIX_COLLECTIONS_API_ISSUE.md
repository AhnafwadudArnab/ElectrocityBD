# Fix Collections Page API Issue

## Problem
The Collections page shows "Failed to load products" with error: "Invalid response format (expected JSON): <!DOCTYPE html>"

This happens because the Flutter web app is trying to call the API but getting HTML instead of JSON.

## Root Cause
When Flutter web runs in debug mode, it runs on its own port (e.g., localhost:53227). When it tries to call `/api/products`, it's calling its own server instead of the PHP backend at `localhost:8000`.

## Solution Applied

### 1. Updated `lib/main.dart`
Added code to force the API URL when running on web:

```dart
void main() async {
  // Force API base URL for web platform
  if (kIsWeb) {
    ApiService.setBaseUrl('http://localhost:8000/api');
    print('🌐 Running on Web - API URL set to: http://localhost:8000/api');
  }
  
  runApp(
    MultiProvider(
      providers: [
        // ... providers
      ],
      child: MyApp(),
    ),
  );
}
```

### 2. Updated `lib/Front-end/utils/api_service.dart`
- Added debug logging to see what's happening
- Made `_reprobeBase()` always return a valid URL (never null)
- Added print statements to track API calls

### 3. Backend is Already Running
The PHP backend is running on `http://localhost:8000` and responding correctly:
```bash
curl http://localhost:8000/api/health
# Returns: {"status":"ok"}
```

## How to Fix (REQUIRED STEPS)

### Step 1: Stop Flutter App
Completely stop the Flutter web app (close browser tab or stop debug session)

### Step 2: Restart Flutter App
Run the app again:
```bash
flutter run -d chrome
```

Or if using VS Code, press F5 to start debugging again.

### Step 3: Check Console Output
You should see in the console:
```
🌐 Running on Web - API URL set to: http://localhost:8000/api
Probing for backend API...
Trying: http://localhost:8000/api/health
✓ Backend found at: http://localhost:8000/api
```

### Step 4: Verify Products Load
- Go to any page with products (Home, Collections, etc.)
- Products should now load from the database
- No more "Failed to load products" error

## Collections Page Upload Card

The Collections page now has a product upload card that appears when you:
1. Click on any collection from the left sidebar (e.g., "Fans", "Cookers")
2. Scroll down on the right side
3. You'll see the upload form with:
   - Product Name field
   - Price field
   - Stock Quantity field
   - Description field
   - Category dropdown (populated with collection items)
   - Brand dropdown
   - Image upload area
   - "Publish to [Collection Name]" button

## Troubleshooting

### If products still don't load:

1. **Check backend is running:**
   ```bash
   curl http://localhost:8000/api/health
   ```
   Should return: `{"status":"ok"}`

2. **Check browser console (F12):**
   Look for the debug messages:
   - "🌐 Running on Web - API URL set to..."
   - "Probing for backend API..."
   - "✓ Backend found at..."

3. **Hard refresh browser:**
   Press Ctrl+Shift+R (Windows) or Cmd+Shift+R (Mac)

4. **Clear browser cache:**
   - Open DevTools (F12)
   - Right-click on refresh button
   - Select "Empty Cache and Hard Reload"

### If backend is not running:

Start it with:
```bash
cd backend
php -S localhost:8000 -t public router.php
```

## Summary

✅ Code is fixed and ready
✅ Backend is running
❌ Flutter app needs to be RESTARTED to pick up the changes

**ACTION REQUIRED: Restart the Flutter app now!**
