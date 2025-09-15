#!/usr/bin/env python3
"""
Certificate Generator Service
A simple web service for generating test certificates
"""

from flask import Flask, request, jsonify, render_template_string
import subprocess
import os
import json
from datetime import datetime

app = Flask(__name__)

# HTML template for the web interface
HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>Certificate Generator</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 800px; margin: 0 auto; }
        .form-group { margin: 20px 0; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input, select, textarea { width: 100%; padding: 8px; margin-bottom: 10px; }
        button { background: #007cba; color: white; padding: 10px 20px; border: none; cursor: pointer; }
        button:hover { background: #005a87; }
        .result { margin: 20px 0; padding: 15px; background: #f0f0f0; border-radius: 5px; }
        .error { background: #ffebee; color: #c62828; }
        .success { background: #e8f5e8; color: #2e7d32; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔐 Certificate Generator</h1>
        <p>Generate test certificates using Step CLI</p>
        
        <form method="POST" action="/generate">
            <div class="form-group">
                <label for="common_name">Common Name:</label>
                <input type="text" id="common_name" name="common_name" value="test.example.com" required>
            </div>
            
            <div class="form-group">
                <label for="sans">Subject Alternative Names (comma-separated):</label>
                <input type="text" id="sans" name="sans" value="test.example.com,www.test.example.com">
            </div>
            
            <div class="form-group">
                <label for="cert_type">Certificate Type:</label>
                <select id="cert_type" name="cert_type">
                    <option value="server">Server Certificate</option>
                    <option value="client">Client Certificate</option>
                    <option value="self-signed">Self-Signed Certificate</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="key_type">Key Type:</label>
                <select id="key_type" name="key_type">
                    <option value="RSA">RSA</option>
                    <option value="EC">ECDSA</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="key_size">Key Size:</label>
                <select id="key_size" name="key_size">
                    <option value="2048">2048 bits</option>
                    <option value="4096">4096 bits</option>
                </select>
            </div>
            
            <button type="submit">Generate Certificate</button>
        </form>
        
        <div class="form-group">
            <h3>Quick Actions</h3>
            <button onclick="generateQuick('localhost')">Generate localhost cert</button>
            <button onclick="generateQuick('example.com')">Generate example.com cert</button>
            <button onclick="listCertificates()">List Certificates</button>
        </div>
        
        <div id="result"></div>
    </div>
    
    <script>
        function generateQuick(domain) {
            document.getElementById('common_name').value = domain;
            document.getElementById('sans').value = domain + ',www.' + domain;
            document.querySelector('form').submit();
        }
        
        function listCertificates() {
            fetch('/list')
                .then(response => response.json())
                .then(data => {
                    document.getElementById('result').innerHTML = 
                        '<div class="result"><h3>Generated Certificates:</h3><pre>' + 
                        JSON.stringify(data, null, 2) + '</pre></div>';
                });
        }
    </script>
</body>
</html>
"""

@app.route('/')
def index():
    return render_template_string(HTML_TEMPLATE)

@app.route('/health')
def health():
    return jsonify({"status": "healthy", "timestamp": datetime.now().isoformat()})

@app.route('/generate', methods=['GET', 'POST'])
def generate_certificate():
    try:
        if request.method == 'POST':
            data = request.form
        else:
            data = request.args
            
        common_name = data.get('common_name', 'test.example.com')
        sans = data.get('sans', '')
        cert_type = data.get('cert_type', 'server')
        key_type = data.get('key_type', 'RSA')
        key_size = data.get('key_size', '2048')
        
        # Build Step CLI command
        cmd = ['step', 'certificate', 'create']
        
        # Add SANs if provided
        if sans:
            for san in sans.split(','):
                san = san.strip()
                if san:
                    cmd.extend(['--san', san])
        
        # Add certificate type
        if cert_type == 'client':
            cmd.extend(['--profile', 'client'])
        elif cert_type == 'self-signed':
            cmd.extend(['--self-signed', '--no-password', '--insecure'])
        
        # Add key type and size
        if key_type == 'EC':
            cmd.extend(['--kty', 'EC', '--curve', 'P-256'])
        else:
            cmd.extend(['--kty', 'RSA', '--size', key_size])
        
        # Add output files
        cert_file = f"/app/certs/{common_name}.crt"
        key_file = f"/app/certs/{common_name}.key"
        cmd.extend([common_name, cert_file, key_file])
        
        # Execute command
        result = subprocess.run(cmd, capture_output=True, text=True, cwd='/app')
        
        if result.returncode == 0:
            # Get certificate info
            info_cmd = ['step', 'certificate', 'inspect', cert_file]
            info_result = subprocess.run(info_cmd, capture_output=True, text=True, cwd='/app')
            
            response_data = {
                "status": "success",
                "message": f"Certificate generated successfully for {common_name}",
                "certificate_file": cert_file,
                "key_file": key_file,
                "command": " ".join(cmd),
                "certificate_info": info_result.stdout if info_result.returncode == 0 else "Could not retrieve certificate info"
            }
            
            if request.method == 'POST':
                return render_template_string(HTML_TEMPLATE + 
                    '<div class="result success"><h3>Success!</h3><pre>' + 
                    json.dumps(response_data, indent=2) + '</pre></div>')
            else:
                return jsonify(response_data)
        else:
            error_data = {
                "status": "error",
                "message": f"Failed to generate certificate: {result.stderr}",
                "command": " ".join(cmd),
                "stdout": result.stdout,
                "stderr": result.stderr
            }
            
            if request.method == 'POST':
                return render_template_string(HTML_TEMPLATE + 
                    '<div class="result error"><h3>Error!</h3><pre>' + 
                    json.dumps(error_data, indent=2) + '</pre></div>')
            else:
                return jsonify(error_data), 400
                
    except Exception as e:
        error_data = {
            "status": "error",
            "message": f"Exception occurred: {str(e)}"
        }
        
        if request.method == 'POST':
            return render_template_string(HTML_TEMPLATE + 
                '<div class="result error"><h3>Exception!</h3><pre>' + 
                json.dumps(error_data, indent=2) + '</pre></div>')
        else:
            return jsonify(error_data), 500

@app.route('/list')
def list_certificates():
    try:
        # List certificates in the certs directory
        cert_files = []
        if os.path.exists('/app/certs'):
            for file in os.listdir('/app/certs'):
                if file.endswith('.crt'):
                    cert_path = os.path.join('/app/certs', file)
                    key_path = os.path.join('/app/certs', file.replace('.crt', '.key'))
                    
                    # Get certificate info
                    info_cmd = ['step', 'certificate', 'inspect', cert_path]
                    info_result = subprocess.run(info_cmd, capture_output=True, text=True, cwd='/app')
                    
                    cert_files.append({
                        "certificate_file": cert_path,
                        "key_file": key_path if os.path.exists(key_path) else None,
                        "info": info_result.stdout if info_result.returncode == 0 else "Could not retrieve info"
                    })
        
        return jsonify({
            "status": "success",
            "certificates": cert_files,
            "count": len(cert_files)
        })
        
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": f"Exception occurred: {str(e)}"
        }), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)
