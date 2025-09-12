#!/bin/sh

set -eu

echo "[Filesystem] Working directory: $(pwd)"
TMPDIR=${TMPDIR:-/tmp}/busybox-sample
echo "[Filesystem] Using temp dir: $TMPDIR"
echo "[Filesystem] Creating example directory and files..."
mkdir -p "$TMPDIR"
echo "hello world" > "$TMPDIR/hello.txt"
echo "another line" >> "$TMPDIR/hello.txt"
echo "foo bar" > "$TMPDIR/data.txt"

echo "[Filesystem] Listing $TMPDIR:"
ls -la "$TMPDIR"

echo "[Filesystem] Searching for 'hello' in hello.txt:"
grep -n "hello" "$TMPDIR/hello.txt" || true

echo "[Filesystem] Showing file sizes:"
du -sh "$TMPDIR"/* 2>/dev/null || true

echo "[Filesystem] Cleanup"
rm -rf "$TMPDIR"
echo "[Filesystem] Done."


