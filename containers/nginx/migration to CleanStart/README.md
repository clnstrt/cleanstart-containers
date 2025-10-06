**Nginx Migration Project**

This project demonstrates migrating a simple Nginx application from the official `nginx:latest` Docker image to the `cleanstart/nginx:latest-dev` image while serving a static HTML page.

**1. Create Static HTML Page**

Create `index.html` inside `html1/`:

```bash
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to Nginx Migration</title>
</head>
<body>
    <h1>Hello from Nginx!</h1>
    <p>This is running on nginx:latest Image</p>
</body>
</html>
```

**2. Create Static HTML Page**

```bash
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to Cleanstart Nginx Migration</title>
</head>
<body>
    <h1>Hello from Nginx!</h1>
    <p>This is running on cleanstart/nginx:latest-dev Image</p>
</body>
</html>
```

**3. Dockerfile.v1 (Old Container)**

Use official nginx image

```bash
# Dockerfile.v1
FROM nginx:latest

WORKDIR /app

# Optional custom nginx config
# COPY nginx.conf ./  

# Copy website files
COPY ../html1 /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Run nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
```

**4. Dockerfile.v2 (New Container)**

```bash
FROM cleanstart/nginx:latest-dev

WORKDIR /app

COPY ../html2 /app
COPY nginx.conf /etc/nginx/nginx.conf
```

Note: The cleanstart image runs Nginx with a custom configuration, but it still serves content from /usr/share/nginx/html by default.

**Build**

```bash
docker build -t nginx-v1 -f Dockerfile.v1 .
```

**Running nginx container**

```bash
docker run -d --name nginx-v1-container -p 8080:80 nginx-v1
```

**container logs**

```bash
docker logs nginx-v1-container
```

**Stop and Remove nginx container**

```bash
docker stop nginx-v1-container
docker rm nginx-v1-container
```

**Build Cleanstart Nginx container**

```bash
docker build -t nginx-v2 -f Dockerfile.v2 .
```

**Running Cleanstart container**

```bash
docker run -d --name nginx-v2-container -p 8080:80 nginx-v2
```

**container logs**

```bash
docker logs nginx-v2-container
```

**Stop and Remove Cleanstart nginx container**

```bash
docker stop nginx-v2-container
docker rm nginx-v2-container
```

**Remove Images**

```bash
docker rmi nginx-v1 nginx-v2
```

Notes
The cleanstart/nginx:latest-dev image uses clnstrt user and a custom Nginx configuration.

Copy HTML files to /usr/share/nginx/html to serve them properly.

For custom Nginx configuration, copy a modified nginx.conf into /etc/nginx/nginx.conf.