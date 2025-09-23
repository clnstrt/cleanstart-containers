# Base image
FROM cleanstart/python:latest-dev

# Set working directory
WORKDIR /app

# Copy Python requirements first for caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the app code
COPY . .

# Expose the port your app will run on
EXPOSE 8002

# Correct CMD pointing to your main script
CMD ["python3", "app.py"]

