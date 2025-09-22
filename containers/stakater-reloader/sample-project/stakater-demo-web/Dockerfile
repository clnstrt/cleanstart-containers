FROM cleanstart/stakater-reloader:latest-dev

WORKDIR /app

COPY config.txt /app/config.txt
COPY server.sh /app/server.sh

# Explicitly override the entrypoint
ENTRYPOINT ["/app/server.sh"]

EXPOSE 8080
