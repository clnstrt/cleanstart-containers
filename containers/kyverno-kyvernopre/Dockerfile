FROM kyverno/kyverno:v1.10.2

# Set working directory
WORKDIR /app

# Create a non-root user
RUN addgroup -g 1001 -S kyverno && \
    adduser -u 1001 -S kyverno -G kyverno

# Create necessary directories
RUN mkdir -p /app/policies /app/config /app/logs && \
    chown -R kyverno:kyverno /app

# Copy sample projects and configurations
COPY sample-project/ /app/sample-project/
COPY README.md /app/README.md

# Set environment variables
ENV KYVERNO_NAMESPACE=kyverno
ENV KYVERNO_LOG_LEVEL=info
ENV KYVERNO_WATCH_NAMESPACE=""

# Switch to non-root user
USER kyverno

# Expose default ports
EXPOSE 9443 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD kyverno version || exit 1

# Default command
CMD ["kyverno", "--help"]
