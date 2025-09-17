# Dockerfile for Nginx Load Balancer
FROM cleanstart/nginx:latest-dev

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy frontend static files
COPY frontend/index.html /usr/share/nginx/html/

# The nginx:alpine image already has a non-root "nginx" user.
# You don't need to create the user or set permissions for standard paths.

# Switch to the non-root user for security
USER nginx

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
