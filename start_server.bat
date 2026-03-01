@echo off
echo ========================================
echo  ElectrocityBD Backend Server
echo ========================================
echo.
echo Starting PHP server on http://localhost:8000
echo Press Ctrl+C to stop the server
echo.
php -S localhost:8000 -t backend/public backend/router.php
