#!/bin/bash

echo "File Operations"
echo "==============="

# Create data directory
mkdir -p /workspace/data

# Download a file
echo "1. Downloading file:"
curl -s -o /workspace/data/sample.json https://httpbin.org/json
echo "Downloaded sample.json"

# Download another file
echo -e "\n2. Downloading text file:"
curl -s -o /workspace/data/robots.txt https://httpbin.org/robots.txt
echo "Downloaded robots.txt"

# List files
echo -e "\n3. Files in directory:"
ls -la /workspace/data/

echo -e "\nDone!"
