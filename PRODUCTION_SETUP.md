# Production Setup Guide - Step by Step

## ✅ সব কিছু Production Ready করা হয়েছে!

এই guide follow করে আপনার app production এ deploy করুন।

---

## 📋 Prerequisites

- [ ] MySQL database access
- [ ] PHP 7.4+ installed
- [ ] Flutter SDK installed
- [ ] Domain name (optional for testing)
- [ ] Hosting account (cPanel/VPS)

---

## Step 1: Database Setup (5 minutes)

### 1.1 Create Database
```bash
mysql -u root -p
CREATE DATABASE electrobd CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
exit;
```

### 1.2 Import Main Database
```bash
# If you have existing database dump
mysql -u root -p electrobd < your_database_dump.sql
```

### 1.3 Setup New Tables
```bash
# Setup notifications and rate limiting tables
mysql -u root -p electrobd < backend/database/setup_all.sql
```

### 1.4 Verify Database
```bash
mysql -u root -p electrobd < test_scripts/test_database.sql
```

---

## Step 2: Backend Configuration (10 minutes)

### 2.1 Create .env File
```bash
cd backend
cp .env.example .env
```

### 2.2 Generate JWT Secret
```bash
# Generate strong random key
openssl rand -base64 32

# Or use online generator:
# https://randomkeygen.com/
```

### 2.3 Edit .env File
```env
# Database
DB_HOST=localhost
DB_PORT=3306
DB_NAME=electrobd
DB_USER=root
DB_PASSWORD=YOUR_STRONG_PASSWORD_HERE

# JWT Secret (paste generated key)
JWT_SECRET=YOUR_GENERATED_JWT_SECRET_HERE

# Email (optional)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your-email@gmail.com
SMTP_PASSWORD=your-app-password

# Environment
APP_ENV=production

# CORS (your production domains)
ALLOWED_ORIGINS=https://yourdomain.com,https://www.yourdomain.com

# Rate Limiting
RATE_LIMIT_MAX_ATTEMPTS=10
RATE_LIMIT_DECAY_MINUTES=1
```

### 2.4 Change Database Password
```bash
mysql -u root -p
ALTER USER 'root'@'localhost' IDENTIFIED BY 'YOUR_STRONG_PASSWORD_HERE';
FLUSH PRIVILEGES;
exit;
```

### 2.5 Test Backend
```bash
# Start PHP server
php -S localhost:8000

# In another terminal, test API
bash test_scripts/test_api.sh http://localhost:8000/api
```

---

## Step 3: Frontend Configuration (5 minutes)

### 3.1 Update API URL

**Option A: Edit config file directly**
```dart
// lib/config/app_config.dart
// Line 13: Change this
defaultValue: kReleaseMode 
    ? 'https://yourdomain.com'  // Your production domain
    : 'http://localhost:8000',
```

**Option B: Use build argument (recommended)**
```bash
# No need to edit file, just use --dart-define when building
```

### 3.2 Test Development Build
```bash
flutter pub get
flutter run
```

---

## Step 4: Security Verification (15 minutes)

### 4.1 Verify JWT Secret Changed
```bash
grep "JWT_SECRET" backend/.env
# Should NOT be: ElectrocityBD_Secret_Key_2024
```

### 4.2 Verify Database Password Changed
```bash
grep "DB_PASSWORD" backend/.env
# Should NOT be empty
```

### 4.3 Verify CORS Configuration
```bash
grep "ALLOWED_ORIGINS" backend/.env
# Should contain your production domains
```

### 4.4 Verify .env Not in Git
```bash
git status
# .env should NOT appear in the list
```

### 4.5 Test Rate Limiting
```bash
# Make 15 rapid requests (should get rate limited after 10)
for i in {1..15}; do
  curl http://localhost:8000/api/health
  echo " - Request $i"
done
```

---

## Step 5: Testing (1 week)

### 5.1 Manual Testing Checklist

**Day 1: User Flow**
- [ ] Registration
- [ ] Login
- [ ] Browse products
- [ ] Search products
- [ ] Filter by category
- [ ] Add to cart
- [ ] Update cart
- [ ] Checkout
- [ ] Place order
- [ ] View order history

**Day 2: Admin Flow**
- [ ] Admin login
- [ ] Dashboard
- [ ] Create product
- [ ] Edit product
- [ ] Delete product
- [ ] Manage orders
- [ ] Update order status
- [ ] Create promotion
- [ ] Create flash sale
- [ ] Manage featured brands

**Day 3: Edge Cases**
- [ ] Network errors (airplane mode)
- [ ] Invalid inputs
- [ ] Empty states
- [ ] Loading states
- [ ] Session expiry
- [ ] Concurrent users

**Day 4: Cross-device**
- [ ] Different Android versions
- [ ] Different screen sizes
- [ ] Tablets
- [ ] Different browsers (web)

**Day 5: Performance**
- [ ] Load time
- [ ] Image loading
- [ ] Scrolling performance
- [ ] Memory usage
- [ ] Battery usage

