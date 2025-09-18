FROM cleanstart/kyverno-kyvernopre:latest-dev

# Set user if needed (matches image config)
USER clnstrt

# Copy any config or test files if needed
# COPY test-config.yaml /app/test-config.yaml
WORKDIR /app

# Default command (can run your small test config)
# CMD ["/usr/bin/kyvernopre", "apply", "-f", "test-config.yaml"]
CMD ["/usr/bin/kyvernopre", "--help"]

