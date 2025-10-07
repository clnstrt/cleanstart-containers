FROM cleanstart/cortex:latest-dev

# Disable Cortex binary startup
ENTRYPOINT []

WORKDIR /app

# Copy your files
COPY data.json .
COPY app.py .

# Run your Python app instead of Cortex
CMD ["app.py"]

