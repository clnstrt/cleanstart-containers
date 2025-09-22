# FROM cleanstart/stakater-reloader:latest

# # Set working directory
# WORKDIR /app

# # Create a non-root user
# RUN addgroup -g 1001 -S clnstrt && \
#     adduser -u 1001 -S clnstrt -G clnstrt

# # Create necessary directories
# RUN mkdir -p /app/config /app/logs && \
#     chown -R clnstrt:clnstrt /app

# # Copy sample projects and configurations
# COPY sample-project/ /app/sample-project/
# COPY README.md /app/README.md

# # Set environment variables
# ENV RELOADER_LOG_LEVEL=info
# ENV RELOADER_WATCH_NAMESPACE=""
# ENV RELOADER_IGNORE_SECRETS=false

# # Switch to non-root user
# USER clnstrt

# # Expose default ports
# EXPOSE 8080

# # Health check
# HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
#     CMD curl -f http://localhost:8080/health || exit 1

# # Default command
# CMD ["/usr/bin/Reloader", "--help"]

FROM cleanstart/stakater-reloader:latest-dev

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]


