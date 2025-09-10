FROM cleanstart/step-cli:latest

# Set working directory
WORKDIR /app

# Create a non-root user
RUN addgroup -g 1001 -S step && \
    adduser -u 1001 -S step -G step

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