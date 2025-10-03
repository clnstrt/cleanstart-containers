# Curl Sample Project

Simple examples for using the `cleanstart/curl` Docker image.

## Quick Test

```bash
# Check curl version
docker run --rm cleanstart/curl:latest curl --version

# Make a simple HTTP request
docker run --rm cleanstart/curl:latest curl -s https://httpbin.org/get
```

## Basic Examples

### 1. HTTP GET Request
```bash
docker run --rm cleanstart/curl:latest curl -s https://httpbin.org/get
```

### 2. HTTP POST Request
```bash
docker run --rm cleanstart/curl:latest curl -s -X POST https://httpbin.org/post \
  -H "Content-Type: application/json" \
  -d '{"test": "data"}'
```

### 3. Download a File
```bash
# Create local directory
mkdir -p ./data

# Download file
docker run --rm -v $(pwd)/data:/workspace cleanstart/curl:latest \
  curl -s -o /workspace/test.json https://httpbin.org/json

# Check downloaded file
ls -la ./data/
```

### 4. Interactive Mode
```bash
docker run --rm -it --entrypoint /bin/sh cleanstart/curl:latest
```

## Run All Tests

### Linux/Mac:
```bash
chmod +x test-all.sh
./test-all.sh
```

### Windows:
```cmd
run-tests.bat
```

## What's Inside

- `basic-examples/` - Simple curl scripts
  - `http-requests.sh` - Basic HTTP GET/POST examples
  - `file-operations.sh` - File download examples  
  - `ssl-testing.sh` - SSL/TLS connection tests
- `data/` - Directory for downloaded files (created when running scripts)
- `test-results.md` - Test verification results
- `test-all.sh` - Complete test suite (Linux/Mac)
- `run-tests.bat` - Test runner (Windows)
