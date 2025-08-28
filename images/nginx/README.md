# Nginx Docker Image

A lightweight and high-performance web server, reverse proxy, and load balancer based on Nginx.

## 🚀 Quick Start

### Option 1: Using Pre-built Image from Docker Hub
```bash
# Pull the image from Docker Hub
docker pull cleanstart/nginx:latest

# Run the container
docker run -d -p 8080:80 --name nginx-container cleanstart/nginx:latest

# Access the application
open http://localhost:8080
```

### Option 2: Build Locally
```bash
# Build the image locally
docker build -t nginx-hello .

# Run the container
docker run -d -p 8080:80 --name nginx-container nginx-hello

# Access the application
open http://localhost:8080
```

### Using Docker Compose
```yaml
version: '3.8'
services:
  nginx:
    image: cleanstart/nginx:latest  # Use pre-built image
    # OR build locally:
    # build: .
    ports:
      - "8080:80"
    restart: unless-stopped
```

## 📋 Prerequisites

- Docker installed on your system
- Basic understanding of web servers and HTTP

## 🛠️ Installation & Setup

### Method 1: Using Pre-built Image (Recommended for Quick Start)

1. **Ensure Docker is installed and running**
   ```bash
   docker --version
   ```

2. **Pull the image from Docker Hub**
   ```bash
   docker pull cleanstart/nginx:latest
   ```

3. **Run the container**
   ```bash
   docker run -d -p 8080:80 --name nginx-container cleanstart/nginx:latest
   ```

4. **Verify the container is running**
   ```bash
   docker ps
   ```

5. **Access the application**
   - Open your browser and go to: `http://localhost:8080`
   - Or use curl: `curl http://localhost:8080`

### Method 2: Build and Run Locally

1. **Clone or download this repository**
   ```bash
   git clone <repository-url>
   cd cleanstart-containers
   ```

2. **Navigate to the nginx directory**
   ```bash
   cd images/nginx
   ```

3. **Build the Docker image locally**
   ```bash
   docker build -t nginx-hello .
   ```

4. **Run the container**
   ```bash
   docker run -d -p 8080:80 --name nginx-container nginx-hello
   ```

5. **Access the application**
   - Open your browser and go to: `http://localhost:8080`
   - Or use curl: `curl http://localhost:8080`

### Method 3: Using Sample Projects

1. **Navigate to sample projects**
   ```bash
   cd images/nginx/sample-project
   ```

2. **Choose an example to test:**
   - **Static Site:** `cd static-site`
   - **Reverse Proxy:** `cd reverse-proxy`
   - **Load Balancer:** `cd load-balancer`

3. **Build and run the example**
   ```bash
   # For static site
   docker build -t nginx-static-demo .
   docker run -d -p 8081:80 --name nginx-static-test nginx-static-demo
   
   # For reverse proxy
   docker-compose up -d
   
   # For load balancer
   docker-compose up -d
   ```

4. **Access the applications**
   - Static Site: `http://localhost:8081`
   - Reverse Proxy: `http://localhost:8082`
   - Load Balancer: `http://localhost:8083`

## 🧪 Testing & Verification

### Quick Test Commands
```bash
# Test if container is running
docker ps | grep nginx

# Test web server response
curl -I http://localhost:8080

# Check container logs
docker logs nginx-container

# Test health check
docker exec nginx-container curl -f http://localhost/health
```

### Expected Results
- **HTTP Status:** 200 OK
- **Content-Type:** text/html
- **Server:** nginx
- **Response:** HTML content with "Nginx Hello World!" page

### Troubleshooting Common Issues

**Port already in use:**
```bash
# Check what's using the port
netstat -tulpn | grep :8080

# Use a different port
docker run -d -p 8081:80 --name nginx-container cleanstart/nginx:latest
```

**Container won't start:**
```bash
# Check container logs
docker logs nginx-container

# Remove and recreate container
docker rm nginx-container
docker run -d -p 8080:80 --name nginx-container cleanstart/nginx:latest
```

**Permission issues:**
```bash
# Run with proper permissions
docker run -d -p 8080:80 --name nginx-container --user root cleanstart/nginx:latest
```

## 🎯 What You'll Learn

- **Web Server Basics**: Understanding how web servers work
- **Static File Serving**: Serving HTML, CSS, JavaScript, and other static files
- **Reverse Proxy**: Proxying requests to backend services
- **Load Balancing**: Distributing traffic across multiple servers
- **Performance Optimization**: Caching, compression, and security headers
- **Docker Best Practices**: Multi-stage builds, security, and health checks

## 🔧 Key Features

### Core Functionality
- **Static File Serving**: Serve HTML, CSS, JavaScript, images, and other static assets
- **Reverse Proxy**: Forward requests to backend applications
- **Load Balancing**: Distribute traffic across multiple backend servers
- **HTTP/2 Support**: Modern protocol for better performance
- **Gzip Compression**: Reduce bandwidth usage and improve load times

### Security Features
- **Non-root User**: Runs as a non-privileged user for security
- **Security Headers**: Built-in protection against common web vulnerabilities
- **Rate Limiting**: Protect against abuse and DDoS attacks
- **SSL/TLS Support**: Secure HTTPS connections

### Performance Features
- **High Performance**: Designed for high concurrency and low memory usage
- **Caching**: Built-in caching mechanisms for static content
- **Connection Pooling**: Efficient handling of multiple connections
- **Event-driven Architecture**: Non-blocking I/O operations

## 📁 Project Structure

