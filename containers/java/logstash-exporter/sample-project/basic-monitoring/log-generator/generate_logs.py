#!/usr/bin/env python3
"""
Log Generator for Logstash Testing
Generates sample log data and sends it to Logstash via TCP
"""

import json
import random
import time
import socket
import argparse
from datetime import datetime
from flask import Flask, request, jsonify, render_template_string

app = Flask(__name__)

# Sample log messages
LOG_MESSAGES = {
    'info': [
        "User login successful",
        "Database connection established",
        "File uploaded successfully",
        "API request processed",
        "Cache updated",
        "Backup completed",
        "Service started",
        "Configuration loaded"
    ],
    'warning': [
        "High memory usage detected",
        "Slow database query",
        "Cache miss rate increasing",
        "Disk space running low",
        "Connection timeout",
        "Retry attempt failed",
        "Resource limit approaching"
    ],
    'error': [
        "Database connection failed",
        "Authentication error",
        "File not found",
        "Permission denied",
        "Network timeout",
        "Invalid input data",
        "Service unavailable"
    ]
}

def generate_log_entry(level='info', message=None):
    """Generate a single log entry"""
    if not message:
        message = random.choice(LOG_MESSAGES.get(level, LOG_MESSAGES['info']))
    
    return {
        'timestamp': datetime.now().isoformat(),
        'level': level,
        'message': message,
        'service': 'log-generator',
        'host': 'localhost',
        'pid': random.randint(1000, 9999),
        'request_id': f"req-{random.randint(10000, 99999)}"
    }

def send_to_logstash(log_entry, host='logstash', port=5000):
    """Send log entry to Logstash via TCP"""
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.connect((host, port))
            s.sendall((json.dumps(log_entry) + '\n').encode('utf-8'))
        return True
    except Exception as e:
        print(f"Failed to send to Logstash: {e}")
        return False

@app.route('/')
def index():
    """Main page with log generation interface"""
    html = """
    <!DOCTYPE html>
    <html>
    <head>
        <title>Log Generator</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 40px; }
            .container { max-width: 800px; margin: 0 auto; }
            .form-group { margin: 20px 0; }
            label { display: block; margin-bottom: 5px; font-weight: bold; }
            input, select, button { padding: 10px; margin: 5px; font-size: 16px; }
            button { background: #007cba; color: white; border: none; cursor: pointer; }
            button:hover { background: #005a87; }
            .status { margin: 20px 0; padding: 10px; border-radius: 5px; }
            .success { background: #d4edda; color: #155724; }
            .error { background: #f8d7da; color: #721c24; }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>📝 Log Generator for Logstash Testing</h1>
            <p>Generate sample log data to test your Logstash pipeline and monitoring setup.</p>
            
            <form id="logForm">
                <div class="form-group">
                    <label for="count">Number of Logs:</label>
                    <input type="number" id="count" name="count" value="10" min="1" max="1000">
                </div>
                
                <div class="form-group">
                    <label for="level">Log Level:</label>
                    <select id="level" name="level">
                        <option value="info">Info</option>
                        <option value="warning">Warning</option>
                        <option value="error">Error</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="message">Custom Message (optional):</label>
                    <input type="text" id="message" name="message" placeholder="Leave empty for random messages">
                </div>
                
                <button type="submit">Generate Logs</button>
            </form>
            
            <div id="status"></div>
            
            <h2>Quick Actions</h2>
            <button onclick="generateLogs(50, 'info')">Generate 50 Info Logs</button>
            <button onclick="generateLogs(20, 'warning')">Generate 20 Warning Logs</button>
            <button onclick="generateLogs(10, 'error')">Generate 10 Error Logs</button>
            
            <h2>Monitoring Links</h2>
            <p><a href="http://localhost:9198/metrics" target="_blank">📊 Logstash Exporter Metrics</a></p>
            <p><a href="http://localhost:9600/_node/stats" target="_blank">🔍 Logstash Node Stats</a></p>
            <p><a href="http://localhost:8081" target="_blank">🌐 Test Web App</a></p>
        </div>
        
        <script>
            document.getElementById('logForm').addEventListener('submit', function(e) {
                e.preventDefault();
                const count = document.getElementById('count').value;
                const level = document.getElementById('level').value;
                const message = document.getElementById('message').value;
                generateLogs(count, level, message);
            });
            
            async function generateLogs(count, level, message = '') {
                const status = document.getElementById('status');
                status.innerHTML = '<div class="status">Generating logs...</div>';
                
                try {
                    const response = await fetch('/generate', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/json'},
                        body: JSON.stringify({count: parseInt(count), level, message})
                    });
                    
                    const result = await response.json();
                    if (result.success) {
                        status.innerHTML = `<div class="status success">✅ ${result.message}</div>`;
                    } else {
                        status.innerHTML = `<div class="status error">❌ ${result.message}</div>`;
                    }
                } catch (error) {
                    status.innerHTML = `<div class="status error">❌ Error: ${error.message}</div>`;
                }
            }
        </script>
    </body>
    </html>
    """
    return html

@app.route('/health')
def health():
    """Health check endpoint"""
    return jsonify({'status': 'healthy', 'timestamp': datetime.now().isoformat()})

@app.route('/generate', methods=['POST'])
def generate_logs():
    """Generate and send logs to Logstash"""
    try:
        data = request.get_json()
        count = data.get('count', 10)
        level = data.get('level', 'info')
        custom_message = data.get('message', '')
        
        if count < 1 or count > 1000:
            return jsonify({'success': False, 'message': 'Count must be between 1 and 1000'})
        
        if level not in ['info', 'warning', 'error']:
            return jsonify({'success': False, 'message': 'Invalid log level'})
        
        success_count = 0
        for i in range(count):
            log_entry = generate_log_entry(level, custom_message if custom_message else None)
            if send_to_logstash(log_entry):
                success_count += 1
            time.sleep(0.01)  # Small delay to avoid overwhelming
        
        message = f"Generated {success_count}/{count} {level} logs successfully"
        return jsonify({'success': True, 'message': message, 'sent': success_count})
        
    except Exception as e:
        return jsonify({'success': False, 'message': f'Error: {str(e)}'})

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Log Generator for Logstash Testing')
    parser.add_argument('--count', type=int, default=10, help='Number of logs to generate')
    parser.add_argument('--level', choices=['info', 'warning', 'error'], default='info', help='Log level')
    parser.add_argument('--message', help='Custom message for all logs')
    parser.add_argument('--volume', choices=['low', 'medium', 'high'], help='Volume preset')
    
    args = parser.parse_args()
    
    if args.volume:
        if args.volume == 'low':
            args.count = 10
        elif args.volume == 'medium':
            args.count = 100
        elif args.volume == 'high':
            args.count = 1000
    
    print(f"Starting Log Generator on port 8080...")
    print(f"Generate {args.count} {args.level} logs: http://localhost:8080")
    print(f"Health check: http://localhost:8080/health")
    
    app.run(host='0.0.0.0', port=8080, debug=False)
