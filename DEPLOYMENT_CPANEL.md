# ElectrocityBD - cPanel Hosting Deployment Guide

## Prerequisites
- cPanel hosting account with PHP 7.4+ and MySQL
- Domain name configured
- FTP/File Manager access
- Database creation access

## Step 1: Prepare Backend Files

### 1.1 Create ZIP of Backend
```bash
cd backend
zip -r backend.zip . -x "*.git*" -x "node_modules/*"
```

### 1.2 Files to Upload
- All files from `backend/` folder
- Make sure `.htaccess` is included

## Step 2: Database Setup

### 2.1 Create MySQL Database
1. Login to cPanel
2. Go to **MySQL Databases**
3. Create new database: `your_username_electrocity`
4. Create database user with strong password
5. Add user to database with ALL PRIVILEGES
6. Note down:
   - Database name: `your_username_electrocity`
   - Database user: `your_username_dbuser`
   - Database password: `your_password`
   - Database host: `localhost`

### 2.2 Import Database Schema
1. Go to **phpMyAdmin** in cPanel
2. Select your database
3. Click **Import** tab
4. Upload your SQL file (if you have one) or create tables manually
5. Run this SQL to create essential tables:

```sql
-- Users table
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    address TEXT,
    gender VARCHAR(10),
    role VARCHAR(20) DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Products table
CREATE TABLE IF NOT EXISTS products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT,
    brand_id INT,
    product_name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    stock_quantity INT DEFAULT 0,
    image_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders table
CREATE TABLE IF NOT EXISTS orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    total_amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50),
    delivery_address TEXT,
    transaction_id VARCHAR(100),
    order_status VARCHAR(50) DEFAULT 'pending',
    estimated_delivery VARCHAR(100),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Order items table
CREATE TABLE IF NOT EXISTS order_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    product_name VARCHAR(255),
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    image_url VARCHAR(500),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Categories table
CREATE TABLE IF NOT EXISTS categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Brands table
CREATE TABLE IF NOT EXISTS brands (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL,
    brand_logo VARCHAR(500)
);

-- Payment methods table
CREATE TABLE IF NOT EXISTS payment_methods (
    id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(50) NOT NULL,
    is_enabled TINYINT(1) DEFAULT 1,
    account_number VARCHAR(100),
    instructions TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert default payment methods
INSERT INTO payment_methods (method_name, is_enabled, account_number) VALUES
('bKash', 1, '01977566065'),
('Nagad', 1, '01977566065')
ON DUPLICATE KEY UPDATE method_name=method_name;
```

## Step 3: Upload Backend Files

### 3.1 Using File Manager
1. Login to cPanel
2. Go to **File Manager**
3. Navigate to `public_html` (or your domain folder)
4. Create folder: `api` (if not exists)
5. Upload all backend files to `public_html/api/`
6. Extract if uploaded as ZIP

### 3.2 Using FTP
```bash
# Using FileZilla or any FTP client
Host: ftp.yourdomain.com
Username: your_cpanel_username
Password: your_cpanel_password
Port: 21

# Upload to: /public_html/api/
```

## Step 4: Configure Backend

### 4.1 Update Database Configuration
Edit `api/config/database.php`:

```php
<?php
class Database {
    private $host = "localhost";
    private $db_name = "your_username_electrocity";
    private $username = "your_username_dbuser";
    private $password = "your_password";
    public $conn;

    public function getConnection() {
        $this->conn = null;
        try {
            $this->conn = new PDO(
                "mysql:host=" . $this->host . ";dbname=" . $this->db_name,
                $this->username,
                $this->password
            );
            $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        } catch(PDOException $exception) {
            echo "Connection error: " . $exception->getMessage();
        }
        return $this->conn;
    }
}
```

### 4.2 Create/Update .htaccess
Create `api/.htaccess`:

```apache
# Enable CORS
Header set Access-Control-Allow-Origin "*"
Header set Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS"
Header set Access-Control-Allow-Headers "Content-Type, Authorization"

# Handle OPTIONS requests
RewriteEngine On
RewriteCond %{REQUEST_METHOD} OPTIONS
RewriteRule ^(.*)$ $1 [R=200,L]

# API Routing
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^api/(.*)$ public/index.php [QSA,L]

# PHP Settings
php_value upload_max_filesize 10M
php_value post_max_size 10M
php_value max_execution_time 300
```

### 4.3 Set File Permissions
Using File Manager or FTP:
- Folders: 755
- PHP files: 644
- Upload folder (if exists): 777

