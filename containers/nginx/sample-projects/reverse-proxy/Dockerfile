# # Dockerfile for Nginx Reverse Proxy
# FROM cleanstart/nginx:latest-dev

# # Install curl for health checks
# RUN apk add --no-cache curl

# # Copy custom nginx configuration
# COPY nginx.conf /etc/nginx/nginx.conf

# # Copy frontend static files
# COPY frontend/index.html /usr/share/nginx/html/

# # Create nginx user if it doesn't exist
# RUN addgroup -g 101 -S nginx && \
#     adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx

# # Create necessary directories
# RUN mkdir -p /var/cache/nginx /var/log/nginx /etc/nginx/conf.d

# # Set proper permissions
# RUN chown -R nginx:nginx /var/cache/nginx && \
#     chown -R nginx:nginx /var/log/nginx && \
#     chown -R nginx:nginx /etc/nginx/conf.d && \
#     chown -R nginx:nginx /usr/share/nginx/html

# # Create non-root user
# USER nginx

# # Expose port 80
# EXPOSE 80

# # Health check
# HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
#     CMD curl -f http://localhost/health || exit 1

# # Start nginx
# CMD ["nginx", "-g", "daemon off;"]


# Dockerfile for Nginx Reverse Proxy
# Using the lightweight Nginx Alpine base image
FROM cleanstart/nginx:latest-dev

# Install curl for health checks
RUN apk add --no-cache curl

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy frontend static files
COPY frontend/index.html /usr/share/nginx/html/

# The nginx:alpine image already has a non-root "nginx" user.
# You don't need to create the user or set permissions for standard paths.

# Switch to the non-root user for security
USER nginx

# Expose port 80
EXPOSE 8000

# Health check (now that curl is installed)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/health || exit 1

# Start nginx
ENTRYPOINT ["nginx", "-g", "daemon off;"]
