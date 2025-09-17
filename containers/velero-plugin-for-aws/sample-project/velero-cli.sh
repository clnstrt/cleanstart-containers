#!/bin/bash

# Velero CLI Wrapper Script
# This script makes it easy to use the included Velero CLI binary

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Path to the included Velero binary
VELERO_BIN="$SCRIPT_DIR/velero-v1.11.0-linux-amd64/velero"

# Check if Velero binary exists
if [ ! -f "$VELERO_BIN" ]; then
    echo "Error: Velero binary not found at $VELERO_BIN"
    echo "Please ensure you're running this from the sample-project directory"
    exit 1
fi

# Make sure the binary is executable
chmod +x "$VELERO_BIN" 2>/dev/null

# Pass all arguments to the Velero binary
"$VELERO_BIN" "$@"
