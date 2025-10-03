# Kyverno-Kyvernopre Sample Dockerfile
# This Dockerfile demonstrates how to extend the base Kyverno-Kyvernopre image

FROM cleanstart/kyverno-kyvernopre:latest

# Set working directory
WORKDIR /app

# Set default environment variables (all required for proper startup)
ENV KYVERNO_NAMESPACE=kyverno
ENV KYVERNO_SERVICEACCOUNT_NAME=kyverno
ENV KYVERNO_DEPLOYMENT=kyverno
ENV KYVERNO_POD_NAME=kyverno-pre
ENV INIT_CONFIG='{"config":{}}'
ENV METRICS_CONFIG='{"enabled":false}'

# Copy sample configuration files
COPY test-config.yaml /app/test-config.yaml

# Expose default ports
EXPOSE 9443 8000

# Health check to verify container is working
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD /usr/bin/kyvernopre --help || exit 1

# Default command - show help (works without Kubernetes cluster)
# Note: Base image already sets ENTRYPOINT ["/usr/bin/kyvernopre"]
CMD ["--help"]
