FROM node:18-alpine

# Install system dependencies
RUN apk add --no-cache \
    sqlite \
    sqlite-dev

# Set working directory
WORKDIR /app

# Copy the hello world program
COPY hello_world.js .

# Create a non-root user
RUN addgroup -g 1001 -S nodeapp && \
    adduser -u 1001 -S nodeapp -G nodeapp

# Change ownership of the app directory
RUN chown -R nodeapp:nodeapp /app

# Switch to non-root user
USER nodeapp

# Expose default port
EXPOSE 3000

# Run the hello world program
CMD ["node", "hello_world.js"]
