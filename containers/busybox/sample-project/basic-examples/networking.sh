#!/bin/sh

set -eu

TARGET=${1:-https://cleanstart.com}

echo "[Networking] Pinging $TARGET ..."
if ping -c 1 "$TARGET" >/dev/null 2>&1; then
  echo "[Networking] Ping succeeded"
fi

URL=${2:-https://cleanstart.com}
echo "[Networking] Fetching $URL with wget ..."
if wget -qO- "$URL" | head -n 3; then
  echo "[Networking] wget succeeded"
else
  echo "[Networking] wget failed (may be unavailable in this BusyBox tag)"
fi

echo "[Networking] Done."


