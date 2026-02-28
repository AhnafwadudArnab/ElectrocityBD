# MySQL Database Setup for ElectrocityBD

## Overview
This folder contains all MySQL database files for the ElectrocityBD e-commerce application.

## Architecture
```
Flutter App → PHP Backend (localhost:8000) → MySQL Database (localhost:3306)
```

## Prerequisites
1. MySQL Server installed and running
2. MySQL credentials (default: root with no password)
3. PHP 8.0+ with mysqli extension enabled
4. Backend server running on port 8000

## Database Configuration

### Current Settings (backend/.env)
```
DB_HOST=127.0.0.1
DB_PORT=3306
DB_NAME=electrocity_db
DB_USER=root
DB_PASSWORD=
```

## Setup Steps

### Step 1: Start MySQL Server
Make sure MySQL is running on your system.

**Windows:**
```bash
# Check if MySQL is running
net start | findstr MySQL

# Start MySQL if not running
net start MySQL80  # or your MySQL service name
```

**Mac/Linux:**
```bash
# Check status
sudo systemctl status mysql

# Start MySQL
sudo systemctl start mysql
```

### Step 2: Create Database
Open MySQL command line or phpMyAdmin and run:

```sql
CREATE DATABASE IF NOT EXISTS electrocity_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE electrocity_db;
```

### Step 3: Import Database Schema
Import the main database file:

```bash
# Using MySQL command line
mysql -u root -p electrocity_db < databaseMysql/COMPLETE_DATABASE_SETUP.sql

# Or using phpMyAdmin:
# 1. Select 'electrocity_db' database
# 2. Go to 'Import' tab
# 3. Choose 'COMPLETE_DATABASE_SETUP.sql'
# 4. Click 'Go'
```

### Step 4: Verify Database Connection
Test the PHP backend connection:

```bash
cd backend
php -r "
\$conn = new mysqli('127.0.0.1', 'root', '', 'electrocity_db');
if (\$conn->connect_error) {
    die('Connection failed: ' . \$conn->connect_error);
}
echo 'Database connected successfully!';
\$conn->close();
"
```

### Step 5: Start Backend Server
```bash
cd backend
php -S localhost:8000 -t public router.php
```

### Step 6: Test API Endpoints
```bash
# Health check
curl http://localhost:8000/api/health

# Get products
curl http://localhost:8000/api/products?limit=5

# Get categories
curl http://localhost:8000/api/categories
```

## Database Files

### Main Files
- `COMPLETE_DATABASE_SETUP.sql` - Complete database with schema + sample data (USE THIS)
- `electrocity_schema.sql` - Database structure only (tables, indexes, constraints)
- `electrocity_sample_data.sql` - Sample product data

### Legacy Files (for reference)
- `All_db.sql` - Old combined database
- `electrocity_db (1).sql` - Backup copy
- `electrocity_assets_products.sql` - Asset products data

## Database Structure

### Main Tables
1. **users** - User accounts (customers, admins)
2. **categories** - Product categories
3. **brands** - Product brands
4. **products** - Product catalog
5. **orders** - Customer orders
6. **order_items** - Order line items
7. **cart** - Shopping cart items
8. **wishlist** - User wishlist
9. **reviews** - Product reviews
10. **banners** - Homepage banners
11. **collections** - Product collections
12. **payments** - Payment records

## Troubleshooting

### Issue: "Access denied for user 'root'@'localhost'"
**Solution:** Update password in `backend/.env`:
```
DB_PASSWORD=your_mysql_password
```

### Issue: "Unknown database 'electrocity_db'"
**Solution:** Create the database first:
```sql
CREATE DATABASE electrocity_db;
```

### Issue: "Table doesn't exist"
**Solution:** Import the schema:
```bash
mysql -u root -p electrocity_db < databaseMysql/COMPLETE_DATABASE_SETUP.sql
```

### Issue: Backend can't connect to database
**Solution:** Check MySQL is running and credentials are correct:
```bash
# Test connection
mysql -u root -p -e "SHOW DATABASES;"
```

## API Endpoints Using Database

### Products
- `GET /api/products` - Get all products
- `GET /api/products/{id}` - Get single product
- `POST /api/products` - Create product (admin)
- `PUT /api/products/{id}` - Update product (admin)
- `DELETE /api/products/{id}` - Delete product (admin)

### Categories
- `GET /api/categories` - Get all categories
- `GET /api/categories/{id}/products` - Get products by category

### Orders
- `GET /api/orders` - Get user orders
- `POST /api/orders` - Create new order
- `GET /api/orders/{id}` - Get order details

### Cart
- `GET /api/cart` - Get cart items
- `POST /api/cart` - Add to cart
- `PUT /api/cart/{id}` - Update cart item
- `DELETE /api/cart/{id}` - Remove from cart

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - User login
- `POST /api/auth/logout` - User logout

## Backup Database

To backup your database:
```bash
mysqldump -u root -p electrocity_db > backup_$(date +%Y%m%d).sql
```

## Reset Database

To completely reset the database:
```bash
mysql -u root -p -e "DROP DATABASE IF EXISTS electrocity_db; CREATE DATABASE electrocity_db;"
mysql -u root -p electrocity_db < databaseMysql/COMPLETE_DATABASE_SETUP.sql
```

## Support

For issues with:
- **Database connection**: Check MySQL service and credentials
- **API not working**: Verify backend server is running
- **Data not showing**: Check database has data imported
- **Permission errors**: Verify MySQL user has proper privileges

## Next Steps

After setup:
1. ✅ Database created and imported
2. ✅ Backend server running
3. ✅ API endpoints responding
4. ✅ Flutter app connected
5. 🎉 Start developing!
