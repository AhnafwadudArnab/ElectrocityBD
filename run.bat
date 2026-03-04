@echo off
setlocal

if "%~1"=="" goto :usage

if /I "%~1"=="backend" goto :backend
if /I "%~1"=="web" goto :web
if /I "%~1"=="test" goto :test

goto :usage

:backend
echo Starting PHP backend on http://localhost:8000
php -S localhost:8000 -t backend/public backend/router.php
goto :eof

:web
echo Starting Flutter web static server on http://localhost:8080
cd build\web
python -m http.server 8080
goto :eof

:test
set BASE_URL=http://localhost:8000/api
echo Testing APIs on %BASE_URL%
curl -s %BASE_URL%/health
echo.
curl -s %BASE_URL%/categories
echo.
curl -s %BASE_URL%/brands
echo.
curl -s %BASE_URL%/collections
echo.
goto :eof

:usage
echo Usage:
echo   run.bat backend   ^(start PHP backend^)
echo   run.bat web       ^(serve Flutter build/web^)
echo   run.bat test      ^(quick API test^)
exit /b 1
