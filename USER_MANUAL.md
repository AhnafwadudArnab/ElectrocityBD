# ElectrocityBD - Complete User Manual

## 📋 Table of Contents
1. [System Overview](#system-overview)
2. [Prerequisites](#prerequisites)
3. [Installation & Setup](#installation--setup)
4. [Running the Application](#running-the-application)
5. [Database Management](#database-management)
6. [Admin Panel Guide](#admin-panel-guide)
7. [Product Management](#product-management)
8. [Troubleshooting](#troubleshooting)
9. [API Endpoints](#api-endpoints)

---

## 🎯 System Overview

**ElectrocityBD** is a full-stack e-commerce platform for electronics:
- **Frontend**: Flutter (Web, Android, iOS, Desktop)
- **Backend**: PHP REST API
- **Database**: MySQL
- **Architecture**: Client-Server with JWT authentication

### Key Features
- User authentication (Customer & Admin)
- Product catalog with categories, brands, collections
- Shopping cart & checkout
- Order management
- Admin dashboard with analytics
- Banner & promotion management
- Review & rating system

---

## 📦 Prerequisites

### Required Software
1. **Flutter SDK** (3.9.2 or higher)
   - Download: https://flutter.dev/docs/get-started/install
   - Verify: `flutter --version`

2. **PHP** (7.4 or higher)
   - Download: https://www.php.net/downloads
   - Verify: `php --version`

3. **MySQL** (5.7 or higher)
   - Download: https://dev.mysql.com/downloads/mysql/
   - Verify: `mysql --version`

4. **Composer** (PHP package manager)
   - Download: https://getcomposer.org/download/
   - Verify: `composer --version`

### Optional Tools
- **Git**: For version control
- **Postman**: For API testing
- **VS Code/Android Studio**: For development

---

## 🚀 Installation & Setup

### Step 1: Clone/Download Project
```bash
cd C:\Users\ahana\Music\MAD\ElectrocityBD
```

### Step 2: Database Setup

#### Option A: Automated Setup (Recommended)
**Windows:**
```bash
cd databaseMysql
# Edit setup script with your MySQL password if needed
mysql -u root -p < COMPLETE_DATABASE_SETUP.sql
```

**Mac/Linux:**
```bash
cd databaseMysql
chmod +x setup_database.sh
./setup_database.sh
```

#### Option B: Manual Setup
1. Open MySQL Workbench or command line
2. Run the following:
```sql
CREATE DATABASE IF NOT EXISTS electrobd CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE electrobd;
SOURCE C:/Users/ahana/Music/MAD/ElectrocityBD/databaseMysql/COMPLETE_DATABASE_SETUP.sql;
```

3. Verify database creation:
```sql
SHOW DATABASES;
USE electrobd;
SHOW TABLES;
```

### Step 3: Backend Configuration

1. **Configure Database Connection**
   ```bash
   cd backend
   ```

2. **Edit `.env` file** (already exists):
   ```env
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_NAME=electrobd
   DB_USER=root
   DB_PASSWORD=your_mysql_password_here
   ```

3. **Verify PHP Configuration**
   - Ensure `php.ini` has these extensions enabled:
     ```ini
     extension=pdo_mysql
     extension=mysqli
     extension=mbstring
     extension=fileinfo
     ```

### Step 4: Flutter Setup

1. **Install Dependencies**
   ```bash
   cd C:\Users\ahana\Music\MAD\ElectrocityBD
   flutter pub get
   ```

2. **Configure API URL** (if needed)
   - Edit `lib/Front-end/utils/constants.dart`:
   ```dart
   static String get baseUrl {
     // For local development:
     return 'http://localhost:8000/api';
     
     // For production:
     // return 'https://yourdomain.com/api';
   }
   ```

---

## ▶️ Running the Application

### Start Backend Server

**Method 1: Using Batch File (Windows)**
```bash
cd C:\Users\ahana\Music\MAD\ElectrocityBD
start_server.bat
```

**Method 2: Manual Start**
```bash
cd backend
php -S localhost:8000 -t public router.php
```

**Verify Backend is Running:**
- Open browser: http://localhost:8000/api/health
- Should return: `{"status":"ok"}`

### Start Flutter App

**For Web:**
```bash
flutter run -d chrome
# Or use the batch file:
serve_web.bat
```

**For Android Emulator:**
```bash
flutter run -d emulator-5554
```

**For Windows Desktop:**
```bash
flutter run -d windows
```

### Default Login Credentials

**Admin Account:**
- Username: `admin`
- Password: `admin123`

**Test Customer Account:**
- Email: `customer@test.com`
- Password: `password123`

---

## 🗄️ Database Management

### Database St