@echo off
echo Starting Flutter Web Server...
echo.
echo Opening http://localhost:8080
echo Press Ctrl+C to stop the server
echo.
cd build\web
python -m http.server 8080
