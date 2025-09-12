# Use Alpine Linux as base image for Curl Docker Image
FROM alpine:3.18

# Set environment variables
ENV CURL_VERSION=8.4.0
ENV JQ_VERSION=1.7.1

# Install essential packages
RUN apk add --no-cache \
    curl \
    wget \
    jq \
    bash \
    git \
    ca-certificates \
    openssl \
    && rm -rf /var/cache/apk/*

# Create working directory
WORKDIR /workspace

# Create a non-root user
RUN addgroup -g 1001 -S curluser && \
    adduser -u 1001 -S curluser -G curluser

# Change ownership of workspace
RUN chown -R curluser:curluser /workspace

# Switch to non-root user
USER curluser

# Set default command
CMD ["/bin/bash"]
