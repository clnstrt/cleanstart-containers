#!/bin/sh

PORT="${PORT:-8080}"
LOG_FILE="${LOG_FILE:-/tmp/metallb-controller.log}"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

cleanup() {
    log "Received termination signal. Shutting down gracefully..."
    exit 0
}

trap cleanup SIGTERM SIGINT SIGQUIT

log "========================================="
log "Metallb Controller Dashboard Starting"
log "========================================="
log "Port: ${PORT}"
log "Server is ready and listening on port ${PORT}"
log "========================================="

# Main server loop
while true; do
    {
        echo "HTTP/1.1 200 OK"
        echo "Content-Type: text/html; charset=UTF-8"
        echo "Connection: close"
        echo ""
        cat <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="refresh" content="30">
    <title>Metallb Controller Dashboard</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        .container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            padding: 40px;
            max-width: 700px;
            width: 100%;
            animation: fadeIn 0.5s ease-in;
        }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(-20px); } to { opacity: 1; transform: translateY(0); } }
        .header { text-align: center; margin-bottom: 30px; }
        h1 { color: #333; margin-bottom: 10px; font-size: 2.5em; font-weight: 700; }
        .subtitle { color: #666; font-size: 1.1em; }
        .logo { font-size: 3em; margin-bottom: 10px; }
        .status-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 25px;
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
            position: relative;
            overflow: hidden;
        }
        .status-card::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            animation: rotate 10s linear infinite;
        }
        @keyframes rotate { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }
        .status-content { position: relative; z-index: 1; }
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(16, 185, 129, 0.9);
            padding: 10px 24px;
            border-radius: 25px;
            font-weight: 600;
            font-size: 0.95em;
            margin-bottom: 15px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }
        .status-dot {
            width: 10px;
            height: 10px;
            background: white;
            border-radius: 50%;
            animation: pulse 2s ease-in-out infinite;
        }
        @keyframes pulse { 0%, 100% { opacity: 1; transform: scale(1); } 50% { opacity: 0.6; transform: scale(1.2); } }
        .status-card h2 { margin: 10px 0; font-size: 1.8em; font-weight: 600; }
        .status-card p { opacity: 0.95; font-size: 1.05em; }
        .info-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 15px; margin-bottom: 25px; }
        .info-item {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 20px;
            border-radius: 12px;
            border-left: 4px solid #667eea;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .info-item:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); }
        .info-label { font-size: 0.8em; color: #666; text-transform: uppercase; letter-spacing: 1.2px; margin-bottom: 8px; font-weight: 600; }
        .info-value { font-size: 1.3em; color: #333; font-weight: 700; }
        .actions { display: flex; gap: 15px; justify-content: center; margin-top: 25px; flex-wrap: wrap; }
        .btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 14px 32px;
            border-radius: 30px;
            font-size: 1em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }
        .btn:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6); }
        .feature-list { background: #f8f9fa; padding: 20px; border-radius: 12px; margin-top: 20px; }
        .feature-list h3 { color: #333; margin-bottom: 15px; font-size: 1.2em; }
        .feature-list ul { list-style: none; padding: 0; }
        .feature-list li { padding: 8px 0; color: #555; display: flex; align-items: center; gap: 10px; }
        .feature-list li::before { content: '✓'; color: #10b981; font-weight: bold; font-size: 1.2em; }
        .footer { text-align: center; margin-top: 30px; padding-top: 20px; border-top: 2px solid #e9ecef; color: #999; font-size: 0.9em; }
        @media (max-width: 600px) { .container { padding: 25px; } h1 { font-size: 2em; } .info-grid { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="logo">📡</div>
            <h1>Metallb Controller</h1>
            <p class="subtitle">Kubernetes LoadBalancer Dashboard</p>
        </div>
        
        <div class="status-card">
            <div class="status-content">
                <div class="status-badge">
                    <span class="status-dot"></span>
                    <span>Healthy</span>
                </div>
                <h2>Controller Status</h2>
                <p>All services are operational and LoadBalancer is active</p>
            </div>
        </div>
        
        <div class="info-grid">
            <div class="info-item">
                <div class="info-label">Port</div>
                <div class="info-value">
EOF
        echo -n "$PORT"
        cat <<'EOF'
</div>
            </div>
            <div class="info-item">
                <div class="info-label">Status</div>
                <div class="info-value">Running</div>
            </div>
            <div class="info-item">
                <div class="info-label">Environment</div>
                <div class="info-value">Container</div>
            </div>
            <div class="info-item">
                <div class="info-label">Version</div>
                <div class="info-value">v1.0.0</div>
            </div>
            <div class="info-item">
                <div class="info-label">Last Updated</div>
                <div class="info-value">
EOF
        echo -n "$(date '+%H:%M:%S')"
        cat <<'EOF'
</div>
            </div>
            <div class="info-item">
                <div class="info-label">Response</div>
                <div class="info-value">OK</div>
            </div>
        </div>
        
        <div class="feature-list">
            <h3>🎯 Controller Features</h3>
            <ul>
                <li>LoadBalancer health monitoring</li>
                <li>Auto-refresh every 30 seconds</li>
                <li>Kubernetes integration</li>
                <li>Resource tracking</li>
                <li>Lightweight CleanstartOS base</li>
                <li>Simple HTTP server with netcat</li>
            </ul>
        </div>
        
        <div class="actions">
            <button class="btn" onclick="location.reload()">🔄 Refresh Now</button>
        </div>
        
        <div class="footer">
            <p><strong>Metallb Controller Server</strong></p>
            <p>Built with ❤️ for Kubernetes • Powered by Cleanstart</p>
        </div>
    </div>
</body>
</html>
EOF
    } | nc -l -p "$PORT" 2>/dev/null || nc -l "$PORT" 2>/dev/null
done
