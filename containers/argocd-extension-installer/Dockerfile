FROM alpine:3.18

# Install necessary packages
RUN apk add --no-cache \
    curl \
    wget \
    git \
    bash \
    jq \
    yq \
    kubectl \
    helm \
    && rm -rf /var/cache/apk/*

# Set working directory
WORKDIR /app

# Create a non-root user
RUN addgroup -g 1001 -S argocd && \
    adduser -u 1001 -S argocd -G argocd

# Create necessary directories
RUN mkdir -p /app/extensions /app/scripts /app/config && \
    chown -R argocd:argocd /app

# Switch to non-root user
USER argocd

# Copy extension installer scripts
COPY --chown=argocd:argocd scripts/ /app/scripts/
COPY --chown=argocd:argocd config/ /app/config/

# Make scripts executable
RUN chmod +x /app/scripts/*.sh

# Expose port 8080 (if needed for web interface)
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# Default command
CMD ["/app/scripts/install-extensions.sh"]
