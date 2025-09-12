#!/bin/bash

echo "📁 File Operations Examples"
echo "==========================="

# Create data directory if it doesn't exist
mkdir -p /workspace/data

# Download a file
echo -e "\n1. Downloading a file:"
curl -s -o /workspace/data/sample.json https://httpbin.org/json
echo "Downloaded sample.json"

# Download with progress
echo -e "\n2. Downloading with progress:"
curl -# -o /workspace/data/large-file.txt https://httpbin.org/bytes/10000
echo "Downloaded large-file.txt"

# Upload a file (simulate)
echo -e "\n3. Creating a file to upload:"
echo '{"message": "Hello from curl container!"}' > /workspace/data/upload.json

# Upload file (using httpbin to simulate)
echo -e "\n4. Uploading file:"
curl -s -X POST https://httpbin.org/post \
  -F "file=@/workspace/data/upload.json" \
  -F "description=Test upload" | jq .

# Download multiple files
echo -e "\n5. Downloading multiple files:"
for i in {1..3}; do
  curl -s -o "/workspace/data/file$i.txt" "https://httpbin.org/bytes/100"
  echo "Downloaded file$i.txt"
done

# List downloaded files
echo -e "\n6. Downloaded files:"
ls -la /workspace/data/

echo -e "\n✅ File operations completed!"
