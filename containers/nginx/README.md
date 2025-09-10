# Nginx Docker Image

A lightweight and high-performance web server, reverse proxy, and load balancer based on Nginx.

## Pull Image
```bash
docker pull cleanstart/nginx:latest
```

## Run Container
```bash
# Basic run
docker run -d -p 8080:80 --name nginx-container cleanstart/nginx:latest

# Run with custom port
docker run -d -p 3000:80 --name nginx-container cleanstart/nginx:latest

# Run with volume mount
docker run -d -p 8080:80 -v /path/to/html:/usr/share/nginx/html --name nginx-container cleanstart/nginx:latest
```

## Check Version
```bash
docker run --rm cleanstart/nginx:latest nginx -v
```

## Check Image Size
```bash
docker images cleanstart/nginx:latest
```

## Test Container
```bash
# Test if container is running
docker ps | grep nginx

# Test web server response
curl http://localhost:8080

# Check container logs
docker logs nginx-container
```

## Sample Projects
For detailed usage examples and demonstrations, see the `sample-project/` directory.
