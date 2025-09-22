# Use the custom MinIO image
FROM cleanstart/minio:latest-dev

# Set working directory
WORKDIR /app

# Copy demo.sh into the image
COPY demo.sh /app/demo.sh

# Run the script with sh (no chmod needed)
ENTRYPOINT ["/app/demo.sh"]
