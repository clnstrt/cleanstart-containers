# Go Docker Image

A modern, efficient programming language with built-in concurrency and garbage collection.

## Pull Image
```bash
docker pull cleanstart/go:latest
```

## Run Container
```bash
# Interactive run
docker run -it --rm cleanstart/go:latest

# Run with volume mount
docker run -it --rm -v $(pwd):/app -w /app cleanstart/go:latest

# Run Go program
docker run --rm -v $(pwd):/app -w /app cleanstart/go:latest go run hello_world.go
```

## Check Version
```bash
docker run --rm cleanstart/go:latest go version
```

## Check Image Size
```bash
docker images cleanstart/go:latest
```

## Test Container
```bash
# Test Go installation
docker run --rm cleanstart/go:latest go version

# Run hello world
docker run --rm cleanstart/go:latest go run hello_world.go
```

## Sample Projects
For detailed usage examples and demonstrations, see the `sample-project/` directory.
