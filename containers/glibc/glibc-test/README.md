## Quick start to Project 

## Build with Dockerfile
```bash
FROM cleanstart/glibc:latest-dev

# Set a safe working directory
WORKDIR /workspace

# Copy source code
COPY app.c .

# Compile
RUN gcc app.c -o app

# Run program
CMD ["./app"]
```

## Build and Run with the commands
```bash
docker build --no-cache -t my-glibc .
```
```bash
docker run --rm my-glibc
```
