#!/bin/bash

# Simple script to check if argoexec is functional.

# Check for the argoexec binary in common locations
if [ -f "/usr/local/bin/argoexec" ]; then
    ARGOEXEC_PATH="/usr/local/bin/argoexec"
elif [ -f "/usr/bin/argoexec" ]; then
    ARGOEXEC_PATH="/usr/bin/argoexec"
else
    echo "❌ Failure: argoexec binary not found in expected locations."
    exit 1
fi

echo "Found argoexec at $ARGOEXEC_PATH."
echo "Running basic test..."

# Run the argoexec --help command to verify functionality
"$ARGOEXEC_PATH" --help