# Backend Server Startup Guide

## Overview
The ElectrocityBD project uses a PHP backend server that needs to be running for the Flutter app to work properly.

## Prerequisites
- PHP 8.0 or higher installed
- MySQL/MariaDB database server running
- Database configured in `backend/.env`

## Current Database Configuration
```
DB_HOST=127.0.0.1
DB_PORT=3306
DB_NAME=electrocity_db
DB_USER=root
DB_PASSWORD=
```

## Starting the Backend Server

### Method 1: Using Command Line
```bash
cd backend
php -S localhost:8000 -t public router.php
```

### Method 2: Using PowerShell (Windows)
```powershell
cd backend
php -S localhost:8000 -t public router.php
```

## Verifying the Server is Running

Test the health endpoint:
```bash
curl http://localhost:8000/api/health
```

Expected response:
```json
{"status":"ok"}
```

## API Endpoints

The backend provides the following endpoints:

- `GET /api/health` - Health check
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `GET /api/products` - Get products
- `POST /api/products` - Create product
- `GET /api/cart` - Get cart items
- `POST /api/cart` - Add to cart
- `GET /api/orders` - Get orders
- `POST /api/orders` - Create order
- `GET /api/users` - Get users

## Flutter App Configuration

The Flutter app is configured to use `http://localhost:8000/api` as the base URL.

This is set in: `lib/Front-end/utils/constants.dart`

## Troubleshooting

### Issue: "Failed to refresh orders from API: Invalid response format"
**Solution**: Make sure the backend server is running on port 8000

### Issue: Database connection errors
**Solution**: 
1. Ensure MySQL/MariaDB is running
2. Check database credentials in `backend/.env`
3. Run database initialization: `php backend/init_db.php`

### Issue: Port 8000 already in use
**Solution**: 
1. Stop any other process using port 8000
2. Or change the port in both backend startup command and Flutter app constants

## Database Setup

If the database is not initialized, run:
```bash
cd backend
php init_db.php
```

This will create all necessary tables and seed initial data.

## Production Deployment

For production, use a proper web server like Apache or Nginx instead of PHP's built-in server.

Configure the web server to:
- Point document root to `backend/public`
- Use `backend/router.php` for URL rewriting
- Enable `.htaccess` (Apache) or equivalent (Nginx)

## Current Status

✅ Backend server is running on http://localhost:8000
✅ Health check endpoint responding
✅ Ready for Flutter app connections
