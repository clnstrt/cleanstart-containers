# Use CleanStart base image for Curl Docker Image
FROM cleanstart/glibc:latest

# Set environment variables
ENV CURL_VERSION=8.4.0
ENV JQ_VERSION=1.7.1

# Install essential packages
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    jq \
    bash \
    git \
    ca-certificates \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /workspace

# Create a non-root user
RUN groupadd -g 1001 curluser && \
    useradd -u 1001 -g curluser -s /bin/bash curluser

# Change ownership of workspace
RUN chown -R curluser:curluser /workspace

# Switch to non-root user
USER curluser

# Set default command
CMD ["/bin/bash"]
