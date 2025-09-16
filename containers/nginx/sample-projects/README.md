# Nginx Sample Projects

This directory contains practical examples demonstrating different Nginx use cases, from serving static content to load balancing multiple backend services.

## Quick Start

### Prerequisites
- Docker and Docker Compose installed
- Basic understanding of web servers and containers

### Available Sample Projects

1. **Static Site** - Serve static HTML/CSS/JS files
2. **Reverse Proxy** - Proxy requests to backend services
3. **Load Balancer** - Distribute traffic across multiple backend servers

## How to Run the Applications

### Option 1: Using the Setup Script (Recommended)

The easiest way to run any sample project is using the provided setup script:

```bash
# Make the script executable (if not already)
chmod +x setup.sh

# Run a specific project
./setup.sh static-site      # Runs static site on port 8080
./setup.sh reverse-proxy    # Runs reverse proxy on port 80
./setup.sh load-balancer    # Runs load balancer on port 80

# Run all projects on different ports
./setup.sh all

# Stop all running containers
./setup.sh stop

# Clean up all containers and images
./setup.sh clean

# Show help
./setup.sh help
```

### Option 2: Manual Docker Commands

#### 1. Static Site Example

```bash
# Navigate to the static-site directory
cd static-site

# Build and run the container
docker build -t nginx-static-site .
docker run -d --name nginx-static -p 8080:80 nginx-static-site

# Access the site
open http://localhost:8080

# Stop and remove the container
docker stop nginx-static && docker rm nginx-static
```

#### 2. Reverse Proxy Example

```bash
# Navigate to the reverse-proxy directory
cd reverse-proxy

# Build and start all services (nginx + backend)
docker-compose up -d --build

# Access the application
open http://localhost

# Test the API
curl http://localhost/api/health

# Stop all services
docker-compose down
```

#### 3. Load Balancer Example

```bash
# Navigate to the load-balancer directory
cd load-balancer

# Build and start all services (nginx + 3 backend servers)
docker-compose up -d --build

# Access the application
open http://localhost

# Test load balancing (run multiple times to see different servers)
curl http://localhost/api/server-info

# Stop all services
docker-compose down
```

## Using the Base Nginx Image

### Pull the CleanStart Nginx Image

```bash
# Pull the development image (includes build tools)
docker pull cleanstart/nginx:latest-dev

# Pull the production image (lightweight)
docker pull cleanstart/nginx:latest
```

### Run Nginx Container Directly

```bash
# Run nginx with default configuration
docker run --rm -it --name nginx-web-dev -p 8080:80 cleanstart/nginx:latest-dev

# Run nginx in interactive mode for development
docker run --rm -it --entrypoint /bin/sh cleanstart/nginx:latest-dev

# Run nginx with custom configuration
docker run --rm -it --name nginx-custom -p 8080:80 \
  -v $(pwd)/custom-nginx.conf:/etc/nginx/nginx.conf \
  cleanstart/nginx:latest-dev
```

## Testing the Applications

### Static Site Features
- **URL**: http://localhost:8080
- **Features**: Modern responsive design, Bootstrap 5, Font Awesome icons
- **Endpoints**: 
  - `/` - Main page
  - `/health` - Health check
  - `/status` - Nginx status (localhost only)

### Reverse Proxy Features
- **URL**: http://localhost
- **Frontend**: Static HTML served by Nginx
- **Backend API**: Flask application proxied through Nginx
- **API Endpoints**:
  - `GET /api/` - API information
  - `GET /api/health` - Health check
  - `GET /api/users` - Get all users
  - `POST /api/users` - Create new user
  - `GET /api/stats` - API statistics

### Load Balancer Features
- **URL**: http://localhost
- **Backend Servers**: 3 Flask applications (ports 8001, 8002, 8003)
- **Load Balancing**: Round-robin distribution
- **API Endpoints**: Same as reverse proxy, but requests are distributed across servers
- **Server Identification**: Each response includes `server_id` and `hostname`

## Development and Customization

### Customizing Static Content

1. Edit files in the `static-site/` directory:
   - `index.html` - Main page content
   - `css/style.css` - Custom styles
   - `js/script.js` - JavaScript functionality

2. Rebuild and run:
```bash
cd static-site
docker build -t nginx-static-site .
docker run -d --name nginx-static -p 8080:80 nginx-static-site
```

### Customizing Nginx Configuration

1. Edit `nginx.conf` in any project directory
2. Rebuild the container to apply changes
3. Key configuration sections:
   - `upstream` - Backend server definitions
   - `server` - Virtual host configuration
   - `location` - URL routing rules

### Adding New Backend Services

1. Create a new backend directory (e.g., `backend4/`)
2. Add the service to `docker-compose.yml`
3. Update the nginx `upstream` configuration
4. Rebuild and restart services

## Troubleshooting

### Common Issues

**Port already in use:**
```bash
# Check what's using the port
docker ps | grep :8080

# Stop conflicting containers
docker stop <container-name>
```

**Container won't start:**
```bash
# Check container logs
docker logs <container-name>

# Check nginx configuration
docker exec <container-name> nginx -t
```

**API not responding:**
```bash
# Check if backend services are running
docker-compose ps

# Check backend logs
docker-compose logs backend1
```

### Useful Commands

```bash
# View all running containers
docker ps

# View container logs
docker logs <container-name>

# Execute commands in running container
docker exec -it <container-name> /bin/sh

# Check nginx configuration syntax
docker exec <container-name> nginx -t

# Reload nginx configuration
docker exec <container-name> nginx -s reload
```

## Learning Resources

- **Nginx Official Documentation**: https://nginx.org/en/docs/
- **Nginx Configuration Guide**: https://nginx.org/en/docs/beginners_guide.html
- **Docker Compose Documentation**: https://docs.docker.com/compose/
- **CleanStart Website**: https://www.cleanstart.com

## Project Structure

```
sample-projects/
├── README.md                 # This file
├── setup.sh                 # Automated setup script
├── static-site/             # Static website example
│   ├── Dockerfile
│   ├── nginx.conf
│   ├── index.html
│   ├── css/
│   └── js/
├── reverse-proxy/           # Reverse proxy example
│   ├── Dockerfile
│   ├── nginx.conf
│   ├── frontend/
│   └── backend/
└── load-balancer/           # Load balancer example
    ├── docker-compose.yml
    ├── Dockerfile
    ├── nginx.conf
    ├── frontend/
    ├── backend1/
    ├── backend2/
    └── backend3/
```

## Next Steps

1. **Explore the code**: Look at the configuration files and application code
2. **Modify examples**: Try changing the HTML, CSS, or backend logic
3. **Add features**: Implement authentication, caching, or SSL/TLS
4. **Scale up**: Add more backend servers or implement different load balancing strategies
5. **Production deployment**: Use the production nginx image and implement proper security measures

---

For more examples and advanced configurations, visit the [CleanStart documentation](https://www.cleanstart.com) or the [Nginx official documentation](https://nginx.org/en/docs/).
