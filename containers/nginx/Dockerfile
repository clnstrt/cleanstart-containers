# Use the cleanstart/nginx base image
FROM cleanstart/nginx:latest

# Set working directory
WORKDIR /usr/share/nginx/html

# Copy custom HTML file
COPY index.html .

# Expose default Nginx port
EXPOSE 80

# Health check using nginx configuration test
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD nginx -t || exit 1

# Ensure Nginx runs in the foreground
ENTRYPOINT ["nginx", "-g", "daemon off;"]
