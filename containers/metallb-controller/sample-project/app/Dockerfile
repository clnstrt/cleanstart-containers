FROM cleanstart/metallb-controller:latest-dev

WORKDIR /app

# Copy demo script
COPY demo.sh /app/demo.sh

# Fix line endings + make executable
RUN sed -i 's/\r$//' /app/demo.sh && chmod +x /app/demo.sh

# Expose port for HTTP server
EXPOSE 8080

# Override entrypoint to run demo.sh
ENTRYPOINT ["/app/demo.sh"]
