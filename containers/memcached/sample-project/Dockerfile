FROM cleanstart/memcached:latest-dev

# Use root user for the minimal image
USER root

# Expose memcached port
EXPOSE 11211

# Start memcached with verbose logging as root
CMD ["memcached", "-m", "128", "-p", "11211", "-u", "root", "-l", "0.0.0.0", "-vv"]
