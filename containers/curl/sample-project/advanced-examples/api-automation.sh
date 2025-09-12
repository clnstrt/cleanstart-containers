#!/bin/bash

echo "🤖 API Automation Examples"
echo "=========================="

# API base URL
API_BASE="https://httpbin.org"

# Function to make API calls
make_api_call() {
    local method=$1
    local endpoint=$2
    local data=$3
    
    echo "Making $method request to $endpoint"
    if [ -n "$data" ]; then
        curl -s -X "$method" "$API_BASE$endpoint" \
            -H "Content-Type: application/json" \
            -d "$data" | jq .
    else
        curl -s -X "$method" "$API_BASE$endpoint" | jq .
    fi
    echo "---"
}

# Test different API endpoints
echo -e "\n1. Testing API Endpoints:"

# GET requests
make_api_call "GET" "/get"
make_api_call "GET" "/headers"

# POST requests
make_api_call "POST" "/post" '{"action": "create", "data": {"name": "test"}}'
make_api_call "POST" "/post" '{"action": "update", "id": 123, "status": "active"}'

# PUT and DELETE
make_api_call "PUT" "/put" '{"id": 123, "changes": {"status": "updated"}}'
make_api_call "DELETE" "/delete"

echo -e "\n2. Batch API Testing:"
# Batch testing multiple endpoints
endpoints=("/get" "/headers" "/user-agent" "/ip")
for endpoint in "${endpoints[@]}"; do
    echo "Testing $endpoint"
    curl -s "$API_BASE$endpoint" | jq -r '.url // .origin // .user-agent // .headers.User-Agent'
done

echo -e "\n3. API Response Analysis:"
# Analyze response times
echo "Response time analysis:"
for i in {1..5}; do
    start_time=$(date +%s%N)
    curl -s "$API_BASE/get" > /dev/null
    end_time=$(date +%s%N)
    duration=$(( (end_time - start_time) / 1000000 ))
    echo "Request $i: ${duration}ms"
done

echo -e "\n✅ API automation completed!"
