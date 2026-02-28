@echo off
REM ============================================================
REM ElectrocityBD - MySQL Database Setup Script (Windows)
REM ============================================================

echo.
echo ========================================
echo ElectrocityBD Database Setup
echo ========================================
echo.

REM Check if MySQL is installed
where mysql >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: MySQL is not installed or not in PATH
    echo Please install MySQL and add it to your system PATH
    pause
    exit /b 1
)

echo MySQL found!
echo.

REM Prompt for MySQL password
set /p MYSQL_PASSWORD="Enter MySQL root password (press Enter if no password): "

echo.
echo Creating database and importing schema...
echo.

REM Import the complete database setup
if "%MYSQL_PASSWORD%"=="" (
    mysql -u root < COMPLETE_DATABASE_SETUP.sql
) else (
    mysql -u root -p%MYSQL_PASSWORD% < COMPLETE_DATABASE_SETUP.sql
)

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo Database setup completed successfully!
    echo ========================================
    echo.
    echo Database Name: electrocity_db
    echo MySQL Server: localhost:3306
    echo Backend API: http://localhost:8000/api
    echo.
    echo Next steps:
    echo 1. Start the backend server:
    echo    cd backend
    echo    php -S localhost:8000 -t public router.php
    echo.
    echo 2. Start the Flutter app:
    echo    flutter run -d chrome
    echo.
) else (
    echo.
    echo ERROR: Database setup failed!
    echo Please check your MySQL credentials and try again.
    echo.
)

pause
