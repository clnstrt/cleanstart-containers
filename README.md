<<<<<<< HEAD
#  CleanStart Containers - Sample Projects

A comprehensive collection of Docker container sample projects demonstrating various technologies, tools, and frameworks. Each container includes practical examples, setup scripts, and detailed documentation to help you learn and implement containerized solutions.

##  What You'll Find

This repository contains **20+ container sample projects** covering:

- **🔐 Security & PKI**: Step CLI, Certificate Management
- **⚖️ Load Balancing**: MetalLB Controller, Nginx
- **☁️ Cloud & DevOps**: AWS CLI, ArgoCD, Velero
- **📊 Monitoring**: cAdvisor, Logstash Exporter
- **🗄️ Databases**: PostgreSQL, Database Examples
- **🌐 Web Technologies**: Node.js, Python, Ruby, Go, Java
- **🔧 Utilities**: BusyBox, cURL, kube-proxy

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/your-username/cleanstart-containers.git
cd cleanstart-containers
```

### 2. Choose Your Sample Project
```bash
# Navigate to any container directory
cd images/step-cli/sample-project          # PKI & Certificate Management
cd images/metallb-controller/sample-project # Load Balancer Management
cd images/nginx/sample-project             # Web Server & Load Balancing
cd images/python/sample-project            # Python Web Applications
cd images/node/sample-project              # Node.js Applications
# ... and many more!
```

### 3. Run the Sample Project
```bash
# Use Docker Compose
docker-compose up -d
```

## 📁 Project Structure

```
cleanstart-containers/
├── LICENSE                           # MIT License
├── README.md                         # This file
└── images/                          # All container sample projects
    ├── step-cli/                    # 🔐 PKI & Certificate Management
    │   ├── Dockerfile
    │   ├── README.md
    │   └── sample-project/
    │       ├── basic-pki/           # Basic PKI operations
    │       ├── advanced-certificates/ # Advanced certificate management
    │       ├── production-pki/      # Production-ready PKI setup
    │       └── integration-examples/ # Integration examples
    ├── metallb-controller/          # ⚖️ Load Balancer Management
    │   ├── Dockerfile
    │   ├── README.md
    │   └── sample-project/
    │       ├── basic-layer2/        # Basic Layer 2 load balancing
    │       ├── bgp-setup/           # BGP-based load balancing
    │       └── multi-pool/          # Multi-pool configuration
    ├── nginx/                       # 🌐 Web Server & Load Balancing
    ├── python/                      # 🐍 Python Web Applications
    ├── node/                        # 🟢 Node.js Applications
    ├── ruby/                        # 💎 Ruby Web Applications
    ├── go/                          # 🐹 Go Web Applications
    ├── java/                        # ☕ Java Applications
    ├── postgres/                    # 🗄️ PostgreSQL Database
    ├── aws-cli/                     # ☁️ AWS Cloud Operations
    ├── argocd-extension-installer/  # 🚀 ArgoCD Extensions
    ├── velero-plugin-for-aws/       # 💾 Backup & Disaster Recovery
    ├── cAdvisor/                    # 📊 Container Monitoring
    ├── logstash-exporter/           # 📈 Log Monitoring
    ├── minio/                       # 🗃️ Object Storage
    ├── curl/                        # 🔧 HTTP Client Utilities
    ├── busybox/                     # 🛠️ Lightweight Utilities
    └── [15+ more containers...]
```

## 🚀 Getting Started with Any Project

### **Option 1: Automated Setup (Recommended)**
```bash
# Navigate to any sample project
cd images/[container-name]/sample-project

# Run the setup script
./setup.sh        # Linux/macOS
setup.bat         # Windows
```

### **Option 2: Docker Compose**
```bash
# Navigate to any sample project
cd images/[container-name]/sample-project

# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### **Option 3: Manual Setup**
```bash
# Build the container
docker build -t my-container .

# Run the container
docker run -p 8080:8080 my-container
```

## 🧪 Testing Your Setup

### **Health Checks**
```bash
# Check if services are running
docker-compose ps

# Test web endpoints
curl http://localhost:8080/health

# View service logs
docker-compose logs -f [service-name]
```

### **Common Test Commands**
```bash
# Test Docker installation
docker --version
docker-compose --version

# Test container functionality
docker run --rm cleanstart/[container-name] --version

# Test sample project
cd images/[container-name]/sample-project
./test-setup.sh
```

## 🛠️ Troubleshooting

### **Common Issues:**

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

4. **Dependencies Missing**
   ```bash
   # Install required tools
   # Check individual project READMEs for specific requirements
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

1. **Add new sample projects** - Create new container examples
2. **Improve existing projects** - Enhance documentation and examples
3. **Fix bugs and issues** - Report and fix problems
4. **Add new features** - Extend functionality
5. **Improve documentation** - Better explanations and guides

### **How to Contribute:**
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

If you encounter issues or need help:

1. **Check the troubleshooting section above**
2. **Review the individual project READMEs**
3. **Check the project logs for specific errors**
4. **Open an issue on GitHub with detailed information**

---
Start with any sample project that interests you, follow the setup instructions, and begin building amazing containerized applications!
=======
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
>>>>>>> pratham-dev
