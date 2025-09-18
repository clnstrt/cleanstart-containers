#!/bin/sh

# This script is executed inside the container to install the extension

# Log a message to show the script is running
echo "Starting extension installation..."

# Create the directory for the extensions
mkdir -p /argocd-extensions

# Install any required dependencies (e.g., Python)
apk add --no-cache python3

# Place your extension files in the required directory
# The `argocd-extension-installer` base image expects extensions in `/argocd-extensions`
cp ./hello_world.py /argocd-extensions/hello_world.py

# Optional: Set permissions if needed
chmod +x /argocd-extensions/hello_world.py

echo "Extension 'hello_world' installed successfully!"