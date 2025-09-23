#!/bin/sh

echo "============================================================"
echo "🔐 Step CLI - Hello World (Shell Version)"
echo "============================================================"
echo "Timestamp: $(date)"
echo "Shell: $SHELL"
echo "Working Directory: $(pwd)"
echo "============================================================"

echo ""
echo "🔍 Checking Environment..."
if [ -f /.dockerenv ]; then
    echo "✅ Running in Docker container"
else
    echo "⚠️  Not running in Docker container"
fi

echo "✅ Shell Version: $SHELL"
echo "✅ Working Directory: $(pwd)"

echo ""
echo "🧪 Testing Step CLI..."
if command -v /step >/dev/null 2>&1; then
    echo "✅ Step CLI is available"
    echo "   Version: $(/step version)"
else
    echo "❌ Step CLI not available"
fi

echo ""
echo "🧪 Testing Step CA..."
if /step ca version >/dev/null 2>&1; then
    echo "✅ Step CA is available"
    echo "   Version: $(/step ca version)"
else
    echo "⚠️  Step CA not available"
fi

echo ""
echo "🧪 Testing Certificate Generation..."
if /step certificate create test-cert /tmp/test.crt /tmp/test.key --template '{"subject":{"commonName":"test.example.com"}}' >/dev/null 2>&1; then
    echo "✅ Certificate generation test passed"
    rm -f /tmp/test.crt /tmp/test.key
else
    echo "⚠️  Certificate generation test failed (expected in container)"
fi

echo ""
echo "============================================================"
echo "🎉 Step CLI Hello World completed!"
echo "============================================================"
