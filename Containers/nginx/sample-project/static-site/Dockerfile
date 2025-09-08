# Multi-stage Dockerfile for Nginx Static Site
# Stage 1: Build stage (if needed for any build processes)
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files (if any)
# COPY package*.json ./
# RUN npm ci --only=production

# Copy source files
COPY . .

# Stage 2: Production stage
FROM nginx:1.24-alpine

# Install additional packages if needed
RUN apk add --no-cache \
    curl \
    && rm -rf /var/cache/apk/*

# Use the default nginx user that already exists in the base image

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy static files from builder stage
COPY --from=builder /app/index.html /usr/share/nginx/html/
COPY --from=builder /app/css/ /usr/share/nginx/html/css/
COPY --from=builder /app/js/ /usr/share/nginx/html/js/

# Create necessary directories
RUN mkdir -p /var/cache/nginx /var/log/nginx /etc/nginx/conf.d

# Set proper permissions for nginx user
RUN chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /etc/nginx/conf.d && \
    chown -R nginx:nginx /usr/share/nginx/html

# Note: Running as root is standard for nginx containers
# The nginx process will drop privileges internally

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/health || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
