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

