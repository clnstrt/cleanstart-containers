#!/bin/bash

echo "⚡ Load Testing Examples"
echo "========================"

# Test URL
TEST_URL="https://httpbin.org/delay/1"

echo -e "\n1. Simple Load Test (10 requests):"
for i in {1..10}; do
    start_time=$(date +%s%N)
    curl -s "$TEST_URL" > /dev/null
    end_time=$(date +%s%N)
    duration=$(( (end_time - start_time) / 1000000 ))
    echo "Request $i: ${duration}ms"
done

echo -e "\n2. Concurrent Load Test:"
# Run 5 concurrent requests
for i in {1..5}; do
    (
        start_time=$(date +%s%N)
        curl -s "$TEST_URL" > /dev/null
        end_time=$(date +%s%N)
        duration=$(( (end_time - start_time) / 1000000 ))
        echo "Concurrent request $i: ${duration}ms"
    ) &
done
wait

echo -e "\n3. Response Time Analysis:"
# Collect response times
times=()
for i in {1..20}; do
    start_time=$(date +%s%N)
    curl -s "$TEST_URL" > /dev/null
    end_time=$(date +%s%N)
    duration=$(( (end_time - start_time) / 1000000 ))
    times+=($duration)
    echo "Request $i: ${duration}ms"
done

# Calculate statistics
total=0
for time in "${times[@]}"; do
    total=$((total + time))
done
average=$((total / ${#times[@]}))

echo -e "\nLoad Test Statistics:"
echo "Total requests: ${#times[@]}"
echo "Average response time: ${average}ms"
echo "Total time: ${total}ms"

echo -e "\n4. HTTP Status Code Monitoring:"
# Monitor HTTP status codes
for i in {1..10}; do
    status=$(curl -s -o /dev/null -w "%{http_code}" "$TEST_URL")
    echo "Request $i: HTTP $status"
done

echo -e "\n✅ Load testing completed!"
