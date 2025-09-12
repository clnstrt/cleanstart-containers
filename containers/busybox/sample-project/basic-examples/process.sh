#!/bin/sh

set -eu

echo "[Process] Listing processes (ps):"
ps

echo "[Process] Starting a background sleep job..."
sh -c 'sleep 2 & echo $! > /tmp/busybox_sample_pid'
PID=$(cat /tmp/busybox_sample_pid)
echo "[Process] Started background PID: $PID"

echo "[Process] Verifying the job is running:"
ps | grep " $PID " || true

echo "[Process] Waiting for job to finish..."
wait "$PID" 2>/dev/null || true

echo "[Process] Done."


