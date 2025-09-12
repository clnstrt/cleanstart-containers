FROM amazon/aws-cli:latest

# Set working directory
WORKDIR /aws

# Create a non-root user
RUN addgroup -g 1001 -S awsuser && \
    adduser -u 1001 -S awsuser -G awsuser

# Create necessary directories
RUN mkdir -p /aws/config /aws/scripts /aws/data && \
    chown -R awsuser:awsuser /aws

# Switch to non-root user
USER awsuser

# Set AWS CLI configuration directory
ENV AWS_CONFIG_FILE=/aws/config/config
ENV AWS_SHARED_CREDENTIALS_FILE=/aws/config/credentials

# Expose port 9000 (if needed for web interface)
EXPOSE 9000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD aws --version || exit 1

# Default command
CMD ["aws", "--version"]
