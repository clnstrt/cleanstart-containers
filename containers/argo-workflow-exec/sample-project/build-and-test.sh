#!/bin/bash

echo "🚀 Building and testing Argo Workflow Exec sample project"
echo "========================================================"

# Build the Docker image
echo "📦 Building Docker image..."
docker build -t argo-test .

if [ $? -eq 0 ]; then
    echo "✅ Docker image built successfully"
    echo ""
    echo "🧪 Running the container..."
    docker run --rm argo-test
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Test completed successfully!"
    else
        echo ""
        echo "❌ Test failed"
        exit 1
    fi
else
    echo "❌ Docker build failed"
    exit 1
fi

echo ""
echo "🎉 All tests passed! The argo-workflow-exec sample project is working correctly."
