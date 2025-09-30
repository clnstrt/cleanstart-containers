FROM cleanstart/memcached:latest-dev

USER root

# Install Python3 and basic tools
RUN apk add --no-cache python3 py3-pip

# Create a virtual environment and install packages
WORKDIR /app

# Copy requirements first for better Docker layer caching
COPY requirements.txt .

# Install Python dependencies
RUN pip3 install --no-cache-dir --break-system-packages -r requirements.txt

# Copy application files
COPY . .

# Make start script executable
RUN chmod +x start.sh

# Expose both Memcached and Flask ports
EXPOSE 11211 5000

# Use the start script
CMD ["./start.sh"]
