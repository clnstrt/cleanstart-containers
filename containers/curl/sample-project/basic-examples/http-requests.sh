#!/bin/bash

echo "Basic HTTP Requests"
echo "==================="

# GET request
echo "1. GET Request:"
curl -s https://httpbin.org/get

echo -e "\n2. POST Request:"
curl -s -X POST https://httpbin.org/post \
  -H "Content-Type: application/json" \
  -d '{"test": "data"}'

echo -e "\n3. Headers Request:"
curl -s https://httpbin.org/headers

echo -e "\nDone!"
