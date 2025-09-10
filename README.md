# CleanStart Containers

A collection of Docker container images and sample projects for learning containerization, web development, and DevOps practices.

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

### 1. Pull a Container Image
```bash
# Example: Pull the Go container
docker pull cleanstart/go:latest
```

### 2. Run a Container
```bash
# Example: Run Go container interactively
docker run -it --rm cleanstart/go:latest
```

### 3. Try Sample Projects
```bash
# Navigate to sample projects
cd containers/go/sample-project

# Run hello world example
cd hello-world
docker build -t go-hello-world .
docker run --rm go-hello-world
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

## 📚 Learning Path

### Beginner
1. Start with hello-world examples
2. Learn basic Docker commands
3. Understand container concepts

### Intermediate
1. Explore sample projects
2. Learn about Docker Compose
3. Understand networking and volumes

### Advanced
1. Kubernetes deployments
2. Production configurations
3. Monitoring and logging

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Add your container or sample project
4. Update documentation
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- Check the troubleshooting sections in individual README files
- Open an issue for bugs or feature requests
- Join our community discussions

---

**Happy Containerizing! 🐳**
