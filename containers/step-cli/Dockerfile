FROM cleanstart/go:latest

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Step CLI
RUN curl -LO https://dl.step.sm/gh-release/cli/docs-cli-install/v0.24.4/step_linux_0.24.4_amd64.tar.gz && \
    tar -xzf step_linux_0.24.4_amd64.tar.gz && \
    mv step_0.24.4/bin/step /usr/local/bin/ && \
    rm -rf step_linux_0.24.4_amd64.tar.gz step_0.24.4

# Set working directory
WORKDIR /app

# Create a non-root user
RUN groupadd -g 1001 step && \
    useradd -u 1001 -g step -s /bin/bash step

# Create necessary directories
RUN mkdir -p /app/certs /app/config /app/secrets && \
    chown -R step:step /app

# Switch to non-root user
USER step

# Set default environment variables
ENV STEPPATH=/app/secrets
ENV STEP_CA_URL=https://ca.example.com
ENV STEP_CA_FINGERPRINT=""

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD step version || exit 1

# Default command
CMD ["step", "--help"]