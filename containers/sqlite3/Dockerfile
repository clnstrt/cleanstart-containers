FROM cleanstart/sqlite3:latest-dev

# Switch to root to install packages
USER root

# Install SQLite3 and essential tools
RUN apk add --no-cache \
    sqlite \
    sqlite-dev \
    bash \
    curl \
    jq \
    && rm -rf /var/cache/apk/*

# Set working directory
WORKDIR /app

# Create a non-root user
RUN addgroup -g 1001 -S sqlite && \
    adduser -u 1001 -S sqlite -G sqlite

# Create necessary directories
RUN mkdir -p /app/data /app/scripts /app/logs && \
    chown -R sqlite:sqlite /app

# Copy sample projects and scripts
COPY sample-project/ /app/sample-project/
COPY README.md /app/README.md

# Fix ownership of copied files
RUN chown -R sqlite:sqlite /app

# Switch to non-root user
USER sqlite

# Set environment variables
ENV SQLITE_DATABASE_PATH=/app/data
ENV SQLITE_LOG_LEVEL=info

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD sqlite3 --version || exit 1

# Default command
CMD ["sqlite3", "--version"]