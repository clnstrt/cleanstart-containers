#!/bin/bash

echo "🧪 Running All Curl Examples"
echo "============================"

# Function to run a test
run_test() {
    local test_name=$1
    local test_file=$2
    
    echo -e "\n🔍 Running: $test_name"
    echo "----------------------------------------"
    
    if [ -f "$test_file" ]; then
        bash "$test_file"
        if [ $? -eq 0 ]; then
            echo "✅ $test_name completed successfully"
        else
            echo "❌ $test_name failed"
        fi
    else
        echo "❌ Test file not found: $test_file"
    fi
}

# Run basic examples
echo "📋 Running Basic Examples:"
run_test "HTTP Requests" "/workspace/basic-examples/http-requests.sh"
run_test "File Operations" "/workspace/basic-examples/file-operations.sh"
run_test "SSL Testing" "/workspace/basic-examples/ssl-testing.sh"

# Run advanced examples
echo -e "\n🔧 Running Advanced Examples:"
run_test "API Automation" "/workspace/advanced-examples/api-automation.sh"
run_test "Web Scraping" "/workspace/advanced-examples/web-scraping.sh"
run_test "Load Testing" "/workspace/advanced-examples/load-testing.sh"

# Summary
echo -e "\n📊 Test Summary:"
echo "=================="
echo "✅ All curl examples have been executed"
echo "📁 Check /workspace/data/ for downloaded files"
echo "📁 Check /workspace/data/scraped/ for scraped content"

echo -e "\n🎯 Next Steps:"
echo "1. Review the output above"
echo "2. Check generated files in /workspace/data/"
echo "3. Modify scripts for your specific use cases"
echo "4. Create custom automation scripts"

echo -e "\n✅ All tests completed!"
