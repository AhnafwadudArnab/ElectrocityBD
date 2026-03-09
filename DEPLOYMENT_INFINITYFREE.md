# ElectrocityBD - InfinityFree Hosting Deployment Guide

## ⚠️ Important InfinityFree Limitations

Before deploying, understand these limitations:
- **No custom .htaccess** in some areas
- **Limited PHP execution time** (30 seconds)
- **No SSH access**
- **Limited database size** (400MB free)
- **Bandwidth limits** (may suspend if exceeded)
- **Forced ads** on free plan (can upgrade to remove)
- **No email sending** from PHP (use external SMTP)

## Prerequisites
- InfinityFree account (free or premium)
- Domain/subdomain configured
- FTP access credentials
- MySQL database access

## Step 1: Sign Up & Setup

### 1.1 Create InfinityFree Account
1. Visit: https://infinityfree.net
2. Click **Sign Up**
3. Create account with email
4. Verify email address

### 1.2 Create Hosting Account
1. Login to InfinityFree control panel
2. Click **Create Account**
3. Choose subdomain or use custom domain
4. Example: `electrocitybd.infinityfreeapp.com`
5. Wait for account activation (instant)

### 1.3 Get FTP Credentials
1. Go to **Control Panel**
2. Click **FTP Details**
3. Note down:
   - FTP Hostname: `ftpupload.net`
   - FTP Username: `epiz_xxxxx`
   - FTP Password: (your password)
   - FTP Port: `21`

## Step 2: Database Setup

### 2.1 Create MySQL Database
1. Go to **MySQL Databases** in control panel
2. Click **Create Database**
3. Database name will be: `epiz_xxxxx_electrocity`
4. Note down:
   - Database name: `epiz_xxxxx_electrocity`
   - Database user: `epiz_xxxxx`
   - Database password: (your password)
   - Database host: `sql200.infinityfree.com` (or similar)

### 2.2 Access phpMyAdmin
1. Click **phpMyAdmin** in control panel
2. Login with database credentials
3. Select your database

