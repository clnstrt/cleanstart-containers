FROM cleanstart/argo-workflow-exec:latest-dev

# Switch to root to copy and set up the test script
USER root

# Copy the test script
COPY test-argoexec.sh /test-argoexec.sh

# Make the script executable and set proper permissions
RUN chmod +x /test-argoexec.sh

# Verify the base image has argoexec
RUN which argoexec || echo "Warning: argoexec not found in base image"

# Switch back to the non-root user
USER clnstrt

# Clear entrypoint to use our custom command
ENTRYPOINT []

# Run the test script
CMD ["/test-argoexec.sh"]