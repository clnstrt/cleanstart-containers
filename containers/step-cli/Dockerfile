FROM cleanstart/go:latest-dev

# Download and extract Step CLI in a separate stage to avoid library conflicts
FROM alpine:latest AS downloader
RUN apk add --no-cache curl && \
    curl -LO https://dl.step.sm/gh-release/cli/docs-cli-install/v0.24.4/step_linux_0.24.4_amd64.tar.gz && \
    tar -xzf step_linux_0.24.4_amd64.tar.gz

# Copy the step binary from the downloader stage
COPY --from=downloader /step_0.24.4/bin/step ./step

# Create a non-root user
RUN groupadd -g 1001 clnstrt && \
    useradd -u 1001 -g clnstrt -s /bin/bash clnstrt

# Create necessary directories
RUN mkdir -p /home/clnstrt/.step/certs /home/clnstrt/.step/config /home/clnstrt/.step/secrets && \
    chown -R clnstrt:clnstrt /home/clnstrt

# Switch to non-root user
USER clnstrt

# Set default environment variables
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD ./step version || exit 1

# Default command
ENTRYPOINT ["./step"]
CMD ["--help"]

# Label as dev version
LABEL version="latest-dev"
