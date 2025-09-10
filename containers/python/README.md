# Python Docker Image

A high-level, interpreted programming language with dynamic semantics and built-in data structures.

## Pull Image
```bash
docker pull cleanstart/python:latest
```

## Run Container
```bash
# Interactive run
docker run -it --rm cleanstart/python:latest

# Run with volume mount
docker run -it --rm -v $(pwd):/app -w /app cleanstart/python:latest

# Run Python program
docker run --rm -v $(pwd):/app -w /app cleanstart/python:latest python hello_world.py
```

## Check Version
```bash
docker run --rm cleanstart/python:latest python --version
```

## Check Image Size
```bash
docker images cleanstart/python:latest
```

## Test Container
```bash
# Test Python installation
docker run --rm cleanstart/python:latest python --version

# Run hello world
docker run --rm cleanstart/python:latest python hello_world.py
```

## Sample Projects
For detailed usage examples and demonstrations, see the `sample-project/` directory.
