#!/bin/bash

# Test script for PI Planning Visualizations
# Verifies all visualizations are accessible and functional

echo "🧪 Testing PI Planning Visualizations"
echo "======================================"
echo ""

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Base URL for GitHub Pages
BASE_URL="https://corbyjamesibm.github.io/pi-planning-visualization"

# Array of visualizations to test
declare -a visualizations=(
    "index.html:Main Dashboard"
    "PI-PLANNING-EVENT-TIMELAPSE.html:2-Day PI Planning Event"
    "PI-PLANNING-CLUSTER-VIEW.html:Cluster View"
    "PI-PLANNING-TIME-LAPSE.html:90-Day Time-Lapse"
    "PI-PLANNING-SPRINT-VIEW.html:Sprint Planning View"
    "PI-PLANNING-DASHBOARD.html:Planning Dashboard"
    "PI-PLANNING-LIVE-DEMO.html:Live Demo"
)

# Test counter
total=0
passed=0
failed=0

echo "Testing GitHub Pages deployment..."
echo ""

# Test each visualization
for viz in "${visualizations[@]}"; do
    IFS=':' read -r file name <<< "$viz"
    url="$BASE_URL/$file"
    total=$((total + 1))
    
    echo -n "Testing $name... "
    
    # Test if URL is accessible
    status=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    
    if [ "$status" = "200" ]; then
        echo -e "${GREEN}✓ PASS${NC} (HTTP $status)"
        passed=$((passed + 1))
    else
        echo -e "${RED}✗ FAIL${NC} (HTTP $status)"
        failed=$((failed + 1))
    fi
done

echo ""
echo "======================================"
echo "Test Results:"
echo -e "Total: $total | ${GREEN}Passed: $passed${NC} | ${RED}Failed: $failed${NC}"

# Test D3.js CDN availability
echo ""
echo "Testing D3.js CDN availability..."
d3_status=$(curl -s -o /dev/null -w "%{http_code}" "https://d3js.org/d3.v7.min.js")
if [ "$d3_status" = "200" ]; then
    echo -e "${GREEN}✓ D3.js CDN is accessible${NC}"
else
    echo -e "${YELLOW}⚠ D3.js CDN returned status $d3_status${NC}"
fi

# Performance test
echo ""
echo "Performance test (loading main dashboard)..."
load_time=$(curl -s -o /dev/null -w "%{time_total}" "$BASE_URL/index.html")
load_time_ms=$(echo "$load_time * 1000" | bc)
echo "Load time: ${load_time_ms}ms"

if (( $(echo "$load_time < 2" | bc -l) )); then
    echo -e "${GREEN}✓ Good performance (<2s)${NC}"
elif (( $(echo "$load_time < 5" | bc -l) )); then
    echo -e "${YELLOW}⚠ Acceptable performance (2-5s)${NC}"
else
    echo -e "${RED}✗ Poor performance (>5s)${NC}"
fi

echo ""
echo "======================================"

# Summary
if [ $failed -eq 0 ]; then
    echo -e "${GREEN}✅ All tests passed!${NC}"
    echo ""
    echo "Live site: $BASE_URL"
    exit 0
else
    echo -e "${RED}❌ Some tests failed. Please check the deployment.${NC}"
    exit 1
fi