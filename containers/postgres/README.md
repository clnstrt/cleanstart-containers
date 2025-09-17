# 🐘 CleanStart PostgreSQL Container

Official PostgreSQL database container image optimized for enterprise environments with CleanStart security standards.

## 🚀 Quick Start

### Pull Images
```bash
docker pull cleanstart/postgres:latest
docker pull cleanstart/postgres:latest-dev
```

### Run Container
```bash
# Start PostgreSQL server
docker run --rm -it --name postgres-db cleanstart/postgres:latest

# Interactive development
docker run --rm -it --entrypoint /bin/sh cleanstart/postgres:latest-dev
```

### Sample Project
```bash
# Navigate to sample project
cd sample-project/

# Run complete web application
docker-compose up --build -d

# Access web interface
# http://localhost:5000
# http://localhost:5000/users
# http://localhost:5000/add_user
```

## 🌟 Features

- **Complete PostgreSQL Environment**: Server, client tools, and utilities
- **Security Hardened**: Minimal attack surface with FIPS-compliant crypto
- **Cloud Native**: Optimized for microservices and container orchestration
- **Multi-Platform**: Supports linux/amd64 and linux/arm64

## 🏗️ Architecture Support

```bash
# AMD64
docker pull --platform linux/amd64 cleanstart/postgres:latest

# ARM64
docker pull --platform linux/arm64 cleanstart/postgres:latest
```

## 📚 Resources

- **CleanStart Website**: https://www.cleanstart.com
- **Docker Hub**: https://hub.docker.com/r/cleanstart/postgres
- **PostgreSQL Documentation**: https://www.postgresql.org/docs/

## 🔒 Best Practices

- Use specific image tags for production (avoid `latest`)
- Configure resource limits: memory and CPU constraints
- Enable read-only root filesystem when possible
- Use environment variables for database configuration