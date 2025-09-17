FROM cleanstart/busybox:latest-dev

# Switch to root to copy and chmod
USER root

# Copy the script
COPY start.sh /usr/local/bin/busybox.sh

# Give execution permission
RUN chmod +x /usr/local/bin/busybox.sh

# Switch back to the original user
USER clnstrt

# Run the script by default
ENTRYPOINT ["/usr/local/bin/busybox.sh"]
