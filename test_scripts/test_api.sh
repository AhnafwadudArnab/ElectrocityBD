#!/bin/bash
# API Testing Script
# Run this to test all API endpoints

API_URL="${1:-http://localhost:8000/api}"
echo "Testing API at: $API_URL"
echo "================================"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Test health endpoint
echo -e "\n1. Testing Health Endpoint..."
response=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL/health")
if [ "$response" -eq 200 ]; then
    echo -e "${GREEN}✓ Health check passed${NC}"
else
    echo -e "${RED}✗ Health check failed (HTTP $response)${NC}"
fi

# Test products endpoint
echo -e "\n2. Testing Products Endpoint..."
response=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL/products")
if [ "$response" -eq 200 ]; then
    echo -e "${GREEN}✓ Products endpoint working${NC}"
else
    echo -e "${RED}✗ Products endpoint failed (HTTP $response)${NC}"
fi

# Test categories endpoint
echo -e "\n3. Testing Categories Endpoint..."
response=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL/categories")
if [ "$response" -eq 200 ]; then
    echo -e "${GREEN}✓ Categories endpoint working${NC}"
else
    echo -e "${RED}✗ Categories endpoint failed (HTTP $response)${NC}"
fi

# Test brands endpoint
echo -e "\n4. Testing Brands Endpoint..."
response=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL/brands")
if [ "$response" -eq 200 ]; then
    echo -e "${GREEN}✓ Brands endpoint working${NC}"
else
    echo -e "${RED}✗ Brands endpoint failed (HTTP $response)${NC}"
fi

# Test banners endpoint
echo -e "\n5. Testing Banners Endpoint..."
response=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL/banners")
if [ "$response" -eq 200 ]; then
    echo -e "${GREEN}✓ Banners endpoint working${NC}"
else
    echo -e "${RED}✗ Banners endpoint failed (HTTP $response)${NC}"
fi

# Test promotions endpoint
echo -e "\n6. Testing Promotions Endpoint..."
response=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL/promotions")
if [ "$response" -eq 200 ]; then
    echo -e "${GREEN}✓ Promotions endpoint working${NC}"
else
    echo -e "${RED}✗ Promotions endpoint failed (HTTP $response)${NC}"
fi

# Test flash sales endpoint
echo -e "\n7. Testing Flash Sales Endpoint..."
response=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL/flash_sales")
if [ "$response" -eq 200 ]; then
    echo -e "${GREEN}✓ Flash sales endpoint working${NC}"
else
    echo -e "${RED}✗ Flash sales endpoint failed (HTTP $response)${NC}"
fi

echo -e "\n================================"
echo "API testing completed!"
echo "================================"
