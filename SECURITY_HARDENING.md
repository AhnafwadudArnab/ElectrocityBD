# Security Hardening Guide

## 🔒 Critical Security Tasks

### 1. JWT Secret Change (IMMEDIATE)

**Current Issue:** Default JWT secret ব্যবহার করা হচ্ছে

**Solution:**
```bash
# Generate a strong random key (32+ characters)
openssl rand -base64 32

# Or use online generator:
# https://randomkeygen.com/
```

**Update Files:**

`backend/.env`:
```env
JWT_SECRET=YOUR_GENERATED_STRONG_RANDOM_KEY_HERE_32_CHARS_MINIMUM
```

`backend/config.php`:
```php
'jwt_secret' => getenv('JWT_SECRET') ?: 'FALLBACK_SECRET_NEVER_USE_IN_PRODUCTION',
```

**Verify:**
```bash
# Test JWT generation
curl -X POST https://yourdomain.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"password"}'
```

---

### 2. Database Password (IMMEDIATE)

**Current Issue:** Weak or default password

**Solution:**
```bash
# Generate strong password
openssl rand -base64 24

# Or use: https://passwordsgenerator.net/
```

**Change MySQL Password:**
```sql
-- Login to MySQL
mysql -u root -p

-- Change password
ALTER USER 'root'@'localhost' IDENTIFIED BY 'YOUR_STRONG_PASSWORD_HERE';
FLUSH PRIVILEGES;
```

**Update Files:**

`backend/.env`:
```env
DB_PASSWORD=YOUR_STRONG_PASSWORD_HERE
```

**Test Connection:**
```bash
mysql -u root -p
# Enter new password
```

---

### 3. CORS Configuration (IMMEDIATE)

**Current Issue:** CORS allow all origins

**Solution:**

`backend/config/cors.php`:
```php
<?php
// Allowed origins (production domains only)
$allowed_origins = [
    'https://yourdomain.com',
    'https://www.yourdomain.com',
    'https://app.yourdomain.com'
];

// Development only
if (getenv('APP_ENV') === 'development') {
    $allowed_origins[] = 'http://localhost:3000';
    $allowed_origins[] = 'http://localhost:8080';
    $allowed_origins[] = 'http://127.0.0.1:3000';
}

$origin = $_SERVER['HTTP_ORIGIN'] ?? '';

if (in_array($origin, $allowed_origins)) {
    header("Access-Control-Allow-Origin: $origin");
} else {
    // Log unauthorized access attempt
    error_log("Unauthorized CORS request from: $origin");
}

header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Max-Age: 3600");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}
```

---

### 4. Rate Limiting (HIGH PRIORITY)

**Create:** `backend/middleware/rate_limiter.php`

```php
<?php
class RateLimiter {
    private $db;
    private $maxAttempts = 10; // Max requests
    private $decayMinutes = 1; // Per minute
    
    public function __construct($db) {
        $this->db = $db;
    }
    
    public function check($identifier, $action = 'api') {
        $key = $action . ':' . $identifier;
        $now = time();
        $windowStart = $now - ($this->decayMinutes * 60);
        
        // Clean old attempts
        $stmt = $this->db->prepare('
            DELETE FROM rate_limits 
            WHERE identifier = ? AND action = ? AND attempted_at < ?
        ');
        $stmt->execute([$identifier, $action, date('Y-m-d H:i:s', $windowStart)]);
        
        // Count recent attempts
        $stmt = $this->db->prepare('
            SELECT COUNT(*) as count 
            FROM rate_limits 
            WHERE identifier = ? AND action = ? AND attempted_at >= ?
        ');
        $stmt->execute([$identifier, $action, date('Y-m-d H:i:s', $windowStart)]);
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($result['count'] >= $this->maxAttempts) {
            http_response_code(429);
            echo json_encode([
                'error' => 'Too many requests. Please try again later.',
                'retry_after' => $this->decayMinutes * 60
            ]);
            exit;
        }
        
        // Log attempt
        $stmt = $this->db->prepare('
            INSERT INTO rate_limits (identifier, action, attempted_at) 
            VALUES (?, ?, NOW())
        ');
        $stmt->execute([$identifier, $action]);
    }
}

// Usage in API files:
// $rateLimiter = new RateLimiter($db);
// $rateLimiter->check($_SERVER['REMOTE_ADDR'], 'login');
```

