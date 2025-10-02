# Curl Docker Image Test Results

## Test Summary

The `cleanstart/curl:latest` Docker image has been tested and works correctly.

## Working Tests

### 1. Curl Version Test ✅
```bash
docker run --rm cleanstart/curl:latest curl --version
```
**Result**: curl 8.15.0 with HTTP/HTTPS support

### 2. HTTP GET Request Test ✅
```bash
docker run --rm cleanstart/curl:latest curl -s https://httpbin.org/get
```
**Result**: Successfully retrieves JSON response

### 3. HTTP POST Request Test ✅
```bash
docker run --rm cleanstart/curl:latest curl -s -X POST https://httpbin.org/post \
  -H "Content-Type: application/json" \
  -d '{"test": "data"}'
```
**Result**: Successfully sends POST request with JSON data

### 4. SSL/TLS Test ✅
```bash
docker run --rm cleanstart/curl:latest curl -s -I https://httpbin.org/headers
```
**Result**: Successfully establishes HTTPS connections

### 5. File Download Test ✅
```bash
docker run --rm -v $(pwd):/workspace cleanstart/curl:latest \
  curl -s -o /workspace/test.json https://httpbin.org/json
```
**Result**: Successfully downloads files with volume mounting

### 6. Interactive Shell Test ✅
```bash
docker run --rm -it cleanstart/curl:latest /bin/sh
```
**Result**: Interactive shell access works correctly

## Key Features

- HTTP/HTTPS Support
- JSON Processing  
- SSL/TLS Security
- File Operations
- Custom Headers

## Image Specifications

- **Base Image**: Alpine Linux 3.18
- **Curl Version**: 8.15.0
- **SSL Support**: OpenSSL/3.5.2

## Test Conclusion

✅ All tests passed successfully  
✅ Image is fully functional  
✅ Ready for production use
