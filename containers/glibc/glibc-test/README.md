### Quick Start 

Run and check the program for Glibc Docker iamage with the Dockerfile!

## Step 1
Build with Dockerfile
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

## Step 2
Build the Dockerfile
```bash
docker build --no-cache -t my-glibc .
```

## Step 3
Run the Dockerfile
```bash
docker run --rm my-glibc
```
Now you can see Glibc program output!!
