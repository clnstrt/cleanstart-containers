# CleanStart Containers

This directory contains Docker container images and their sample projects. Each container includes practical examples, setup scripts, and detailed documentation to help you learn and implement containerized solutions.

## Available Containers

| Container | Description | Sample Projects |
|-----------|-------------|-----------------|
| **Go** | Modern programming language | Web applications, microservices |
| **Node.js** | JavaScript runtime | Express.js web apps, APIs |
| **Python** | High-level programming language | Flask/Django web applications |
| **Nginx** | Web server and reverse proxy | Static sites, load balancing |
| **PostgreSQL** | Relational database | Database applications |
| **Prometheus** | Monitoring and alerting | Metrics collection |
| **MinIO Operator** | Object storage operator | Kubernetes operators |
| **Step CLI** | PKI and certificate management | Certificate authorities |

## Hello World Programs

Each container includes simple "Hello World" programs to get you started quickly.

### Available Languages

- **Python**: `hello_world.py`
- **Go**: `hello_world.go`
- **Node.js**: `hello_world.js`

## How to Run Sample Projects

### Using Docker (Recommended)
```bash
# Navigate to any container directory
cd containers/go/sample-project

# Build and run the sample project
docker build -t go-sample .
docker run --rm go-sample
```

### Using Docker Compose
```bash
# Navigate to any sample project
cd containers/go/sample-project

# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### Direct Execution (if language is installed)
```bash
# Python
cd containers/python/sample-project
python3 hello_world.py

# Go
cd containers/go/sample-project
go run hello_world.go

# Node.js
cd containers/node/sample-project
node hello_world.js
```

## Features

Each sample project includes:
- **Hello World programs** - Simple examples to get started
- **Web applications** - Full-featured applications
- **Database integration** - Examples with PostgreSQL
- **Docker configurations** - Ready-to-use Dockerfiles
- **Kubernetes manifests** - Production deployment examples

## Prerequisites

- **Docker**: Docker installed and running
- **Docker Compose**: For multi-container applications
- **Basic command line knowledge**

## Quick Test with Docker

You can test all programs using Docker:

```bash
# Python
docker run --rm -v $(pwd)/containers/python/sample-project:/app -w /app python:3.9 python3 hello_world.py

# Go
docker run --rm -v $(pwd)/containers/go/sample-project:/app -w /app golang:1.19 go run hello_world.go

# Node.js
docker run --rm -v $(pwd)/containers/node/sample-project:/app -w /app node:16 node hello_world.js
```

## Getting Started

1. **Choose a container** that interests you
2. **Navigate to its directory** (`cd containers/[container-name]`)
3. **Read the README** for specific instructions
4. **Try the sample projects** to learn by doing
5. **Build your own applications** using the examples as templates

---

**Happy Containerizing! 🐳**
