FROM node:18-alpine

# Install system dependencies
RUN apk add --no-cache \
    sqlite \
    sqlite-dev

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install --only=production

# Copy application code
COPY . .

# Create a non-root user
RUN addgroup -g 1001 -S nodeapp && \
    adduser -u 1001 -S nodeapp -G nodeapp

# Change ownership of the app directory
RUN chown -R nodeapp:nodeapp /app

# Switch to non-root user
USER nodeapp

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

# Start the application
CMD ["npm", "start"]
