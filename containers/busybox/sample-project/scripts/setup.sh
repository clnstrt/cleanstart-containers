#!/bin/sh

set -eu

echo "[Setup] Making example scripts executable..."
chmod +x ./basic-examples/*.sh 2>/dev/null || true

echo "[Setup] Done."


