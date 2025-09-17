FROM memcached:1.6.21-alpine

# Set working directory
WORKDIR /app

# Create a non-root user
RUN addgroup -g 1001 -S memcache && \
    adduser -u 1001 -S memcache -G memcache

# Create necessary directories
RUN mkdir -p /app/config /app/logs && \
    chown -R memcache:memcache /app

# Copy sample projects and configurations
COPY sample-project/ /app/sample-project/
COPY README.md /app/README.md

# Set environment variables
ENV MEMCACHED_MEMORY=64
ENV MEMCACHED_MAX_CONNECTIONS=1024
ENV MEMCACHED_THREADS=4

# Switch to non-root user
USER memcache

# Expose default ports
EXPOSE 11211

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD echo "stats" | nc localhost 11211 || exit 1

# Default command
CMD ["memcached", "-m", "64", "-c", "1024", "-t", "4"]
