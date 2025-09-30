# # Dockerfile
# FROM cleanstart/cortex:latest-dev

# # Override the default entrypoint
# ENTRYPOINT []

# # Set work directory
# WORKDIR /app

# # Copy script
# COPY app.py .

# # Switch to root to ensure permissions, then back to clnstrt user
# # USER root
# # RUN chown -R clnstrt:clnstrt /app
# # USER clnstrt

# # Run the script
# CMD ["python", "app.py"]

FROM cleanstart/cortex:latest-dev

# Disable Cortex binary startup
ENTRYPOINT []

WORKDIR /app

# Copy your files
COPY data.json .
COPY app.py .

# Run your Python app instead of Cortex
CMD ["python", "app.py"]