```
images/nginx/
├── Dockerfile              # Main Dockerfile for basic nginx setup
├── hello_world.html        # Simple HTML page demonstrating nginx
├── README.md              # This file
└── sample-project/        # Advanced examples and tutorials
    ├── static-site/       # Static website example
    │   ├── index.html     # Modern responsive website
    │   ├── css/           # Custom stylesheets
    │   ├── js/            # JavaScript functionality
    │   ├── nginx.conf     # Nginx configuration
    │   └── Dockerfile     # Multi-stage build
    ├── reverse-proxy/     # Reverse proxy configuration
    │   ├── nginx.conf     # Proxy configuration
    │   ├── docker-compose.yml
    │   ├── backend/       # Flask API backend
    │   └── frontend/      # Static frontend
    ├── load-balancer/     # Load balancing example
    │   ├── nginx.conf     # Load balancer config
    │   ├── docker-compose.yml
    │   ├── backend1/      # Backend server 1
    │   ├── backend2/      # Backend server 2
    │   └── backend3/      # Backend server 3
    ├── setup.sh          # Linux/macOS setup script
    └── setup.bat         # Windows setup script
```

## 🐳 Docker Hub Integration

### Available Images
- **`cleanstart/nginx:latest`** - Latest stable version
- **`cleanstart/nginx:1.24`** - Specific version tag

### Pull and Run Commands
```bash
# Pull the latest image
docker pull cleanstart/nginx:latest

# Run with default settings
docker run -d -p 8080:80 --name nginx-container cleanstart/nginx:latest

# Run with custom port
docker run -d -p 3000:80 --name nginx-container cleanstart/nginx:latest

# Run with volume mount for custom content
docker run -d -p 8080:80 -v /path/to/html:/usr/share/nginx/html --name nginx-container cleanstart/nginx:latest
```

### Docker Compose Example
```yaml
version: '3.8'
services:
  nginx:
    image: cleanstart/nginx:latest
    ports:
      - "8080:80"
    volumes:
      - ./custom-html:/usr/share/nginx/html
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/health"]
      interval: 30s
      timeout: 10s
      retries: 3
```

## 🎓 Learning Path

### Beginner Level
1. **Start with the basic setup** - Build and run the hello world example
2. **Explore the HTML file** - Understand how nginx serves static content
3. **Modify the content** - Try changing the HTML and rebuilding

### Intermediate Level
1. **Static Site Example** - Learn about serving static websites
2. **Custom Configuration** - Understand nginx configuration files
3. **Performance Tuning** - Explore caching and compression settings

### Advanced Level
1. **Reverse Proxy** - Set up nginx as a reverse proxy
2. **Load Balancing** - Configure load balancing across multiple servers
3. **SSL/TLS Setup** - Implement HTTPS with certificates
4. **Custom Modules** - Extend nginx with custom functionality

## 🚀 Sample Project Setup

### Using Setup Scripts

**For Linux/macOS:**
```bash
cd images/nginx/sample-project
chmod +x setup.sh
./setup.sh
```

**For Windows:**
```cmd
cd images\nginx\sample-project
setup.bat
```

### Manual Setup for Each Example

**1. Static Site Example:**
```bash
cd images/nginx/sample-project/static-site
docker build -t nginx-static-demo .
docker run -d -p 8081:80 --name nginx-static-test nginx-static-demo
# Access at: http://localhost:8081
```

**2. Reverse Proxy Example:**
```bash
cd images/nginx/sample-project/reverse-proxy
docker-compose up -d
# Access at: http://localhost:8082
```

**3. Load Balancer Example:**
```bash
cd images/nginx/sample-project/load-balancer
docker-compose up -d
# Access at: http://localhost:8083
```

### Sample Project Features

- **Static Site:** Modern responsive website with Bootstrap 5, custom CSS, and JavaScript
- **Reverse Proxy:** Nginx proxying requests to Flask backend API
- **Load Balancer:** Nginx distributing traffic across 3 backend servers
- **Health Checks:** Built-in health monitoring for all services
- **Security:** Non-root users, security headers, and best practices

## 🔍 Comparison with Other Web Servers

| Feature | Nginx | Apache | Caddy |
|---------|-------|--------|-------|
| Performance | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| Configuration | ⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐⭐ |
| Memory Usage | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| Learning Curve | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐⭐ |
| Community Support | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |

## 📚 Common Use Cases

### 1. Static Website Hosting
```nginx
server {
    listen 80;
    server_name example.com;
    root /var/www/html;
    index index.html;
}
```

### 2. Reverse Proxy
```nginx
server {
    listen 80;
    server_name api.example.com;
    
    location / {
        proxy_pass http://backend:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### 3. Load Balancing
```nginx
upstream backend {
    server backend1:3000;
    server backend2:3000;
    server backend3:3000;
}

server {
    listen 80;
    location / {
        proxy_pass http://backend;
    }
}
```

## 🛡️ Security Best Practices

1. **Always run as non-root user**
2. **Keep nginx updated to latest stable version**
3. **Use HTTPS in production**
4. **Implement rate limiting**
5. **Set proper security headers**
6. **Regular security audits**

## 🔧 Troubleshooting

### Common Issues

**Container won't start**
```bash
# Check container logs
docker logs nginx-container

# Check if port is already in use
netstat -tulpn | grep :8080
```

**Permission denied errors**
```bash
# Ensure proper file ownership
chown -R 1001:1001 /path/to/nginx/files
```

**Configuration errors**
```bash
# Test nginx configuration
docker exec nginx-container nginx -t
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](../LICENSE) file for details.

## 🆘 Support

If you encounter any issues or have questions:

1. Check the troubleshooting section above
2. Review the nginx documentation
3. Open an issue in the repository
4. Join our community discussions

---

**Happy Learning! 🎉**
