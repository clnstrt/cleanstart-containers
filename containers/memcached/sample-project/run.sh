#!/bin/bash

echo "Starting Memcached Demo Project"
echo "================================"

# Pull the latest image
echo "1. Pulling Memcached image..."
docker pull cleanstart/memcached:latest-dev

# Stop and remove existing container if it exists
echo "2. Cleaning up existing container..."
docker stop memcached-demo 2>/dev/null
docker rm memcached-demo 2>/dev/null

# Run Memcached container
echo "3. Starting Memcached container..."
docker run -d \
  --name memcached-demo \
  -p 11211:11211 \
  cleanstart/memcached:latest-dev \
  memcached -m 128 -p 11211 -u memcache -l 0.0.0.0 -vv

# Check if container is running
if [ $? -eq 0 ]; then
    echo "✓ Memcached container started successfully!"
    echo "  Container name: memcached-demo"
    echo "  Port: 11211"
    
    # Show container status
    echo ""
    echo "Container Status:"
    docker ps --filter name=memcached-demo
    
    # Install Python dependencies
    echo ""
    echo "4. Installing Python dependencies..."
    pip install -r requirements.txt
    
    echo ""
    echo "5. Starting Flask application..."
    echo "   Access the app at: http://localhost:5000"
    echo "   Press Ctrl+C to stop"
    echo ""
    
    # Run the Flask app
    python app.py
else
    echo "✗ Failed to start Memcached container"
    exit 1
fi