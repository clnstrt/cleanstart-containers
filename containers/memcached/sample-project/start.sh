#!/bin/bash

# Start Memcached in the background
echo "Starting Memcached..."
memcached -m 128 -p 11211 -u memcache -l 0.0.0.0 -vv &

# Wait for Memcached to be ready
echo "Waiting for Memcached to start..."
sleep 3

# Start the Flask application (your existing app.py)
echo "Starting Memcached Demo Application..."
python3 app.py
