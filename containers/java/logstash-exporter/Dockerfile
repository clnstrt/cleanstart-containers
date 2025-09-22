FROM prom/logstash-exporter:latest

# Set working directory
WORKDIR /app

# Create a non-root user
RUN addgroup -g 1001 -S logstash-exporter && \
    adduser -u 1001 -S logstash-exporter -G logstash-exporter

# Create necessary directories
RUN mkdir -p /app/config && \
    chown -R logstash-exporter:logstash-exporter /app

# Switch to non-root user
USER logstash-exporter

# Expose port 9198 (logstash-exporter default port)
EXPOSE 9198

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:9198/health || exit 1

# Set default environment variables
ENV LOGSTASH_SERVER=http://logstash:9600
ENV LOGSTASH_TIMEOUT=5s

# Start logstash-exporter
CMD ["--logstash.server=${LOGSTASH_SERVER}", "--logstash.timeout=${LOGSTASH_TIMEOUT}"]
