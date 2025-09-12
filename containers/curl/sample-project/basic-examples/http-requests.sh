#!/bin/bash

echo "🌐 Basic HTTP Requests Examples"
echo "==============================="

# Test GET request
echo -e "\n1. GET Request:"
curl -s https://httpbin.org/get | jq .

# Test POST request
echo -e "\n2. POST Request:"
curl -s -X POST https://httpbin.org/post \
  -H "Content-Type: application/json" \
  -d '{"name": "John Doe", "email": "john@example.com"}' | jq .

# Test PUT request
echo -e "\n3. PUT Request:"
curl -s -X PUT https://httpbin.org/put \
  -H "Content-Type: application/json" \
  -d '{"id": 1, "status": "updated"}' | jq .

# Test DELETE request
echo -e "\n4. DELETE Request:"
curl -s -X DELETE https://httpbin.org/delete | jq .

# Test with custom headers
echo -e "\n5. Request with Custom Headers:"
curl -s https://httpbin.org/headers \
  -H "User-Agent: MyApp/1.0" \
  -H "Authorization: Bearer token123" \
  -H "X-Custom-Header: test-value" | jq .headers

echo -e "\n✅ Basic HTTP requests completed!"
