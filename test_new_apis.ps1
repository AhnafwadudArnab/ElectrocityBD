Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Testing New ElectrocityBD APIs" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$baseUrl = "http://localhost:8000/api"

function Test-API {
    param($name, $endpoint)
    Write-Host "$name..." -ForegroundColor Yellow
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl$endpoint" -Method Get -ErrorAction Stop
        Write-Host "✓ Success" -ForegroundColor Green
        $response | ConvertTo-Json -Depth 3 | Write-Host
    } catch {
        Write-Host "✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    Write-Host ""
}

# Test Health Check
Test-API "1. Health Check" "/health"

# Test Categories
Test-API "2. Categories API" "/categories"

# Test Brands
Test-API "3. Brands API" "/brands"

# Test Collections
Test-API "4. Collections API" "/collections"

# Test Best Sellers
Test-API "5. Best Sellers API" "/best_sellers?limit=5"

# Test Trending
Test-API "6. Trending Products API" "/trending?limit=5"

# Test Tech Part
Test-API "7. Tech Part API" "/tech_part"

# Test Flash Sales
Test-API "8. Flash Sales API" "/flash_sales"

# Test Site Settings
Test-API "9. Site Settings API" "/site_settings"

# Test Popular Searches
Test-API "10. Popular Searches API" "/search_history?popular=true&limit=5"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "All Tests Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
