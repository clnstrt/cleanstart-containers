# Use official Python image
FROM python:latest

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Set work directory
WORKDIR /app

# Install common Python packages
RUN pip install --no-cache-dir \
    flask \
    requests \
    pytest \
    pytest-cov

# Default command
CMD ["python", "--version"]
