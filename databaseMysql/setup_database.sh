#!/bin/bash
# ============================================================
# ElectrocityBD - MySQL Database Setup Script (Mac/Linux)
# ============================================================

echo ""
echo "========================================"
echo "ElectrocityBD Database Setup"
echo "========================================"
echo ""

# Check if MySQL is installed
if ! command -v mysql &> /dev/null; then
    echo "ERROR: MySQL is not installed or not in PATH"
    echo "Please install MySQL first:"
    echo "  Mac: brew install mysql"
    echo "  Ubuntu: sudo apt-get install mysql-server"
    exit 1
fi

echo "MySQL found!"
echo ""

# Prompt for MySQL password
read -sp "Enter MySQL root password (press Enter if no password): " MYSQL_PASSWORD
echo ""
echo ""

echo "Creating database and importing schema..."
echo ""

# Import the complete database setup
if [ -z "$MYSQL_PASSWORD" ]; then
    mysql -u root < COMPLETE_DATABASE_SETUP.sql
else
    mysql -u root -p"$MYSQL_PASSWORD" < COMPLETE_DATABASE_SETUP.sql
fi

if [ $? -eq 0 ]; then
    echo ""
    echo "========================================"
    echo "Database setup completed successfully!"
    echo "========================================"
    echo ""
    echo "Database Name: electrocity_db"
    echo "MySQL Server: localhost:3306"
    echo "Backend API: http://localhost:8000/api"
    echo ""
    echo "Next steps:"
    echo "1. Start the backend server:"
    echo "   cd backend"
    echo "   php -S localhost:8000 -t public router.php"
    echo ""
    echo "2. Start the Flutter app:"
    echo "   flutter run -d chrome"
    echo ""
else
    echo ""
    echo "ERROR: Database setup failed!"
    echo "Please check your MySQL credentials and try again."
    echo ""
    exit 1
fi
