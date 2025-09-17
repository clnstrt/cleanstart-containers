# CleanStart Containers

A comprehensive collection of Docker container images and sample projects for learning containerization, web development, and DevOps practices. Each container includes practical examples, setup scripts, and detailed documentation to help you learn and implement containerized solutions.

## 🚀 Quick Start

### Prerequisites
- Docker installed and running
- Basic command line knowledge

### Available Containers

| Container | Description | Port | Sample Project |
|-----------|-------------|------|----------------|
| **Go** | Modern programming language | 8080 | Web application with database |
| **Node.js** | JavaScript runtime | 3000 | Express.js web app |
| **Python** | High-level programming language | 5000 | Flask web application |
| **Nginx** | Web server and reverse proxy | 80/8080 | Static site, reverse proxy, load balancer |
| **PostgreSQL** | Relational database | 5432 | Database web application |
| **Prometheus** | Monitoring and alerting | 9090 | Metrics collection and visualization |
| **MinIO Operator** | Object storage operator | - | Kubernetes operator examples |
| **Step CLI** | PKI and certificate management | - | Certificate authority examples |

## 🎯 Getting Started

### 1. Clone the Repository
```bash
git clone https://github.com/your-username/cleanstart-containers.git
cd cleanstart-containers
```

### 2. Pull a Container Image
```bash
# Example: Pull the Go container
docker pull cleanstart/go:latest
```

### 3. Run a Container
```bash
# Example: Run Go container interactively
docker run -it --rm cleanstart/go:latest
```

### 4. Try Sample Projects
```bash
# Navigate to sample projects
cd containers/go/sample-project

# Run hello world example
cd hello-world
docker build -t go-hello-world .
docker run --rm go-hello-world
```

## 📁 Project Structure for the cleanstart-containers repo
```
cleanstart-containers/
├── LICENSE                           # MIT License
├── README.md                         # This file
└── containers/                      # All container sample projects
    ├── step-cli/                    # 🔐 PKI & Certificate Management
    │   ├── Dockerfile
    │   ├── README.md
    │   └── sample-project/
    ├── nginx/                       # 🌐 Web Server & Load Balancing
    ├── python/                      # 🐍 Python Web Applications
    ├── node/                        # 🟢 Node.js Applications
    ├── go/                          # 🐹 Go Web Applications
    ├── postgres/                    # 🗄️ PostgreSQL Database
    ├── prometheus/                  # 📊 Monitoring and Alerting
    ├── minio-operator-sidecar/      # 🗃️ Object Storage Operator
    └── [more containers...]
```

## 🛠️ Development

### Building Images
```bash
# Build a specific container
cd containers/go
docker build -t cleanstart/go:latest .
```

### Running Sample Projects
```bash
# Navigate to any sample project
cd containers/go/sample-project/go-web

# Build and run
docker build -t go-web-app .
docker run -p 8080:8080 go-web-app
```

### Using Docker Compose
```bash
# Navigate to any sample project
cd containers/[container-name]/sample-project

# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

## 🧪 Testing Your Setup

### Health Checks
```bash
# Check if services are running
docker-compose ps

# Test web endpoints
curl http://localhost:8080/health

# View service logs
docker-compose logs -f [service-name]
```

### Common Test Commands
```bash
# Test Docker installation
docker --version
docker-compose --version

# Test container functionality
docker run --rm cleanstart/[container-name] --version
```

## 🛠️ Troubleshooting

### Common Issues:

1. **Port Conflicts**
   ```bash
   # Check what's using a port
   lsof -i :8080  # macOS/Linux
   netstat -ano | findstr :8080  # Windows
   
   # Kill the process
   kill -9 <PID>  # macOS/Linux
   taskkill /PID <PID> /F  # Windows
   ```

2. **Permission Issues**
   ```bash
   # Make scripts executable
   chmod +x setup.sh
   chmod +x test-setup.sh
   ```

3. **Docker Issues**
   ```bash
   # Restart Docker
   sudo systemctl restart docker  # Linux
   # Or restart Docker Desktop on macOS/Windows
   
   # Clean up containers
   docker-compose down
   docker system prune -f
   ```

## 📚 Documentation

Each sample project includes:
- **Detailed README** - Complete setup and usage instructions
- **Setup Scripts** - Automated environment setup
- **Docker Compose** - Multi-container orchestration
- **Example Code** - Working code examples
- **Test Scripts** - Validation and testing tools

## 🤝 Contributing

We welcome contributions to improve these sample projects:

## 🆘 Support

If you encounter issues or need help:

1. **Check the troubleshooting section above**
2. **Review the individual project READMEs**
3. **Check the project logs for specific errors**
4. **Open an issue on GitHub with detailed information**

---

**Happy Containerizing! 🐳**
