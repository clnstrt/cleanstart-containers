FROM cleanstart/busybox:latest-dev

# Copy the script and data file
COPY start.sh /usr/local/bin/busybox.sh
COPY data.json /work/data.json

# Run the script by default using sh to ensure it's executable
ENTRYPOINT ["sh", "/usr/local/bin/busybox.sh"]
