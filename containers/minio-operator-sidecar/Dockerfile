# Start from a minimal Debian base (fits the size and common layering)
FROM cleanstart/minio-operator-sidecar:latest-dev

# Set environment variables
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

# Create non-root user (matches "User": "clnstrt" in inspect output)
RUN groupadd -r clnstrt && \
    useradd -r -g clnstrt clnstrt

# Copy the sidecar binary into the container
COPY minio-operator-sidecar /minio-operator-sidecar

# Ensure the binary is executable
RUN chmod +x /minio-operator-sidecar

# Switch to non-root user
USER clnstrt

# Entrypoint binary (as shown in inspect)
ENTRYPOINT ["/minio-operator-sidecar"]