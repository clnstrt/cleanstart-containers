# Dockerfile for Frontend (Static Files)
FROM nginx:1.24-alpine

# Install curl for health checks
RUN apk add --no-cache curl

# Copy static files
COPY index.html /usr/share/nginx/html/

# Create nginx user if it doesn't exist
RUN addgroup -g 101 -S nginx && \
    adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx

# Set proper permissions
RUN chown -R nginx:nginx /usr/share/nginx/html

# Create non-root user
USER nginx

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
