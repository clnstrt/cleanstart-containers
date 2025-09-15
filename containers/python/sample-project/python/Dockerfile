# Use Python 3.12 slim image as base
FROM cleanstart/python:latest-dev

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Set work directory
WORKDIR /app

# Copy the database example program
COPY database_example.py .

# Run the database example program
CMD ["python", "database_example.py"]
