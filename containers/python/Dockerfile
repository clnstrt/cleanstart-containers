# Use Python 3.12 slim image as base
FROM cleanstart/python:latest

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Set work directory
WORKDIR /app

# Copy the hello world program
COPY hello_world.py .

# Create non-root user for security
RUN adduser --disabled-password --gecos '' appuser \
    && chown -R appuser:appuser /app
USER appuser

# Run the hello world program
CMD ["python", "hello_world.py"]
