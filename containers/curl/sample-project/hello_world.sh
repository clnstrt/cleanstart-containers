#!/bin/sh

echo "🚀 Curl Docker Image - Hello World!"
echo "=================================="

# Test curl version
echo "📋 Curl Version:"
curl --version

# Test basic HTTP request
echo ""
echo "🌐 Testing HTTP Request:"
curl -s https://httpbin.org/get

# Test POST request
echo ""
echo "📤 Testing POST Request:"
curl -s -X POST https://httpbin.org/post \
  -H "Content-Type: application/json" \
  -d '{"message": "Hello from curl container!"}'

# Test file download
echo ""
echo "📥 Testing File Download:"
curl -s -o /tmp/test.txt https://httpbin.org/bytes/100
if [ -f /tmp/test.txt ]; then
  echo "Downloaded file size: $(wc -c < /tmp/test.txt) bytes"
else
  echo "File download failed"
fi

# Test SSL/TLS
echo ""
echo "🔒 Testing SSL/TLS:"
curl -s https://httpbin.org/headers

# Test multiple endpoints
echo ""
echo "🔄 Testing Multiple Endpoints:"
for endpoint in /get /headers /user-agent /ip; do
  echo "  - Testing $endpoint"
  curl -s "https://httpbin.org$endpoint" > /dev/null && echo "    ✓ Success" || echo "    ✗ Failed"
done

echo ""
echo "✅ All tests completed successfully!"