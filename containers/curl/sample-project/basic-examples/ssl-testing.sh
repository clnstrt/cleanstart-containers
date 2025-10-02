#!/bin/bash

echo "SSL/TLS Testing"
echo "==============="

# Test HTTPS connection
echo "1. HTTPS Connection:"
curl -s -I https://httpbin.org/headers

# Test SSL certificate
echo -e "\n2. SSL Certificate Check:"
curl -s -w "SSL Result: %{ssl_verify_result}\n" https://httpbin.org/headers

# Test connection timing
echo -e "\n3. Connection Time:"
curl -s -w "Time: %{time_connect}s\n" https://httpbin.org/headers

echo -e "\nDone!"
