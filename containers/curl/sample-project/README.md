# 🌐 Curl Sample Projects

This directory contains sample projects for testing the `cleanstart/curl` Docker image that you already pulled from Docker Hub. These examples demonstrate curl use cases for HTTP requests, API testing, and web scraping.

## 🚀 Quick Start

### Prerequisites
- Docker installed and running
- Internet connectivity

### Setup
```bash
# Navigate to this directory
cd images/curl/sample-project

# Test the image (you already pulled cleanstart/curl:latest from Docker Hub)
docker run --rm cleanstart/curl:latest curl --version
```

### Run Examples

#### Basic HTTP Requests
```bash
# GET request
docker run --rm cleanstart/curl:latest curl -s https://httpbin.org/get

# POST request with JSON
docker run --rm cleanstart/curl:latest curl -s -X POST https://httpbin.org/post \
  -H "Content-Type: application/json" \
  -d '{"test": "data"}'
```

#### File Operations
```bash
# Download a file
docker run --rm -v $(pwd):/workspace cleanstart/curl:latest \
  curl -s -o /workspace/data/sample.json https://httpbin.org/json
```

#### SSL/TLS Testing
```bash
# Test SSL certificate
docker run --rm cleanstart/curl:latest curl -s -I https://google.com
```

#### API Testing
```bash
# Test API endpoints
docker run --rm cleanstart/curl:latest curl -s https://httpbin.org/get | jq .

# Test multiple endpoints
docker run --rm --entrypoint sh cleanstart/curl:latest-dev -c '
  for endpoint in /get /headers /user-agent /ip; do
    echo "Testing $endpoint"
    curl -s "https://httpbin.org$endpoint"
    echo ""
  done
'
```

#### Web Scraping
```bash
# Extract data with jq
docker run --rm --entrypoint sh cleanstart/curl:latest-dev -c '
  curl -s https://httpbin.org/json
' | jq -r '.slideshow.slides[].title'
```

#### Load Testing
```bash
# Simple load test
docker run --rm --entrypoint sh cleanstart/curl:latest-dev -c '
  i=1
  while [ $i -le 5 ]; do
    echo "Request $i:"
    time curl -s https://httpbin.org/delay/1 > /dev/null
    i=$((i + 1))
  done
'
```

## 📁 Project Structure

```
sample-project/
├── README.md                    # This file
├── docker-compose.yml           # Docker Compose configuration
├── basic-examples/             # Simple curl examples
│   ├── http-requests.sh        # Basic HTTP requests
│   ├── file-operations.sh      # File operations
│   └── ssl-testing.sh          # SSL/TLS testing
├── advanced-examples/          # Advanced examples
│   ├── api-automation.sh       # API automation
│   ├── web-scraping.sh         # Web scraping
│   └── load-testing.sh         # Load testing
├── scripts/                    # Helper scripts
│   ├── setup.sh               # Setup script
│   └── run-all-tests.sh       # Test runner
└── data/                      # Generated data
    └── scraped/               # Scraped content
```

## 🎯 Features

- HTTP/HTTPS requests (GET, POST, PUT, DELETE)
- File download and upload operations
- SSL/TLS certificate testing
- API testing and automation
- Web scraping and data extraction
- Load testing and performance analysis
- JSON processing with jq

## 📊 Output

All examples generate output in the `data/` directory:
- `data/` - Downloaded files
- `data/scraped/` - Web scraping results

## 🤝 Contributing

To add new examples:
1. Create script in appropriate directory
2. Add documentation
3. Test with Docker image
