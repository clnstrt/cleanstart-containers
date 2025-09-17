FROM minio/minio:latest

# Set working directory
WORKDIR /opt/minio

# Create a non-root user
RUN addgroup -g 1001 -S minio && \
    adduser -u 1001 -S minio -G minio

# Create necessary directories
RUN mkdir -p /data && \
    chown -R minio:minio /data && \
    chown -R minio:minio /opt/minio

# Switch to non-root user
USER minio

# Expose port 9000 (MinIO API) and 9001 (MinIO Console)
EXPOSE 9000 9001

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:9000/minio/health/live || exit 1

# Set default environment variables
ENV MINIO_ROOT_USER=minioadmin
ENV MINIO_ROOT_PASSWORD=minioadmin123

# Start MinIO server
CMD ["server", "/data", "--console-address", ":9001"]
