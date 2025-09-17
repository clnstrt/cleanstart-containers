#!/bin/bash

echo "🔒 SSL/TLS Testing Examples"
echo "==========================="

# Test SSL certificate
echo -e "\n1. SSL Certificate Information:"
curl -s -I https://google.com

# Test SSL connection details
echo -e "\n2. SSL Connection Details:"
curl -s -v https://httpbin.org/headers 2>&1 | grep -E "(SSL|TLS|Certificate)"

# Test with different SSL options
echo -e "\n3. Testing with SSL Options:"
curl -s -k https://httpbin.org/headers | jq .headers

# Test SSL certificate validation
echo -e "\n4. SSL Certificate Validation:"
curl -s -w "SSL Verify Result: %{ssl_verify_result}\n" https://httpbin.org/headers

# Test with custom CA bundle
echo -e "\n5. Testing with System CA Bundle:"
curl -s --cacert /etc/ssl/certs/ca-certificates.crt https://httpbin.org/headers | jq .headers

# Test SSL protocols
echo -e "\n6. Testing SSL Protocols:"
for protocol in tlsv1.2 tlsv1.3; do
  echo "Testing $protocol:"
  curl -s --tlsv1.2 https://httpbin.org/headers > /dev/null && echo "  ✅ $protocol supported" || echo "  ❌ $protocol not supported"
done

echo -e "\n✅ SSL/TLS testing completed!"
