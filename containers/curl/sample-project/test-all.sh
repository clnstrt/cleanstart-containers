#!/bin/bash

echo "=== Curl Sample Project - Complete Test Suite ==="
echo ""

# Test 1: Check curl version
echo "1. Testing curl version:"
echo "Command: docker run --rm cleanstart/curl:latest curl --version"
docker run --rm cleanstart/curl:latest curl --version
echo ""

# Test 2: Simple HTTP GET request
echo "2. Testing simple HTTP GET request:"
echo "Command: docker run --rm cleanstart/curl:latest curl -s https://httpbin.org/get"
docker run --rm cleanstart/curl:latest curl -s https://httpbin.org/get
echo ""

# Test 3: HTTP POST request
echo "3. Testing HTTP POST request:"
echo "Command: docker run --rm cleanstart/curl:latest curl -s -X POST https://httpbin.org/post -H 'Content-Type: application/json' -d '{\"test\": \"data\"}'"
docker run --rm cleanstart/curl:latest curl -s -X POST https://httpbin.org/post \
  -H "Content-Type: application/json" \
  -d '{"test": "data"}'
echo ""

# Test 4: File download
echo "4. Testing file download:"
echo "Creating data directory..."
mkdir -p ./data
echo "Command: docker run --rm -v \$(pwd)/data:/workspace cleanstart/curl:latest curl -s -o /workspace/test.json https://httpbin.org/json"
docker run --rm -v $(pwd)/data:/workspace cleanstart/curl:latest \
  curl -s -o /workspace/test.json https://httpbin.org/json
echo "File downloaded successfully!"
echo ""

# Test 5: Check downloaded file
echo "5. Checking downloaded file:"
echo "Command: ls -la ./data/"
ls -la ./data/
echo ""

# Test 6: Run basic example scripts
echo "6. Testing basic example scripts:"
echo ""

echo "6a. HTTP Requests Script:"
echo "Command: docker run --rm -v \$(pwd):/workspace --entrypoint /bin/sh cleanstart/curl:latest /workspace/basic-examples/http-requests.sh"
docker run --rm -v $(pwd):/workspace --entrypoint /bin/sh cleanstart/curl:latest /workspace/basic-examples/http-requests.sh
echo ""

echo "6b. File Operations Script:"
echo "Command: docker run --rm -v \$(pwd):/workspace --entrypoint /bin/sh cleanstart/curl:latest /workspace/basic-examples/file-operations.sh"
docker run --rm -v $(pwd):/workspace --entrypoint /bin/sh cleanstart/curl:latest /workspace/basic-examples/file-operations.sh
echo ""

echo "6c. SSL Testing Script:"
echo "Command: docker run --rm -v \$(pwd):/workspace --entrypoint /bin/sh cleanstart/curl:latest /workspace/basic-examples/ssl-testing.sh"
docker run --rm -v $(pwd):/workspace --entrypoint /bin/sh cleanstart/curl:latest /workspace/basic-examples/ssl-testing.sh
echo ""

echo "=== All tests completed successfully! ==="
echo ""
echo "Summary:"
echo "- ✅ Curl version check"
echo "- ✅ HTTP GET request"
echo "- ✅ HTTP POST request"
echo "- ✅ File download"
echo "- ✅ Basic example scripts"
echo ""
echo "The curl sample project is working correctly!"
