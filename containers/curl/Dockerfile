# Use CleanStart base image for Curl Docker Image
FROM cleanstart/curl:latest-dev

# Set environment variables
ENV CURL_VERSION=8.4.0
ENV JQ_VERSION=1.7.1

# Create working directory
WORKDIR /workspace

# Change ownership of workspace
RUN chown -R curluser:curluser /workspace

# Switch to non-root user
USER curluser

# Set default command
CMD ["/bin/bash"]