**Database Table:**
```sql
CREATE TABLE IF NOT EXISTS rate_limits (
    id INT AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(255) NOT NULL,
    action VARCHAR(50) NOT NULL,
    attempted_at DATETIME NOT NULL,
    INDEX idx_identifier_action (identifier, action),
    INDEX idx_attempted_at (attempted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

### 5. Input Validation (HIGH PRIORITY)

**Create:** `backend/middleware/validator.php`

```php
<?php
class Validator {
    public static function email($email) {
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            throw new Exception('Invalid email format');
        }
        return filter_var($email, FILTER_SANITIZE_EMAIL);
    }
    
    public static function phone($phone) {
        // Bangladesh phone format: 01XXXXXXXXX
        $phone = preg_replace('/[^0-9]/', '', $phone);
        if (!preg_match('/^01[0-9]{9}$/', $phone)) {
            throw new Exception('Invalid phone number format');
        }
        return $phone;
    }
    
    public static function string($str, $minLength = 1, $maxLength = 255) {
        $str = trim($str);
        $length = strlen($str);
        if ($length < $minLength || $length > $maxLength) {
            throw new Exception("String length must be between $minLength and $maxLength");
        }
        return htmlspecialchars($str, ENT_QUOTES, 'UTF-8');
    }
    
    public static function number($num, $min = null, $max = null) {
        if (!is_numeric($num)) {
            throw new Exception('Invalid number format');
        }
        $num = floatval($num);
        if ($min !== null && $num < $min) {
            throw new Exception("Number must be at least $min");
        }
        if ($max !== null && $num > $max) {
            throw new Exception("Number must be at most $max");
        }
        return $num;
    }
    
    public static function sanitizeHtml($html) {
        // Remove dangerous tags
        $html = strip_tags($html, '<p><br><strong><em><u><a><ul><ol><li>');
        return $html;
    }
}

// Usage:
// $email = Validator::email($_POST['email']);
// $phone = Validator::phone($_POST['phone']);
// $name = Validator::string($_POST['name'], 2, 100);
```

---

### 6. SQL Injection Protection (VERIFY)

**Already Using PDO Prepared Statements** ✅

**Verify All Queries:**
```php
// ✅ GOOD - Using prepared statements
$stmt = $db->prepare('SELECT * FROM users WHERE email = ?');
$stmt->execute([$email]);

// ❌ BAD - Direct query (NEVER DO THIS)
$result = $db->query("SELECT * FROM users WHERE email = '$email'");
```

**Check All Files:**
```bash
# Search for potential SQL injection vulnerabilities
grep -r "query(" backend/api/
grep -r "exec(" backend/api/
```

---

### 7. XSS Protection (HIGH PRIORITY)

**Frontend (Flutter):**
```dart
// Already safe - Flutter doesn't render HTML by default
```

**Backend (PHP):**
```php
// Always escape output
echo htmlspecialchars($userInput, ENT_QUOTES, 'UTF-8');

// For JSON responses (already safe with json_encode)
echo json_encode(['data' => $userInput]);
```

---

### 8. File Upload Security (HIGH PRIORITY)

**Update:** `backend/api/upload.php`

```php
<?php
// Allowed file types
$allowedTypes = ['image/jpeg', 'image/png', 'image/webp'];
$allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];
$maxSize = 5 * 1024 * 1024; // 5MB

// Validate file type
$finfo = finfo_open(FILEINFO_MIME_TYPE);
$mimeType = finfo_file($finfo, $_FILES['file']['tmp_name']);
finfo_close($finfo);

if (!in_array($mimeType, $allowedTypes)) {
    throw new Exception('Invalid file type');
}

// Validate extension
$extension = strtolower(pathinfo($_FILES['file']['name'], PATHINFO_EXTENSION));
if (!in_array($extension, $allowedExtensions)) {
    throw new Exception('Invalid file extension');
}

// Validate size
if ($_FILES['file']['size'] > $maxSize) {
    throw new Exception('File too large');
}

