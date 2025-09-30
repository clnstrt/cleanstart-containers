<<<<<<< HEAD
# print("Cortex for Prometheus\n\nThis is a CNCF Cloud Native Computing Foundation project that provides horizontally scalable, highly available, and multi-tenant long-term storage for Prometheus monitoring data.")
import http.server
import socketserver
import json

PORT = 8080

class JSONHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/":
            self.send_response(200)
            self.send_header("Content-type", "application/json")
            self.end_headers()
            with open("data.json") as f:
                data = f.read()
            self.wfile.write(data.encode())
        else:
            self.send_error(404, "File not found")

if __name__ == "__main__":
    with socketserver.TCPServer(("", PORT), JSONHandler) as httpd:
        print(f"Serving JSON at http://0.0.0.0:{PORT}")
        httpd.serve_forever()

=======
print("Cortex for Prometheus\n\nThis is a CNCF Cloud Native Computing Foundation project that provides horizontally scalable, highly available, and multi-tenant long-term storage for Prometheus monitoring data.")
import http.server
import socketserver
import json

PORT = 8080

class JSONHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/":
            self.send_response(200)
            self.send_header("Content-type", "application/json")
            self.end_headers()
            with open("data.json") as f:
                data = f.read()
            self.wfile.write(data.encode())
        else:
            self.send_error(404, "File not found")

if __name__ == "__main__":
    with socketserver.TCPServer(("", PORT), JSONHandler) as httpd:
        print(f"Serving JSON at http://0.0.0.0:{PORT}")
        httpd.serve_forever()

>>>>>>> b24d9df4bb837add6d9657256fdfea46c1591f84