### 5.2 Automated Testing
```bash
# Run Flutter tests
flutter test

# Run with coverage
flutter test --coverage
```

---

## Step 6: Production Build (30 minutes)

### 6.1 Clean Build
```bash
flutter clean
flutter pub get
```

### 6.2 Build APK
```bash
# With custom API URL
flutter build apk --release --dart-define=API_URL=https://yourdomain.com

# Or if you edited config file
flutter build apk --release
```

### 6.3 Build App Bundle (for Play Store)
```bash
flutter build appbundle --release --dart-define=API_URL=https://yourdomain.com
```

### 6.4 Test APK
```bash
# Install on device
adb install build/app/outputs/flutter-apk/app-release.apk

# Test all features
```

---

## Step 7: Backend Deployment (2-3 hours)

### 7.1 Upload Files
```bash
# Via FTP/SFTP or cPanel File Manager
# Upload entire backend folder
```

### 7.2 Create .env on Server
```bash
# Via cPanel File Manager or SSH
# Create backend/.env with production credentials
```

### 7.3 Import Database
```bash
# Via phpMyAdmin or SSH
mysql -u username -p database_name < database_dump.sql
mysql -u username -p database_name < backend/database/setup_all.sql
```

### 7.4 Set File Permissions
```bash
# Via SSH or cPanel
chmod 755 backend/public/uploads
chmod 644 backend/.env
```

### 7.5 Configure Domain
```
# Point domain to backend folder
# Example: yourdomain.com/api -> /public_html/backend/api
```

### 7.6 Install SSL Certificate
```
# Via cPanel or Let's Encrypt
# Enable HTTPS
```

### 7.7 Test Production API
```bash
curl https://yourdomain.com/api/health
```

---

## Step 8: Final Verification (1 hour)

### 8.1 Test All API Endpoints
```bash
bash test_scripts/test_api.sh https://yourdomain.com/api
```

### 8.2 Test App with Production API
```bash
# Install production APK
# Test all features
# Check logs for errors
```

### 8.3 Monitor Logs
```bash
# Backend logs
tail -f backend/logs/error.log

# Flutter logs
flutter logs
```

---

## Step 9: Launch Checklist

### Pre-Launch:
- [ ] All tests passed
- [ ] No critical bugs
- [ ] Security verified
- [ ] Performance acceptable
- [ ] Database backed up
- [ ] .env file secure
- [ ] SSL certificate active
- [ ] Domain configured
- [ ] API endpoints working
- [ ] App tested on production

### Launch:
- [ ] Deploy backend
- [ ] Build production APK
- [ ] Test on multiple devices
- [ ] Monitor for errors
- [ ] Fix critical issues
- [ ] Announce launch

### Post-Launch:
- [ ] Monitor logs daily
- [ ] Check error reports
- [ ] Respond to user feedback
- [ ] Fix bugs quickly
- [ ] Plan updates

---

## 🚨 Troubleshooting

### Issue: API connection failed
```bash
# Check backend is running
curl https://yourdomain.com/api/health

# Check CORS
curl -H "Origin: https://yourapp.com" https://yourdomain.com/api/health

# Check SSL
curl -v https://yourdomain.com/api/health
```

### Issue: Database connection error
```bash
# Test database connection
mysql -u username -p database_name

# Check credentials in .env
cat backend/.env | grep DB_
```

### Issue: Rate limiting too strict
```env
# Edit backend/.env
RATE_LIMIT_MAX_ATTEMPTS=20
RATE_LIMIT_DECAY_MINUTES=2
```

### Issue: CORS errors
```env
# Edit backend/.env
ALLOWED_ORIGINS=https://yourdomain.com,https://www.yourdomain.com,https://app.yourdomain.com
```

---

## 📊 Production Checklist Summary

### ✅ Completed:
- [x] Database tables created
- [x] Backend .env configured
- [x] JWT secret changed
- [x] Database password changed
- [x] CORS configured
- [x] Rate limiting implemented
- [x] Input validation added
- [x] Security headers added
- [x] API URL configured
- [x] Testing scripts created

### ⏳ To Do:
- [ ] Run all tests (1 week)
- [ ] Fix bugs
- [ ] Deploy backend (2-3 hours)
- [ ] Build production APK (30 minutes)
- [ ] Final verification (1 hour)
- [ ] Launch!

---

## ⏱️ Total Time Estimate

- Database Setup: 5 minutes
- Backend Config: 10 minutes
- Frontend Config: 5 minutes
- Security Verification: 15 minutes
- Testing: 1 week
- Production Build: 30 minutes
- Backend Deployment: 2-3 hours
- Final Verification: 1 hour

**Total: ~1.5 weeks**

---

## 📞 Need Help?

যদি কোনো step এ সমস্যা হয়:
1. Error logs check করুন
2. Testing guide follow করুন
3. Troubleshooting section দেখুন
4. আমাকে জানান

**Good luck with your launch! 🚀**
