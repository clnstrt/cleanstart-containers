# Execute Nginx Web Server on CleanStart Container - Nginx

A comprehensive web server solution for static sites, reverse proxy, and load balancing built with **Nginx**, **Docker**, and **CleanStart**.

## Objective

The objective of this project is to utilize CleanStart Container Image - Nginx and build a complete web server solution that provides high-performance static site hosting, reverse proxy capabilities, and load balancing—supporting various web server configurations—packaged in a containerized environment for easy deployment and scalability.

## Summary

This project demonstrates how to combine Nginx, Docker, and CleanStart to create a robust web server system. It offers both static site hosting and dynamic reverse proxy capabilities—supporting various web server configurations—packaged in a containerized environment for easy deployment and scalability.

## Quick Start - Run Locally

### Prerequisites
Pull CleanStart Nginx image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart) 
```bash
docker pull cleanstart/nginx:latest
```

### Step 1: Navigate to Nginx Directory
```bash
cd containers/nginx/sample-project
```

### Step 2: Run Static Site
```bash
# Run static site
docker run --rm -p 8080:80 -v $(pwd)/static-site:/usr/share/nginx/html \
  cleanstart/nginx:latest

# Access at http://localhost:8080
```

### Step 3: Run Reverse Proxy
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

### Step 4: Run Load Balancer
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

### Nginx Output
You should see output like this:
```
nginx: [alert] could not open error log file: open() "/var/log/nginx/error.log" failed (13: Permission denied)
2024/01/15 10:30:45 [notice] 1#1: using the "epoll" event method
2024/01/15 10:30:45 [notice] 1#1: nginx/1.25.3
2024/01/15 10:30:45 [notice] 1#1: start worker processes
2024/01/15 10:30:45 [notice] 1#1: start worker process 7
```

### Application Access
Once started, you can access the application at: **http://localhost:8080**

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

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [Nginx Official Documentation](https://nginx.org/en/docs/)
- [Nginx Configuration Guide](https://nginx.org/en/docs/beginners_guide.html)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).
