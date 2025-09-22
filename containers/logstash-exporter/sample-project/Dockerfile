# FROM cleanstart/logstash-exporter:latest-dev

# # Default port for Prometheus scraping
# EXPOSE 9198

# # Just run exporter
# ENTRYPOINT ["/usr/bin/logstash-exporter"]
FROM cleanstart/logstash-exporter:latest-dev

# Optional: add healthcheck for exporter
HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD curl -f http://localhost:9198/metrics || exit 1

EXPOSE 9198
