FROM nginx:1.24-alpine

# Install curl for health checks
RUN apk add --no-cache curl

# Set working directory
WORKDIR /usr/share/nginx/html

# Copy the hello world HTML file
COPY hello_world.html index.html

# Create a non-root user
RUN addgroup -g 1001 -S nginxapp && \
    adduser -u 1001 -S nginxapp -G nginxapp

# Change ownership of the nginx directories
RUN chown -R nginxapp:nginxapp /var/cache/nginx && \
    chown -R nginxapp:nginxapp /var/log/nginx && \
    chown -R nginxapp:nginxapp /etc/nginx/conf.d && \
    chown -R nginxapp:nginxapp /usr/share/nginx/html

# Switch to non-root user
USER nginxapp

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
