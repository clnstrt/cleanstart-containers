# FROM cleanstart/memcached:latest-dev

# WORKDIR /app

# COPY . .

# EXPOSE 11211

# CMD ["memcached", "-m", "128", "-p", "11211", "-u", "memcache", "-l", "0.0.0.0", "-vv"]
FROM cleanstart/memcached:latest-dev

# Install Python and required packages
USER root
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy application files
COPY . .

# Install Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Make start script executable
RUN chmod +x start.sh

# Expose both Memcached and Flask ports
EXPOSE 11211 5000

# Use the start script
CMD ["./start.sh"]