# Start with the prometheus base image
FROM cleanstart/prometheus:latest-dev

# Set working directory
WORKDIR /etc/prometheus

# Switch to root to set up directories
USER root

# Create storage directory and set permissions
RUN mkdir -p /etc/prometheus/data && \
    chown -R prometheus:prometheus /etc/prometheus/data

# Copy Prometheus config (with proper ownership)
COPY --chown=prometheus:prometheus prometheus.yml /etc/prometheus/prometheus.yml

# Switch back to non-root user for security
USER prometheus

# Expose Prometheus web UI port
EXPOSE 9090

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:9090/-/healthy || exit 1

# Default command to run Prometheus
CMD [ \
  "--config.file=/etc/prometheus/prometheus.yml", \
  "--storage.tsdb.path=/etc/prometheus/data", \
  "--web.enable-lifecycle", \
  "--web.enable-admin-api" \
]