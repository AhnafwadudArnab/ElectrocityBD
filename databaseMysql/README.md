# ElectrocityBD MySQL Database

This folder contains all MySQL database files and setup scripts for the ElectrocityBD e-commerce application.

## 📁 Folder Structure

```
databaseMysql/
├── COMPLETE_DATABASE_SETUP.sql    ⭐ Main file - Use this!
├── SETUP_INSTRUCTIONS.md          📖 Detailed setup guide
├── setup_database.bat             🪟 Windows setup script
├── setup_database.sh              🐧 Mac/Linux setup script
├── electrocity_schema.sql         📋 Database structure only
├── electrocity_sample_data.sql    📊 Sample data only
└── README.md                      📄 This file
```

## 🚀 Quick Start

### Option 1: Automated Setup (Recommended)

**Windows:**
```bash
cd databaseMysql
setup_database.bat
```

**Mac/Linux:**
```bash
cd databaseMysql
chmod +x setup_database.sh
./setup_database.sh
```

### Option 2: Manual Setup

1. **Open MySQL command line:**
   ```bash
   mysql -u root -p
   ```

2. **Import the database:**
   ```sql
   source /path/to/databaseMysql/COMPLETE_DATABASE_SETUP.sql
   ```

3. **Verify:**
   ```sql
   USE electrocity_db;
   SHOW TABLES;
   SELECT COUNT(*) FROM products;
   ```

### Option 3: Using phpMyAdmin

1. Open phpMyAdmin in browser
2. Click "Import" tab
3. Choose `COMPLETE_DATABASE_SETUP.sql`
4. Click "Go"

## 📊 Database Information

- **Database Name:** `electrocity_db`
- **Character Set:** `utf8mb4`
- **Collation:** `utf8mb4_unicode_ci`
- **Tables:** 24 tables
- **Sample Data:** 10 products, 6 categories, 5 brands, 14 collections

## 🔗 Connection Details

```
Host: 127.0.0.1 (localhost)
Port: 3306
Database: electrocity_db
Username: root
Password: (your MySQL password)
```

Update these in `backend/.env`:
```env
DB_HOST=127.0.0.1
DB_PORT=3306
DB_NAME=electrocity_db
DB_USER=root
DB_PASSWORD=your_password_here
```

## 📋 Database Tables

### Core Tables
- `users` - User accounts (customers & admins)
- `products` - Product catalog
- `categories` - Product categories
- `brands` - Product brands
- `orders` - Customer orders
- `order_items` - Order line items

### Feature Tables
- `cart` - Shopping cart
- `wishlists` - User wishlists
- `reviews` - Product reviews
- `discounts` - Product discounts
- `promotions` - Site-wide promotions

### Homepage Sections
- `best_sellers` - Best selling products
- `trending_products` - Trending items
- `deals_of_the_day` - Daily deals
- `flash_sales` - Flash sale events
- `flash_sale_products` - Products in flash sales
- `tech_part_products` - Tech section products
- `collections` - Product collections (Fans, Cookers, Blenders, etc.)
- `collection_items` - Items within collections (e.g., Charger Fan, Mini Hand Fan)
- `collection_products` - Products in collections
- `banners` - Homepage banners (Hero, Mid, Sidebar)

### Admin & Settings
- `banners` - Homepage banners (Hero, Mid, Sidebar with dates)
- `payments` - Payment records
- `customer_support` - Support tickets
- `reports` - Admin reports
- `site_settings` - Site configuration
- `search_history` - Search queries and analytics
- `product_specifications` - Detailed product specs

## 🔐 Default Admin Account

```
Email: admin@electrocitybd.com
Password: admin123
```

**⚠️ IMPORTANT:** Change this password immediately in production!

## 🧪 Testing the Setup

### 1. Test MySQL Connection
```bash
mysql -u root -p -e "USE electrocity_db; SELECT COUNT(*) FROM products;"
```

### 2. Test Backend API
```bash
# Start backend
cd backend
php -S localhost:8000 -t public router.php

# In another terminal, test API
curl http://localhost:8000/api/health
curl http://localhost:8000/api/products?limit=5
```

### 3. Test Flutter App
```bash
flutter run -d chrome
```

## 📝 Sample Data Included

- **10 Products** across different categories
- **6 Categories** (Kitchen, Personal Care, Home Comfort, Lighting, Wiring, Tools)
- **5 Brands** (Philips, Walton, Samsung, LG, Sony)
- **14 Collections** (Fans, Cookers, Blenders, Phone Related, Massager Items, Trimmer, Electric Chula, Iron, Chopper, Grinder, Kettle, Hair Dryer, Oven, Air Fryer)
- **10+ Collection Items** (Charger Fan, Mini Hand Fan, Rice Cooker, etc.)
- **2 Promotions** (Winter Sale, Tools Discount)
- **1 Flash Sale** with 3 products
- **7 Banners** (3 hero, 2 mid, 2 sidebar)
- **1 Admin User** for testing

## 🔄 Reset Database

To completely reset and start fresh:

```bash
mysql -u root -p -e "DROP DATABASE IF EXISTS electrocity_db;"
mysql -u root -p < COMPLETE_DATABASE_SETUP.sql
```

## 📦 Backup Database

Create a backup:
```bash
mysqldump -u root -p electrocity_db > backup_$(date +%Y%m%d_%H%M%S).sql
```

Restore from backup:
```bash
mysql -u root -p electrocity_db < backup_20260228_123456.sql
```

## 🐛 Troubleshooting

### MySQL not found
```bash
# Windows: Add MySQL to PATH
# Mac: brew install mysql
# Linux: sudo apt-get install mysql-server
```

### Access denied
- Check username and password
- Update `backend/.env` with correct credentials

### Database already exists
```bash
# Drop and recreate
mysql -u root -p -e "DROP DATABASE electrocity_db;"
mysql -u root -p < COMPLETE_DATABASE_SETUP.sql
```

### Tables not created
- Check MySQL user has CREATE privileges
- Run: `GRANT ALL PRIVILEGES ON electrocity_db.* TO 'root'@'localhost';`

## 📚 Additional Resources

- [MySQL Documentation](https://dev.mysql.com/doc/)
- [PHP MySQLi Documentation](https://www.php.net/manual/en/book.mysqli.php)
- [Flutter HTTP Package](https://pub.dev/packages/http)

## 🆘 Support

For issues:
1. Check `SETUP_INSTRUCTIONS.md` for detailed guide
2. Verify MySQL is running: `mysql -u root -p -e "SELECT 1;"`
3. Check backend logs for connection errors
4. Ensure `.env` file has correct database credentials

## ✅ Checklist

After setup, verify:
- [ ] MySQL server is running
- [ ] Database `electrocity_db` exists
- [ ] All 22 tables are created
- [ ] Sample data is imported (10 products)
- [ ] Backend can connect to database
- [ ] API endpoints return data
- [ ] Flutter app loads products

## 🎉 You're Ready!

Once setup is complete:
1. ✅ Database is ready
2. ✅ Sample data loaded
3. ✅ Backend can connect
4. 🚀 Start building!

---

**Architecture:** Flutter App → PHP Backend (port 8000) → MySQL Database (port 3306)

**Last Updated:** February 28, 2026
