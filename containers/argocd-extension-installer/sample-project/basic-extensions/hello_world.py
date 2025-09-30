#!/usr/bin/env python3
from http.server import HTTPServer, BaseHTTPRequestHandler
import json

class SimpleHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        response = {
            "status": "success",
            "message": "Hello from ArgoCD Extension!",
            "path": self.path
        }
        
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        self.wfile.write(json.dumps(response, indent=2).encode())
    
    def log_message(self, format, *args):
        print(f"{self.address_string()} - {format%args}")

if __name__ == '__main__':
    port = 8080
    server = HTTPServer(('0.0.0.0', port), SimpleHandler)
    print(f"Server running on port {port}...")
    server.serve_forever()