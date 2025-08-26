FROM node:18-alpine

# Install system dependencies
RUN apk add --no-cache \
    sqlite \
    sqlite-dev

# Set working directory
WORKDIR /app

# Create a non-root user
RUN addgroup -g 1001 -S nodeapp && \
    adduser -u 1001 -S nodeapp -G nodeapp

# Switch to non-root user
USER nodeapp

# Expose default port
EXPOSE 3000

# Default command
CMD ["node", "--version"]
