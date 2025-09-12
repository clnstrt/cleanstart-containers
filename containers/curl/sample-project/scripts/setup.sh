#!/bin/bash

echo "🚀 Setting up Curl Sample Project Environment"
echo "============================================="

# Check if curl is available
if ! command -v curl &> /dev/null; then
    echo "❌ Error: curl is not installed"
    exit 1
fi

# Check if jq is available
if ! command -v jq &> /dev/null; then
    echo "❌ Error: jq is not installed"
    exit 1
fi

# Check if Docker image is available
if ! docker images | grep -q "cleanstart/curl"; then
    echo "📥 Pulling cleanstart/curl:latest..."
    docker pull cleanstart/curl:latest
fi

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p /workspace/data
mkdir -p /workspace/data/scraped
mkdir -p /workspace/logs

# Make scripts executable
echo "🔧 Making scripts executable..."
chmod +x /workspace/basic-examples/*.sh
chmod +x /workspace/advanced-examples/*.sh
chmod +x /workspace/scripts/*.sh

# Test basic functionality
echo "🧪 Testing basic functionality..."
curl --version
jq --version

# Test internet connectivity
echo "🌐 Testing internet connectivity..."
if curl -s --max-time 5 https://httpbin.org/get > /dev/null; then
    echo "✅ Internet connectivity: OK"
else
    echo "⚠️  Internet connectivity: Limited"
fi

echo "✅ Setup completed successfully!"
echo ""
echo "📋 Available examples:"
echo "  basic-examples/http-requests.sh"
echo "  basic-examples/file-operations.sh"
echo "  basic-examples/ssl-testing.sh"
echo "  advanced-examples/api-automation.sh"
echo "  advanced-examples/web-scraping.sh"
echo "  advanced-examples/load-testing.sh"
