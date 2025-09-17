FROM grafana/cortex:1.15.0

# Set working directory
WORKDIR /app

# Create a non-root user
RUN addgroup -g 1001 -S cortex && \
    adduser -u 1001 -S cortex -G cortex

# Create necessary directories
RUN mkdir -p /app/config /app/data /app/logs && \
    chown -R cortex:cortex /app

# Copy sample projects and configurations
COPY sample-project/ /app/sample-project/
COPY README.md /app/README.md

# Set environment variables
ENV CORTEX_LOG_LEVEL=info
ENV CORTEX_STORAGE_ENGINE=filesystem
ENV CORTEX_DATA_DIR=/app/data

# Switch to non-root user
USER cortex

# Expose default ports
EXPOSE 9009 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/ready || exit 1

# Default command
CMD ["cortex", "--help"]
