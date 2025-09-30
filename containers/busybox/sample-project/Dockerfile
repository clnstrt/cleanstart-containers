FROM busybox:unstable-uclibc

# Copy the script
COPY start.sh /usr/local/bin/busybox.sh

# Give execution permission
RUN chmod +x /usr/local/bin/busybox.sh

# Run the script by default
ENTRYPOINT ["/usr/local/bin/busybox.sh"]
