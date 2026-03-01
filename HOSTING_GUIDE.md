# Hosting Guide - InfinityFree/cPanel

## 📋 Pre-deployment Checklist

### 1. Backend Configuration (PHP)

**File: `backend/.env`**
```env
DB_HOST=sqlXXX.epizy.com
DB_PORT=3306
DB_NAME=your_database_name
DB_USER=your_database_user
DB_PASSWORD=your_database_password
JWT_SECRET=your_secure_random_key_here
```

### 2. Frontend Configuration (Flutter Web)

**Create: `web/.env`**
```env
API_BASE_URL=https://yourdomain.com/api
```

**Or update: `lib/Front-end/utils/constants.dart`**
```dart
static String get baseUrl {
  // For production
  return 'https://yourdomain.com/api';
  
  // For development
  // return 'http://localhost:8000/api';
}
```

## 🚀 Deployment Steps

### Step 1: Upload Backend Files

1. Upload `backend/` folder contents to your hosting root (usually `public_html/` or `htdocs/`)
2. Make sure `.htaccess` file is uploaded
3. Create `.env` file with your database credentials
4. Set folder permissions:
   - `public/uploads/` → 755 or 777 (writable)

### Step 2: Setup Database

1. Go to cPanel → phpMyAdmin
2. Create new database (e.g., `electrobd`)
3. Import `databaseMysql/COMPLETE_DATABASE_SETUP.sql`
4. Update `.env` with database credentials

### Step 3: Build & Upload Flutter Web

```bash
# Build Flutter web app
flutter build web --release

# Upload contents of build/web/ to hosting
# You can upload to a subdomain or main domain
```

### Step 4: Configure .htaccess (if needed)

**For root domain hosting:**
```apache
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^api/(.*)$ backend/public/index.php [L]
RewriteRule ^(.*)$ index.html [L]
```

## 🔧 Common Issues & Solutions

### Issue 1: API not found (404)
**Solution:** Check if `backend/public/.htaccess` exists and mod_rewrite is enabled

### Issue 2: Database connection failed
**Solution:** Verify database credentials in `backend/.env`

### Issue 3: Images not loading
**Solution:** 
- Check `backend/public/uploads/` folder permissions (755 or 777)
- Verify image paths in database start with `/uploads/`

### Issue 4: CORS errors
**Solution:** Update `backend/config/cors.php` with your domain:
```php
header('Access-Control-Allow-Origin: https://yourdomain.com');
```

## 📱 Testing After Deployment

1. Test API: `https://yourdomain.com/api/health`
2. Test Admin Login: `https://yourdomain.com/admin`
3. Test Image Upload: Upload a product image from admin panel
4. Test Frontend: Browse products, add to cart, etc.

## 🔐 Security Recommendations

1. Change JWT_SECRET to a strong random string
2. Use HTTPS (SSL certificate - free with InfinityFree)
3. Don't commit `.env` file to git
4. Set proper file permissions (644 for files, 755 for folders)
5. Disable directory listing in .htaccess

## 📞 Support

For hosting-specific issues:
- InfinityFree Forum: https://forum.infinityfree.net/
- cPanel Documentation: Check your hosting provider's docs
