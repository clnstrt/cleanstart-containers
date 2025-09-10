#!/usr/bin/env python3
"""
Prometheus Hello World Example
This script demonstrates basic Prometheus metrics collection and monitoring.
"""

import time
import random
import requests
from prometheus_client import start_http_server, Counter, Histogram, Gauge, generate_latest, CONTENT_TYPE_LATEST
from http.server import BaseHTTPRequestHandler, HTTPServer
import threading

# Prometheus metrics
REQUEST_COUNT = Counter('hello_world_requests_total', 'Total number of hello world requests', ['method', 'endpoint'])
REQUEST_DURATION = Histogram('hello_world_request_duration_seconds', 'Request duration in seconds', ['method', 'endpoint'])
ACTIVE_CONNECTIONS = Gauge('hello_world_active_connections', 'Number of active connections')
RESPONSE_SIZE = Histogram('hello_world_response_size_bytes', 'Response size in bytes', ['method', 'endpoint'])

class HelloWorldHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        start_time = time.time()
        
        # Increment request counter
        REQUEST_COUNT.labels(method='GET', endpoint=self.path).inc()
        
        # Simulate some processing time
        time.sleep(random.uniform(0.1, 0.5))
        
        # Generate response
        if self.path == '/':
            response = "Hello, World! This is a Prometheus monitoring example."
        elif self.path == '/health':
            response = "OK"
        elif self.path == '/metrics':
            response = generate_latest()
            self.send_header('Content-Type', CONTENT_TYPE_LATEST)
        else:
            response = "Not Found"
            self.send_response(404)
            self.end_headers()
            self.wfile.write(response.encode())
            return
        
        # Record metrics
        duration = time.time() - start_time
        REQUEST_DURATION.labels(method='GET', endpoint=self.path).observe(duration)
        RESPONSE_SIZE.labels(method='GET', endpoint=self.path).observe(len(response))
        
        # Send response
        self.send_response(200)
        self.send_header('Content-Type', 'text/plain')
        self.end_headers()
        self.wfile.write(response.encode())
    
    def do_POST(self):
        start_time = time.time()
        
        # Increment request counter
        REQUEST_COUNT.labels(method='POST', endpoint=self.path).inc()
        
        # Simulate some processing time
        time.sleep(random.uniform(0.2, 1.0))
        
        # Generate response
        response = "POST request received"
        
        # Record metrics
        duration = time.time() - start_time
        REQUEST_DURATION.labels(method='POST', endpoint=self.path).observe(duration)
        RESPONSE_SIZE.labels(method='POST', endpoint=self.path).observe(len(response))
        
        # Send response
        self.send_response(200)
        self.send_header('Content-Type', 'text/plain')
        self.end_headers()
        self.wfile.write(response.encode())

def simulate_load():
    """Simulate some load to generate interesting metrics"""
    while True:
        try:
            # Simulate some API calls
            requests.get('http://localhost:8080/', timeout=1)
            requests.get('http://localhost:8080/health', timeout=1)
            
            # Occasionally make POST requests
            if random.random() < 0.3:
                requests.post('http://localhost:8080/api', timeout=1)
            
            time.sleep(random.uniform(1, 5))
        except requests.exceptions.RequestException:
            pass

def main():
    print("🚀 Starting Prometheus Hello World Example")
    print("=" * 50)
    
    # Start Prometheus metrics server
    start_http_server(8000)
    print("📊 Prometheus metrics server started on port 8000")
    
    # Start load simulation in background
    load_thread = threading.Thread(target=simulate_load, daemon=True)
    load_thread.start()
    print("🔄 Load simulation started")
    
    # Start HTTP server
    server = HTTPServer(('0.0.0.0', 8080), HelloWorldHandler)
    print("🌐 HTTP server started on port 8080")
    print("📝 Available endpoints:")
    print("   - http://localhost:8080/          - Hello World")
    print("   - http://localhost:8080/health     - Health check")
    print("   - http://localhost:8080/metrics    - Prometheus metrics")
    print("   - http://localhost:8000/metrics    - Prometheus metrics (direct)")
    print("=" * 50)
    
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\n🛑 Shutting down...")
        server.shutdown()

if __name__ == '__main__':
    main()
