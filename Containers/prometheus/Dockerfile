FROM prom/prometheus:latest

# Set working directory
WORKDIR /etc/prometheus

# Create a non-root user
RUN addgroup -g 1001 -S prometheus && \
    adduser -u 1001 -S prometheus -G prometheus

# Create necessary directories
RUN mkdir -p /etc/prometheus/rules /etc/prometheus/scripts /var/lib/prometheus && \
    chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus

# Copy configuration files
COPY prometheus.yml /etc/prometheus/
COPY rules/ /etc/prometheus/rules/
COPY scripts/ /etc/prometheus/scripts/

# Set permissions
RUN chown -R prometheus:prometheus /etc/prometheus && \
    chmod +x /etc/prometheus/scripts/*.sh

# Switch to non-root user
USER prometheus

# Expose Prometheus port
EXPOSE 9090

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:9090/-/healthy || exit 1

# Default command
CMD ["--config.file=/etc/prometheus/prometheus.yml", \
     "--storage.tsdb.path=/var/lib/prometheus", \
     "--web.console.libraries=/etc/prometheus/console_libraries", \
     "--web.console.templates=/etc/prometheus/consoles", \
     "--web.enable-lifecycle", \
     "--web.enable-admin-api"]
