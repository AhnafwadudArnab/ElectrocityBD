@echo off
echo ========================================
echo Testing New ElectrocityBD APIs
echo ========================================
echo.

set BASE_URL=http://localhost:8000/api

echo 1. Testing Health Check...
curl -s %BASE_URL%/health
echo.
echo.

echo 2. Testing Categories API...
curl -s %BASE_URL%/categories
echo.
echo.

echo 3. Testing Brands API...
curl -s %BASE_URL%/brands
echo.
echo.

echo 4. Testing Collections API...
curl -s %BASE_URL%/collections
echo.
echo.

echo 5. Testing Best Sellers API...
curl -s %BASE_URL%/best_sellers?limit=5
echo.
echo.

echo 6. Testing Trending Products API...
curl -s %BASE_URL%/trending?limit=5
echo.
echo.

echo 7. Testing Tech Part API...
curl -s %BASE_URL%/tech_part
echo.
echo.

echo 8. Testing Flash Sales API...
curl -s %BASE_URL%/flash_sales
echo.
echo.

echo 9. Testing Site Settings API...
curl -s %BASE_URL%/site_settings
echo.
echo.

echo 10. Testing Popular Searches API...
curl -s %BASE_URL%/search_history?popular=true^&limit=5
echo.
echo.

echo ========================================
echo All Tests Complete!
echo ========================================
pause