### 2.3 Import Database Schema
Run this SQL in phpMyAdmin:

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Order items table
CREATE TABLE IF NOT EXISTS order_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    product_name VARCHAR(255),
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    image_url VARCHAR(500),
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Categories table
CREATE TABLE IF NOT EXISTS categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Brands table
CREATE TABLE IF NOT EXISTS brands (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL,
    brand_logo VARCHAR(500)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Payment methods table
CREATE TABLE IF NOT EXISTS payment_methods (
    id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(50) NOT NULL,
    is_enabled TINYINT(1) DEFAULT 1,
    account_number VARCHAR(100),
    instructions TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert default payment methods
INSERT INTO payment_methods (method_name, is_enabled, account_number) VALUES
('bKash', 1, '01977566065'),
('Nagad', 1, '01977566065')
ON DUPLICATE KEY UPDATE method_name=method_name;

-- Best sellers table
CREATE TABLE IF NOT EXISTS best_sellers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    sales_count INT DEFAULT 0,
    selling_point TEXT,
    sales_strategy VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Trending products table
CREATE TABLE IF NOT EXISTS trending_products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    trending_score INT DEFAULT 0,
    image_path VARCHAR(500),
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Flash sales table
CREATE TABLE IF NOT EXISTS flash_sales (
    flash_sale_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    end_time DATETIME NOT NULL,
    active TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Flash sale products table
CREATE TABLE IF NOT EXISTS flash_sale_products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    flash_sale_id INT NOT NULL,
    product_id INT NOT NULL,
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (flash_sale_id) REFERENCES flash_sales(flash_sale_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

## Step 3: Upload Backend Files

### 3.1 Prepare Backend Files
On your local machine:

```bash
cd backend
# Remove unnecessary files
rm -rf .git node_modules
```

### 3.2 Update Database Configuration
Edit `backend/config/database.php`:

```php
<?php
class Database {
    // InfinityFree database settings
    private $host = "sql200.infinityfree.com"; // Your DB host
    private $db_name = "epiz_xxxxx_electrocity"; // Your DB name
    private $username = "epiz_xxxxx"; // Your DB username
    private $password = "your_password"; // Your DB password
    public $conn;

    public function getConnection() {
        $this->conn = null;
        try {
            $this->conn = new PDO(
                "mysql:host=" . $this->host . ";dbname=" . $this->db_name,
                $this->username,
                $this->password,
                array(
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_PERSISTENT => false, // Important for InfinityFree
                    PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4"
                )
            );
        } catch(PDOException $exception) {
            error_log("Connection error: " . $exception->getMessage());
            die("Database connection failed");
        }
        return $this->conn;
    }
}
```

### 3.3 Upload via FTP
Using FileZilla or any FTP client:

```
Host: ftpupload.net
Username: epiz_xxxxx
Password: your_password
Port: 21

Upload to: /htdocs/api/
```

**Important:** Upload to `/htdocs/` folder (not `public_html`)

### 3.4 File Structure on Server
```
/htdocs/
  ├── api/
  │   ├── auth/
  │   ├── config/
  │   ├── models/
  │   ├── public/
  │   │   └── index.php
  │   ├── bootstrap.php
  │   ├── products.php
  │   ├── orders.php
  │   └── ... (other API files)
  ├── index.html (Flutter web)
  ├── main.dart.js
  ├── flutter.js
  └── ... (other Flutter files)
```

## Step 4: Configure Backend for InfinityFree

### 4.1 Update API Bootstrap
Edit `api/bootstrap.php` to handle InfinityFree limitations:

```php
<?php
// Increase execution time (max 30s on InfinityFree)
set_time_limit(30);

// Error handling for production
error_reporting(E_ALL);
ini_set('display_errors', 0);
ini_set('log_errors', 1);

// CORS headers (InfinityFree compatible)
if (isset($_SERVER['HTTP_ORIGIN'])) {
    header("Access-Control-Allow-Origin: {$_SERVER['HTTP_ORIGIN']}");
    header('Access-Control-Allow-Credentials: true');
    header('Access-Control-Max-Age: 86400');
}

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_METHOD']))
        header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
    if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']))
        header("Access-Control-Allow-Headers: {$_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']}");
    exit(0);
}

header('Content-Type: application/json');

// Database connection
require_once __DIR__ . '/config/database.php';

function db() {
    static $conn = null;
    if ($conn === null) {
        $database = new Database();
        $conn = $database->getConnection();
    }
    return $conn;
}
```

### 4.2 Create .htaccess (if allowed)
Create `api/.htaccess`:

```apache
# Basic routing
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ public/index.php [QSA,L]
</IfModule>

# Disable directory listing
Options -Indexes

# PHP settings (may not work on InfinityFree)
<IfModule mod_php7.c>
php_value upload_max_filesize 5M
php_value post_max_size 5M
php_value max_execution_time 30
</IfModule>
```

## Step 5: Deploy Flutter Web App

### 5.1 Update API URL
Edit `lib/Front-end/utils/api_service.dart`:

```dart
class ApiService {
  // InfinityFree URL
  static const String baseUrl = 'https://electrocitybd.infinityfreeapp.com/api';
  
  // Or if using custom domain:
  // static const String baseUrl = 'https://yourdomain.com/api';
  
  // Rest of the code...
}
```

### 5.2 Build Flutter Web
```bash
flutter clean
flutter pub get
flutter build web --release --web-renderer html
```

**Note:** Use `--web-renderer html` for better compatibility

### 5.3 Upload Web Files
1. Connect via FTP to `/htdocs/`
2. Upload all files from `build/web/` to `/htdocs/`
3. Files should be directly in `/htdocs/`:
   - `/htdocs/index.html`
   - `/htdocs/main.dart.js`
   - `/htdocs/flutter.js`
   - `/htdocs/assets/`
   - etc.

### 5.4 Create .htaccess for Flutter
Create `/htdocs/.htaccess`:

```apache
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /

# Don't rewrite files or directories
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d

# Don't rewrite API calls
RewriteCond %{REQUEST_URI} !^/api/

# Rewrite to index.html
RewriteRule ^(.*)$ index.html [L]
</IfModule>

# GZIP compression
<IfModule mod_deflate.c>
AddOutputFilterByType DEFLATE text/html text/css text/javascript application/javascript application/json
</IfModule>
```

## Step 6: Test Deployment

### 6.1 Test API
Visit in browser:
```
https://electrocitybd.infinityfreeapp.com/api/health
https://electrocitybd.infinityfreeapp.com/api/products
```

### 6.2 Test Web App
Visit: `https://electrocitybd.infinityfreeapp.com`

### 6.3 Common Issues & Fixes

**Issue: 403 Forbidden**
- Check file permissions (644 for files, 755 for folders)
- Ensure files are in `/htdocs/` not root

**Issue: Database Connection Failed**
- Verify database host (not `localhost`)
- Check database credentials
- Ensure database exists

**Issue: API Returns 404**
- Check if `.htaccess` is uploaded
- Verify API file paths
- Check `public/index.php` routing

**Issue: Slow Loading**
- InfinityFree has speed limits
- Consider upgrading to premium
- Optimize images and assets

**Issue: Random Suspensions**
- InfinityFree may suspend for high usage
- Check resource usage in control panel
- Consider premium plan for production

## Step 7: SSL Certificate

### 7.1 Enable SSL
1. Go to InfinityFree control panel
2. Click **SSL Certificates**
3. Click **Install SSL Certificate**
4. Wait for automatic installation (free Let's Encrypt)

### 7.2 Force HTTPS
Add to top of `/htdocs/.htaccess`:

```apache
# Force HTTPS
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
```

## Step 8: Optimization for InfinityFree

### 8.1 Reduce Database Queries
- Use caching where possible
- Minimize JOIN operations
- Index frequently queried columns

### 8.2 Optimize Images
```bash
# Compress images before upload
# Use tools like TinyPNG or ImageOptim
```

### 8.3 Enable Browser Caching
Add to `.htaccess`:

```apache
<IfModule mod_expires.c>
ExpiresActive On
ExpiresByType image/jpg "access plus 1 month"
ExpiresByType image/jpeg "access plus 1 month"
ExpiresByType image/png "access plus 1 month"
ExpiresByType text/css "access plus 1 month"
ExpiresByType application/javascript "access plus 1 month"
</IfModule>
```

## InfinityFree Limitations Workarounds

### Email Sending
InfinityFree blocks PHP mail(). Use external SMTP:
- Gmail SMTP
- SendGrid
- Mailgun
- Or upgrade to premium

### File Upload Limits
- Max 10MB per file
- Use external storage for large files (Cloudinary, AWS S3)

### Execution Time
- Max 30 seconds
- Break long operations into smaller chunks
- Use AJAX for progressive loading

### Database Size
- Free: 400MB limit
- Monitor size in control panel
- Clean old data regularly
- Upgrade if needed

## Monitoring & Maintenance

### Check Resource Usage
1. Login to InfinityFree control panel
2. View **Resource Usage**
3. Monitor:
   - Bandwidth usage
   - Database size
   - File count
   - CPU usage

### Backup Strategy
1. Export database weekly via phpMyAdmin
2. Download files via FTP monthly
3. Store backups locally or cloud

### Update Regularly
- Check for PHP updates
- Update Flutter dependencies
- Monitor security advisories

## Upgrading to Premium

If free plan limitations are too restrictive:

### Premium Benefits
- No ads
- Better performance
- More bandwidth
- Larger database
- Email sending
- Better support
- Custom nameservers

### Cost
- Check InfinityFree pricing page
- Usually $2-5/month

## Troubleshooting

### Site Not Loading
1. Check if account is active
2. Verify DNS settings
3. Check error logs in control panel
4. Test API endpoints individually

### Database Errors
1. Check connection settings
2. Verify database exists
3. Check table structure
4. Review phpMyAdmin logs

### Performance Issues
1. Optimize images
2. Enable caching
3. Minimize API calls
4. Consider CDN for assets

## Support Resources

- InfinityFree Forum: https://forum.infinityfree.net
- Knowledge Base: https://infinityfree.net/support
- Community Discord/Telegram groups

---

## Quick Checklist

- ✅ InfinityFree account created
- ✅ Database created and configured
- ✅ Backend files uploaded to `/htdocs/api/`
- ✅ Database credentials updated
- ✅ Flutter web built and uploaded to `/htdocs/`
- ✅ API URL updated in Flutter app
- ✅ SSL certificate installed
- ✅ .htaccess files configured
- ✅ Test all functionality
- ✅ Monitor resource usage

---

**Deployment Date:** _____________
**Domain:** _____________
**Database Name:** _____________
**FTP Username:** _____________

**Note:** InfinityFree is great for testing and small projects, but for production e-commerce, consider upgrading to premium or using paid hosting for better reliability and performance.
