#!/bin/sh
echo "🚀 Cleanstart BusyBox started as user: $(whoami)"
echo "📦 BusyBox version: $(busybox | head -n 1)"

# Try different directories for web files
WEB_DIR=""
for dir in "/tmp/www" "/home/clnstrt/www" "./www" "/www"; do
  if mkdir -p "$dir" 2>/dev/null; then
    WEB_DIR="$dir"
    echo "✅ Created web directory: $WEB_DIR"
    break
  fi
done

if [ -z "$WEB_DIR" ]; then
  echo "⚠️  Could not create web directory, using current directory"
  WEB_DIR="."
fi

# Copy data.json to web directory (check multiple possible locations)
if [ -f /work/data.json ]; then
  cp /work/data.json "$WEB_DIR/"
  echo "✅ Copied data.json from /work"
elif [ -f ./data.json ]; then
  cp ./data.json "$WEB_DIR/"
  echo "✅ Copied data.json from current directory"
else
  echo "⚠️  data.json not found, creating a sample one"
  cat > "$WEB_DIR/data.json" << 'EOF'
{
  "status": "success",
  "message": "Hello from BusyBox HTTP server!",
  "timestamp": "2025-09-30T18:00:00Z",
  "data": {
    "id": 1,
    "name": "Cleanstart Project",
    "version": "1.0.0"
  }
}
EOF
fi

# Create a simple index.html
cat > "$WEB_DIR/index.html" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>CleanStart BusyBox HTTP Server</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        h1 { color: #2c3e50; }
        .container { max-width: 600px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Welcome to CleanStart BusyBox!</h1>
        <p>BusyBox HTTP server is running successfully.</p>
        <p>Available files:</p>
        <ul>
            <li><a href="/data.json">data.json</a></li>
            <li><a href="/index.html">index.html</a></li>
        </ul>
        <p><strong>Server Info:</strong></p>
        <ul>
            <li>User: clnstrt</li>
            <li>BusyBox Version: BusyBox v1.37.0</li>
        </ul>
    </div>
</body>
</html>
EOF

echo "🚀 Starting BusyBox HTTP server on port 8080..."
echo "📁 Serving files from $WEB_DIR directory"

# Check if httpd applet is available, if not use a simple HTTP server
if busybox httpd --help >/dev/null 2>&1; then
  echo "✅ Using BusyBox httpd applet"
  # Start HTTP server in background
  busybox httpd -f -v -p 8080 -h "$WEB_DIR" &
else
  echo "⚠️  httpd applet not available, using simple HTTP server"
  # Create a simple HTTP server using netcat
  {
    while true; do
      echo "HTTP/1.1 200 OK"
      echo "Content-Type: text/html"
      echo "Connection: close"
      echo ""
      cat "$WEB_DIR/index.html"
    done
  } | busybox nc -l -p 8080 &
fi

# Keep container running with heartbeat logs
while true; do
  echo "⏳ BusyBox HTTP server is running at http://localhost:8080 $(date)"
  sleep 10
done
