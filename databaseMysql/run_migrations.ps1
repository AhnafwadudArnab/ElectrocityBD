# PowerShell script to run all database migrations
# Usage: .\databaseMysql\run_migrations.ps1

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "ElectroCityBD Database Migrations" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Prompt for MySQL password
$password = Read-Host "Enter MySQL root password" -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
$plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

Write-Host ""
Write-Host "Running migrations..." -ForegroundColor Yellow
Write-Host ""

# Migration 1: Add created_at columns
Write-Host "[1/4] Adding created_at columns..." -ForegroundColor Green
Get-Content "databaseMysql/add_created_at_columns.sql" | mysql -u root -p"$plainPassword" electrobd
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Created_at columns added successfully" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to add created_at columns" -ForegroundColor Red
}
Write-Host ""

# Migration 2: Fix image paths
Write-Host "[2/4] Fixing image paths..." -ForegroundColor Green
Get-Content "databaseMysql/fix_image_paths.sql" | mysql -u root -p"$plainPassword" electrobd
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Image paths fixed successfully" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to fix image paths" -ForegroundColor Red
}
Write-Host ""

# Migration 3: Verify brands
Write-Host "[3/4] Verifying brands..." -ForegroundColor Green
Get-Content "databaseMysql/verify_brands.sql" | mysql -u root -p"$plainPassword" electrobd
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Brands verified successfully" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to verify brands" -ForegroundColor Red
}
Write-Host ""

# Migration 4: Fix duplicate brands
Write-Host "[4/4] Fixing duplicate brands..." -ForegroundColor Green
Get-Content "databaseMysql/fix_duplicate_brands.sql" | mysql -u root -p"$plainPassword" electrobd
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Duplicate brands fixed successfully" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to fix duplicate brands" -ForegroundColor Red
}
Write-Host ""

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "All migrations completed!" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Restart your backend server" -ForegroundColor White
Write-Host "2. Test the 'See All' pages" -ForegroundColor White
Write-Host "3. Verify images are loading correctly" -ForegroundColor White
Write-Host "4. Check brand filters for duplicates" -ForegroundColor White
Write-Host ""
