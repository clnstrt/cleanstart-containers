# Start with the prometheus base image
FROM cleanstart/prometheus:latest-dev

# Set the working directory
WORKDIR /etc/prometheus

# Switch to the root user to gain the necessary permissions
USER root

# Create the data directory and set permissions
# This command will now succeed because it's run by the root user
RUN mkdir -p /etc/prometheus/data && \
    chown -R prometheus:prometheus /etc/prometheus/data

# Switch back to the prometheus user for security best practices
USER prometheus

# Copy your prometheus configuration file
# This command is now safe to run as the prometheus user
COPY --chown=prometheus:prometheus prometheus.yml /etc/prometheus/prometheus.yml
