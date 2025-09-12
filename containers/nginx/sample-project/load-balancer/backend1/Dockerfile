# # Simple Dockerfile for Flask Backend API 1
# FROM cleanstart/python:latest-dev

# # Set working directory
# WORKDIR /app

# # Install system dependencies
# RUN apk add --no-cache curl bash

# # Copy requirements first for caching
# COPY requirements.txt .

# # Install Python dependencies
# RUN pip install --no-cache-dir -r requirements.txt

# # Copy application code
# COPY app.py .

# # Create non-root user and switch
# RUN adduser -D app
# USER app

# # Expose port
# EXPOSE 8001

# # Health check
# HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
#     CMD curl -f http://localhost:8001/health || exit 1

# # Run the application
# CMD ["python", "app.py"]


# Base image
FROM cleanstart/python:latest-dev

# Switch to root to install dependencies
USER root

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apk add --no-cache curl bash

# Copy Python requirements first for caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the app code
COPY . .

# Optional: switch back to non-root user if needed
# USER someuser

# Expose the port your app will run on
EXPOSE 5000

# Correct CMD pointing to your main script
ENTRYPOINT ["python", "app.py"]

