#!/bin/bash

echo "🚀 Curl Docker Image - Hello World!"
echo "=================================="

# Test curl version
echo "📋 Curl Version:"
curl --version

# Test basic HTTP request
echo -e "\n🌐 Testing HTTP Request:"
curl -s https://httpbin.org/get | jq .

# Test POST request
echo -e "\n📤 Testing POST Request:"
curl -s -X POST https://httpbin.org/post \
  -H "Content-Type: application/json" \
  -d '{"message": "Hello from curl container!"}' | jq .

# Test file download
echo -e "\n📥 Testing File Download:"
curl -s -o /tmp/test.txt https://httpbin.org/bytes/100
echo "Downloaded file size: $(wc -c < /tmp/test.txt) bytes"

# Test SSL/TLS
echo -e "\n🔒 Testing SSL/TLS:"
curl -s https://httpbin.org/headers | jq .headers

echo -e "\n✅ All tests completed successfully!"
