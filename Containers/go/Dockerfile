FROM golang:1.21-alpine

# Set working directory
WORKDIR /app

# Copy the hello world program
COPY hello_world.go .

# Create a non-root user
RUN addgroup -g 1001 -S goapp && \
    adduser -u 1001 -S goapp -G goapp

# Change ownership of the app directory
RUN chown -R goapp:goapp /app

# Switch to non-root user
USER goapp

# Run the hello world program
CMD ["go", "run", "hello_world.go"]
