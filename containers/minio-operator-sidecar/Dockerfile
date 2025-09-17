FROM cleanstart/minio-operator-sidecar:latest-dev

# Set working directory
WORKDIR /app

# Create a non-root user
RUN addgroup -g 1001 -S minio && \
    adduser -u 1001 -S minio -G minio

# Create necessary directories
RUN mkdir -p /app/config /app/scripts /app/logs && \
    chown -R minio:minio /app

# Copy sample projects and configurations
COPY sample-project/ /app/sample-project/
COPY README.md /app/README.md

# Set environment variables
ENV MINIO_OPERATOR_NAMESPACE=minio-operator
ENV MINIO_OPERATOR_LOG_LEVEL=info
ENV MINIO_OPERATOR_WATCH_NAMESPACE=""

# Switch to non-root user
USER minio

# Expose default ports
EXPOSE 4222 4223

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD kubectl get pods -n minio-operator || exit 1

# Default command
CMD ["operator", "--help"]
