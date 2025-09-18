# Dockerfile
FROM cleanstart/cortex:latest-dev

# Override the default entrypoint
ENTRYPOINT []

# Set work directory
WORKDIR /app

# Copy script
COPY app.py .

# Switch to root to ensure permissions, then back to clnstrt user
# USER root
# RUN chown -R clnstrt:clnstrt /app
# USER clnstrt

# Run the script
CMD ["python", "app.py"]