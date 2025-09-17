FROM gcr.io/cadvisor/cadvisor:v0.47.2

# Set working directory
WORKDIR /app

# Create a non-root user
RUN addgroup -g 1001 -S cadvisor && \
    adduser -u 1001 -S cadvisor -G cadvisor

# Create necessary directories
RUN mkdir -p /var/lib/cadvisor && \
    chown -R cadvisor:cadvisor /var/lib/cadvisor

# Switch to non-root user
USER cadvisor

# Expose port 8080 (cAdvisor web UI)
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/healthz || exit 1

# Run cAdvisor
CMD ["--logtostderr", "--port=8080"]