## Step 5: Deploy Flutter Web App

### 5.1 Build Flutter Web
On your local machine:

```bash
# Update API URL in your Flutter app
# Edit: lib/Front-end/utils/api_service.dart
# Change: static const String baseUrl = 'https://yourdomain.com/api';

# Build for web
flutter build web --release
```

### 5.2 Upload Web Files
1. Go to cPanel File Manager
2. Navigate to `public_html`
3. Upload all files from `build/web/` folder
4. Files should be in root: `public_html/index.html`, `public_html/main.dart.js`, etc.

### 5.3 Create .htaccess for Flutter
Create `public_html/.htaccess`:

```apache
<IfModule mod_rewrite.c>
  RewriteEngine On
  RewriteBase /
  
  # Don't rewrite files or directories
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteCond %{REQUEST_FILENAME} !-d
  
  # Don't rewrite API calls
  RewriteCond %{REQUEST_URI} !^/api/
  
  # Rewrite everything else to index.html
  RewriteRule ^(.*)$ index.html [L]
</IfModule>

# Enable GZIP compression
<IfModule mod_deflate.c>
  AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css text/javascript application/javascript application/json
</IfModule>

# Cache static assets
<IfModule mod_expires.c>
  ExpiresActive On
  ExpiresByType image/jpg "access plus 1 year"
  ExpiresByType image/jpeg "access plus 1 year"
  ExpiresByType image/gif "access plus 1 year"
  ExpiresByType image/png "access plus 1 year"
  ExpiresByType text/css "access plus 1 month"
  ExpiresByType application/javascript "access plus 1 month"
</IfModule>
```

## Step 6: Test Deployment

### 6.1 Test API Endpoints
```bash
# Health check
curl https://yourdomain.com/api/health

# Get products
curl https://yourdomain.com/api/products

# Test authentication
curl -X POST https://yourdomain.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password"}'
```

### 6.2 Test Web App
1. Visit: `https://yourdomain.com`
2. Check if homepage loads
3. Test user registration
4. Test product browsing
5. Test cart functionality
6. Test checkout process

## Step 7: SSL Certificate (HTTPS)

### 7.1 Install SSL via cPanel
1. Go to **SSL/TLS Status** in cPanel
2. Click **Run AutoSSL**
3. Wait for certificate installation
4. Or use **Let's Encrypt** if available

### 7.2 Force HTTPS
Add to top of `public_html/.htaccess`:

```apache
# Force HTTPS
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
```

## Step 8: Configure Email (Optional)

### 8.1 Create Email Account
1. Go to **Email Accounts** in cPanel
2. Create: `noreply@yourdomain.com`
3. Note SMTP settings

### 8.2 Update Email Config
Edit email configuration in your backend if needed.

## Troubleshooting

### Issue: 500 Internal Server Error
- Check `.htaccess` syntax
- Check file permissions
- Check PHP error logs in cPanel

### Issue: Database Connection Failed
- Verify database credentials
- Check if database user has privileges
- Ensure database host is `localhost`

### Issue: CORS Errors
- Check `.htaccess` CORS headers
- Verify API URL in Flutter app
- Check browser console for details

### Issue: API Routes Not Working
- Ensure `.htaccess` is in correct location
- Check if mod_rewrite is enabled
- Verify RewriteBase path

### Issue: Images Not Loading
- Check file paths in database
- Verify upload folder permissions
- Check if assets are uploaded correctly

## Maintenance

### Regular Backups
1. Use cPanel **Backup Wizard**
2. Download full backup monthly
3. Export database weekly

### Monitor Logs
1. Check **Error Log** in cPanel
2. Monitor **Metrics** for traffic
3. Review **Resource Usage**

### Update PHP Version
1. Go to **Select PHP Version**
2. Choose PHP 7.4 or higher
3. Enable required extensions:
   - mysqli
   - pdo_mysql
   - json
   - mbstring

## Security Checklist

- ✅ SSL certificate installed
- ✅ Strong database password
- ✅ File permissions set correctly
- ✅ .htaccess configured
- ✅ PHP error display disabled in production
- ✅ Regular backups enabled
- ✅ Admin panel password protected

## Support

For issues:
1. Check cPanel error logs
2. Review PHP error logs
3. Test API endpoints individually
4. Check database connections
5. Verify file permissions

---

**Deployment Date:** _____________
**Domain:** _____________
**Database Name:** _____________
**Admin Email:** _____________
