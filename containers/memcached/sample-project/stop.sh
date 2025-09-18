#!/bin/bash

echo "Stopping Memcached Demo Project"
echo "================================"

# Stop the container
echo "Stopping Memcached container..."
docker stop memcached-demo

# Remove the container
echo "Removing Memcached container..."
docker rm memcached-demo

echo "✓ Cleanup complete!"

# Show running containers
echo ""
echo "Currently running containers:"
docker ps