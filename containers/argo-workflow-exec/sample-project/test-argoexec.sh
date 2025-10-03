#!/bin/bash

echo "🚀 Testing argoexec..."
echo "Script is running..."

# Display environment info
echo "Current user: $(whoami)"
echo "Current directory: $(pwd)"
echo "PATH: $PATH"
echo ""

# Test if argoexec exists and run it
if command -v argoexec >/dev/null 2>&1; then
    echo "✅ argoexec found in PATH"
    echo "Running argoexec --help:"
    echo "----------------------------------------"
    argoexec --help
    echo "----------------------------------------"
    
    # Test version command
    echo ""
    echo "Testing argoexec version:"
    argoexec version
    
else
    echo "❌ argoexec not found in PATH"
    echo ""
    echo "Searching for argoexec in common locations..."
    
    # Search in common locations
    for dir in /usr/local/bin /usr/bin /bin /opt/argo/bin; do
        if [ -f "$dir/argoexec" ]; then
            echo "✅ Found argoexec at: $dir/argoexec"
            echo "Testing:"
            "$dir/argoexec" --help
            break
        fi
    done
    
    # If still not found, try find command
    echo ""
    echo "Searching entire filesystem for argoexec..."
    find /usr -name "argoexec" 2>/dev/null | head -5
    
    # Check if it's in the current directory or subdirectories
    if [ -f "./argoexec" ]; then
        echo "✅ Found argoexec in current directory"
        ./argoexec --help
    fi
fi

echo ""
echo "🔍 Additional system information:"
echo "Operating System: $(uname -a)"
echo "Available disk space:"
df -h / 2>/dev/null || echo "Could not check disk space"
echo ""
echo "Test completed."