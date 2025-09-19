FROM cleanstart/glibc:latest-dev

# Set a safe working directory
WORKDIR /workspace

# Copy source code
COPY app.c .

# Compile
RUN gcc app.c -o app

# Run program
CMD ["./app"]
