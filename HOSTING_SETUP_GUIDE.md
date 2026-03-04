# 🚀 Hosting Setup Guide - ElectroCityBD

## ✅ সম্পূর্ণ Configuration System তৈরি হয়ে গেছে!

এখন আপনার প্রজেক্টে **শুধু একটি ফাইল** পরিবর্তন করলেই সব জায়গায় domain এবং database configuration পরিবর্তন হয়ে যাবে।

---

## 📁 Configuration File Location

```
lib/config/app_config.dart
```

এই ফাইলটি খুলুন এবং শুধু প্রয়োজনীয় লাইন পরিবর্তন করুন।

---

## 🔧 Local Development এর জন্য

```dart
static const String _baseUrl = 'http://localhost:8000';
```

---

## 🌐 cPanel/Production Hosting এর জন্য

### Step 1: Domain Configuration

`lib/config/app_config.dart` ফাইলে যান এবং **line 13** পরিবর্তন করুন:

```dart
// আগে (Development):
static const String _baseUrl = 'http://localhost:8000';

// পরে (Production):
static const String _baseUrl = 'https://yourdomain.com';
```

**উদাহরণ:**
```dart
static const String _baseUrl = 'https://electrocitybd.com';
```

### Step 2: Database Configuration

একই ফাইলে **lines 42-58** পরিবর্তন করুন:

```dart
// Development
static const String dbHost = 'localhost';
static const String dbPort = '3306';
static const String dbName = 'electrobd';
static const String dbUser = 'root';
static const String dbPassword = '';

// Production (cPanel থেকে পাবেন)
static const String dbHost = 'localhost';
static const String dbPort = '3306';
static const String dbName = 'your_cpanel_db_name';
static const String dbUser = 'your_cpanel_db_user';
static const String dbPassword = 'your_cpanel_db_password';
```

### Step 3: Security Configuration

Production এ deploy করার আগে JWT Secret পরিবর্তন করুন:

```dart
// আগে:
static const String jwtSecret = 'ElectrocityBD_Secret_Key_2024';

// পরে (নিজের একটা strong key দিন):
static const String jwtSecret = 'Your_Very_Strong_Secret_Key_2024_XYZ';
```

---

## 🗄️ cPanel Database Setup

### 1. Database তৈরি করুন:
- cPanel → MySQL Databases
- Create New Database: `electrobd` (বা যেকোনো নাম)
- Create New User: username এবং strong password দিন
- User কে Database এ Add করুন (All Privileges দিন)

### 2. Database Import করুন:
- cPanel → phpMyAdmin
- আপনার database select করুন
- Import tab → Choose File
- `databaseMysql/COMPLETE_DATABASE_SETUP.sql` ফাইল upload করুন
- Go button click করুন

### 3. Configuration Update করুন:
```dart
static const String dbName = 'your_cpanel_db_name';
static const String dbUser = 'your_cpanel_db_user';
static const String dbPassword = 'your_cpanel_db_password';
```

---

## 📤 Backend Upload (cPanel)

### 1. Backend Files Upload:
- cPanel → File Manager
- `public_html` folder এ যান
- `backend` folder upload করুন
- অথবা `public_html` এর ভিতরে সব backend files রাখুন

### 2. .htaccess Configuration:

`public_html/.htaccess` ফাইল তৈরি করুন:

```apache
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteBase /
    
    # Redirect all requests to backend/public/index.php
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule ^api/(.*)$ backend/public/index.php [L]
</IfModule>
```

### 3. PHP Version:
- cPanel → Select PHP Version
- PHP 7.4 বা তার উপরে select করুন

---

## 🔄 Flutter App Build & Deploy

### 1. Configuration Update:
```dart
// lib/config/app_config.dart
static const String _baseUrl = 'https://yourdomain.com';
```

### 2. Build for Web:
```bash
flutter clean
flutter pub get
flutter build web --release
```

### 3. Upload to cPanel:
- `build/web` folder এর সব files
- cPanel → File Manager → `public_html` এ upload করুন

---

## ✅ Verification Checklist

### Backend Check:
- [ ] Database imported successfully
- [ ] Database credentials updated in `app_config.dart`
- [ ] Backend files uploaded to cPanel
- [ ] `.htaccess` configured
- [ ] Test API: `https://yourdomain.com/api/health`

### Frontend Check:
- [ ] Domain updated in `app_config.dart`
- [ ] JWT Secret changed
- [ ] Flutter web build completed
- [ ] Files uploaded to cPanel
- [ ] Website accessible: `https://yourdomain.com`

---

## 🐛 Common Issues & Solutions

### Issue 1: API না পাওয়া (404 Error)
**Solution:** `.htaccess` file check করুন এবং mod_rewrite enabled আছে কিনা দেখুন

### Issue 2: Database Connection Failed
**Solution:** 
- Database credentials double-check করুন
- cPanel এ database user properly added আছে কিনা দেখুন

### Issue 3: CORS Error
**Solution:** Backend এর CORS configuration check করুন:
```php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
```

### Issue 4: Images না দেখা
**Solution:** 
- `uploads` folder এর permission 755 করুন
- Image paths check করুন

---

## 📞 Support

যদি কোনো সমস্যা হয়, তাহলে:
1. Browser console check করুন (F12)
2. cPanel error logs দেখুন
3. Backend API response check করুন

---

## 🎉 সম্পন্ন!

এখন আপনার ElectroCityBD app production এ ready! 

**মনে রাখবেন:** শুধু `lib/config/app_config.dart` ফাইল পরিবর্তন করলেই সব জায়গায় configuration update হয়ে যাবে। আর কোথাও কিছু পরিবর্তন করার দরকার নেই! 🚀
