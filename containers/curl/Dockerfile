# Use CleanStart base image for Curl Docker Image
FROM cleanstart/curl:latest-dev

# Set environment variables
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

# Set working directory
WORKDIR /workspace

# Switch to non-root user (clnstrt as shown in docker inspect)
USER clnstrt

# Set default entrypoint to curl
ENTRYPOINT ["/usr/bin/curl"]
