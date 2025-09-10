# 🌐 Nginx Sample Projects

This directory contains sample projects for testing the `cleanstart/nginx` Docker image that you already pulled from Docker Hub. These examples demonstrate Nginx web server configurations for static sites, reverse proxy, and load balancing.

## 🚀 Quick Start

### Prerequisites
- Docker installed and running
- Port 80/8080 available (optional)

### Setup
```bash
# Navigate to this directory
cd containers/nginx/sample-project

# Test the image (you already pulled cleanstart/nginx:latest from Docker Hub)
docker run --rm cleanstart/nginx:latest nginx -v
```

### Run Examples

#### Static Site
```bash
# Run static site
docker run --rm -p 8080:80 -v $(pwd)/static-site:/usr/share/nginx/html \
  cleanstart/nginx:latest

# Access at http://localhost:8080
```

#### Reverse Proxy
```bash
# Start backend service
docker run --rm -d --name backend -p 3000:3000 \
  -v $(pwd)/reverse-proxy/backend:/app python:3.9-slim \
  python -m http.server 3000

# Start nginx reverse proxy
docker run --rm -p 8080:80 -v $(pwd)/reverse-proxy/nginx.conf:/etc/nginx/nginx.conf \
  cleanstart/nginx:latest

# Access backend through proxy at http://localhost:8080
```

#### Load Balancer
```bash
# Start multiple backend services
docker run --rm -d --name backend1 -p 3001:3000 \
  -v $(pwd)/load-balancer/backend1:/app python:3.9-slim \
  python -m http.server 3000

docker run --rm -d --name backend2 -p 3002:3000 \
  -v $(pwd)/load-balancer/backend2:/app python:3.9-slim \
  python -m http.server 3000

# Start nginx load balancer
docker run --rm -p 8080:80 -v $(pwd)/load-balancer/nginx.conf:/etc/nginx/nginx.conf \
  cleanstart/nginx:latest

# Access load balanced service at http://localhost:8080
```

#### Using Docker Compose
```bash
# Start static site
docker-compose -f static-site/docker-compose.yml up -d

# Start reverse proxy
docker-compose -f reverse-proxy/docker-compose.yml up -d

# Start load balancer
docker-compose -f load-balancer/docker-compose.yml up -d
```

## 📁 Project Structure

```
sample-project/
├── README.md                    # This file
├── static-site/                # Static website example
│   ├── css/                   # Stylesheets
│   ├── images/                # Images
│   ├── js/                    # JavaScript files
│   ├── index.html             # Main page
│   ├── nginx.conf             # Nginx configuration
│   └── docker-compose.yml     # Docker Compose setup
├── reverse-proxy/             # Reverse proxy example
│   ├── backend/               # Backend application
│   ├── frontend/              # Frontend files
│   ├── nginx.conf             # Proxy configuration
│   └── docker-compose.yml     # Docker Compose setup
├── load-balancer/             # Load balancer example
│   ├── backend1/              # First backend
│   ├── backend2/              # Second backend
│   ├── backend3/              # Third backend
│   ├── frontend/              # Frontend files
│   ├── nginx.conf             # Load balancer config
│   └── docker-compose.yml     # Docker Compose setup
├── setup.bat                  # Windows setup script
└── setup.sh                   # Linux/Mac setup script
```

## 🎯 Features

- Static website hosting
- Reverse proxy configuration
- Load balancing with multiple backends
- SSL/TLS termination
- Custom nginx configurations
- Docker Compose integration
- Health checks and monitoring

## 📊 Output

Nginx serves content on:
- Static sites: HTML, CSS, JS, images
- Reverse proxy: Backend application responses
- Load balancer: Distributed requests across backends

## 🔒 Security

- Non-root user execution
- Secure nginx configurations
- SSL/TLS support
- Access control and rate limiting

## 🤝 Contributing

To add new nginx configurations:
1. Create configuration in appropriate directory
2. Add documentation
3. Test with nginx
