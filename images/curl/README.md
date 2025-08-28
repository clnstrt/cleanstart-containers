# 🌐 Curl Docker Image

A lightweight Docker image for HTTP/HTTPS requests, API testing, and web scraping using curl with additional tools for data processing and automation.

## 📚 What is Curl?

**Curl** is a command-line tool for transferring data with URLs. It supports various protocols including HTTP, HTTPS, FTP, and more. This image provides:

- **HTTP/HTTPS Requests** - GET, POST, PUT, DELETE operations
- **API Testing** - RESTful API testing and validation
- **File Downloads** - Efficient file downloading and uploads
- **SSL/TLS Support** - Secure connections with certificate handling
- **Data Processing** - JSON parsing with jq integration
- **Automation** - Scriptable HTTP operations

## 🎯 What This Image Provides

### **Core Tools**
- **curl** - HTTP client for data transfer
- **wget** - Alternative file downloader
- **jq** - JSON processor for API responses
- **bash** - Shell environment for scripting

### **Additional Tools**
- **git** - Version control for scripts
- **openssl** - SSL/TLS certificate handling
- **ca-certificates** - Trusted CA certificates

## 🚀 Quick Start

### Pull the Image
```bash
docker pull cleanstart/curl:latest
```

### Run Interactive Shell
```bash
docker run -it --rm cleanstart/curl:latest
```

### Run Hello World Script
```bash
docker run --rm cleanstart/curl:latest bash hello_world.sh
```

### Run with Volume Mount
```bash
docker run -it --rm -v $(pwd):/workspace cleanstart/curl:latest
```

## 💻 Basic Usage Examples

### 1. Simple HTTP Request
```bash
docker run --rm cleanstart/curl:latest curl https://httpbin.org/get
```

### 2. API Testing with JSON
```bash
docker run --rm cleanstart/curl:latest \
  curl -X POST https://httpbin.org/post \
  -H "Content-Type: application/json" \
  -d '{"key": "value"}' | jq .
```

### 3. File Download
```bash
docker run --rm -v $(pwd):/workspace cleanstart/curl:latest \
  curl -o /workspace/file.txt https://example.com/file.txt
```

### 4. SSL Certificate Check
```bash
docker run --rm cleanstart/curl:latest \
  curl -I https://google.com
```

## 🔧 Advanced Usage

### 1. API Testing Script
```bash
# Start container with script
docker run -it --rm \
  -v $(pwd):/workspace \
  cleanstart/curl:latest

# Inside container
curl -X GET https://api.example.com/users \
  -H "Authorization: Bearer token" \
  | jq '.data[] | {id, name, email}'
```

### 2. Batch File Processing
```bash
# Download multiple files
for url in $(cat urls.txt); do
  curl -O "$url"
done
```

### 3. API Monitoring
```bash
# Monitor API health
while true; do
  curl -s -o /dev/null -w "%{http_code}" https://api.example.com/health
  sleep 30
done
```

## 📁 Sample Projects

### Basic Examples
- **HTTP Requests** - GET, POST, PUT, DELETE operations
- **API Testing** - RESTful API validation
- **File Operations** - Download and upload files
- **SSL/TLS Testing** - Certificate validation

### Advanced Examples
- **API Automation** - Automated API testing scripts
- **Web Scraping** - Data extraction from websites
- **Load Testing** - Simple load testing with curl
- **Monitoring** - Health check and monitoring scripts

## 🔒 Security Features

- **Non-root User** - Runs as `curluser` (UID 1001)
- **Minimal Base Image** - Alpine Linux for reduced attack surface
- **Certificate Validation** - Proper CA certificates for secure connections
- **SSL/TLS Support** - Full SSL/TLS protocol support

## 🌐 Integration Examples

### Kubernetes Integration
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: curl-client
spec:
  containers:
  - name: curl
    image: cleanstart/curl:latest
    command: ["curl", "-X", "GET", "https://api.example.com/health"]
    env:
    - name: API_TOKEN
      valueFrom:
        secretKeyRef:
          name: api-secret
          key: token
```

### Docker Compose
```yaml
version: '3.8'
services:
  curl-client:
    image: cleanstart/curl:latest
    container_name: curl-client
    volumes:
      - ./scripts:/workspace/scripts
      - ./data:/workspace/data
    environment:
      - API_URL=https://api.example.com
    command: ["tail", "-f", "/dev/null"]
```

## 🧪 Testing

### Verify Installation
```bash
# Test curl
docker run --rm cleanstart/curl:latest curl --version

# Test jq
docker run --rm cleanstart/curl:latest jq --version

# Test SSL
docker run --rm cleanstart/curl:latest curl -I https://google.com
```

### Run Sample API Test
```bash
# Test HTTPBin API
docker run --rm cleanstart/curl:latest \
  curl -s https://httpbin.org/json | jq .
```

## 📊 Monitoring & Debugging

### Request Debugging
```bash
# Verbose output
curl -v https://api.example.com

# Show timing information
curl -w "@curl-format.txt" https://api.example.com

# Follow redirects
curl -L https://api.example.com
```

### SSL Debugging
```bash
# Check SSL certificate
curl -I https://api.example.com

# Test SSL connection
openssl s_client -connect api.example.com:443
```

## 🔄 Version Information

- **curl**: v8.4.0
- **jq**: v1.7.1
- **Base Image**: Alpine Linux 3.18

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

For support and questions:
- **GitHub Issues**: Create an issue in the repository
- **Documentation**: Check the curl official docs
- **Community**: Join the curl community forums