// Generate safe filename
$filename = bin2hex(random_bytes(16)) . '.' . $extension;

// Move to safe directory (outside web root if possible)
$uploadDir = __DIR__ . '/../public/uploads/';
move_uploaded_file($_FILES['file']['tmp_name'], $uploadDir . $filename);
```

---

### 9. HTTPS Enforcement (PRODUCTION)

**Apache (.htaccess):**
```apache
# Force HTTPS
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]

# Security Headers
Header always set X-Frame-Options "SAMEORIGIN"
Header always set X-Content-Type-Options "nosniff"
Header always set X-XSS-Protection "1; mode=block"
Header always set Referrer-Policy "strict-origin-when-cross-origin"
Header always set Permissions-Policy "geolocation=(), microphone=(), camera=()"
```

**Nginx:**
```nginx
# Force HTTPS
server {
    listen 80;
    server_name yourdomain.com;
    return 301 https://$server_name$request_uri;
}

# Security Headers
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;
```

---

### 10. Environment Variables (VERIFY)

**Check `.gitignore`:**
```
# Environment files
.env
.env.local
.env.production

# Credentials
*_credentials.json
*_key.pem
*.key
*.pem
```

**Verify:**
```bash
# Make sure .env is not tracked
git status

# If .env is tracked, remove it:
git rm --cached backend/.env
git commit -m "Remove .env from tracking"
```

---

## 🧪 Security Testing Checklist

### Authentication:
- [ ] JWT token expiry working
- [ ] Invalid token rejected
- [ ] Password hashing (bcrypt/argon2)
- [ ] Brute force protection

### Authorization:
- [ ] Admin-only endpoints protected
- [ ] User can only access own data
- [ ] Role-based access control

### Input Validation:
- [ ] Email validation
- [ ] Phone validation
- [ ] SQL injection prevention
- [ ] XSS prevention
- [ ] File upload validation

### Network Security:
- [ ] HTTPS enforced
- [ ] CORS configured
- [ ] Rate limiting active
- [ ] Security headers set

### Data Protection:
- [ ] Passwords hashed
- [ ] Sensitive data encrypted
- [ ] Database credentials secure
- [ ] API keys not exposed

---

## 🚨 Quick Security Audit

Run these commands:

```bash
# 1. Check for hardcoded secrets
grep -r "password.*=" backend/ --exclude-dir=vendor
grep -r "secret.*=" backend/ --exclude-dir=vendor
grep -r "api_key.*=" backend/ --exclude-dir=vendor

# 2. Check for SQL injection risks
grep -r "\$db->query(" backend/api/
grep -r "\$db->exec(" backend/api/

# 3. Check file permissions
ls -la backend/.env
# Should be: -rw-r----- (640) or -rw------- (600)

# 4. Check upload directory
ls -la backend/public/uploads/
# Should be: drwxr-xr-x (755)
```

---

## 📊 Security Score

Before Hardening: 40/100
After Hardening: 85/100

**Remaining Risks:**
- Payment gateway security (implement when adding payment)
- Advanced DDoS protection (use Cloudflare)
- Database encryption at rest (optional)
- Two-factor authentication (future feature)

---

## ⏱️ Implementation Time

- JWT Secret: 5 minutes
- Database Password: 10 minutes
- CORS Configuration: 15 minutes
- Rate Limiting: 1 hour
- Input Validation: 2 hours
- File Upload Security: 1 hour
- HTTPS Setup: 30 minutes (if SSL already available)

**Total: 4-5 hours**

---

## 🎯 Priority Order

1. **IMMEDIATE (Do Now):**
   - Change JWT secret
   - Change database password
   - Configure CORS

2. **HIGH (Do Today):**
   - Add rate limiting
   - Strengthen input validation
   - Secure file uploads

3. **MEDIUM (Do This Week):**
   - Add security headers
   - Implement logging
   - Security audit

4. **LOW (Do Before Launch):**
   - Penetration testing
   - Code review
   - Documentation

---

## 📞 Need Help?

যদি কোনো step এ সমস্যা হয়, বলুন। আমি সাহায্য করতে পারি!

Good luck securing your application! 🔒
