#!/bin/sh
echo "🚀 Cleanstart BusyBox started as user: $(whoami)"
echo "📦 BusyBox version: $(busybox | head -n 1)"

# heartbeat logs every 5 sec
while true; do
  echo "⏳ Busybox is a combination of UNIX utilities and is a single binary! $(date)"
  sleep 5
done
