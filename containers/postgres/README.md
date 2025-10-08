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

**Reference:**

CleanStart Community Images: https://hub.docker.com/u/cleanstart 

Get more from CleanStart images from https://github.com/clnstrt/cleanstart-containers/tree/main/containers⁠, 

  -  how-to-Run sample projects using dockerfile 
  -  how-to-Deploy via Kubernete YAML 
  -  how-to-Migrate from public images to CleanStart images

---

# Vulnerability Disclaimer

CleanStart offers Docker images that include third-party open-source libraries and packages maintained by independent contributors. While CleanStart maintains these images and applies industry-standard security practices, it cannot guarantee the security or integrity of upstream components beyond its control.

Users acknowledge and agree that open-source software may contain undiscovered vulnerabilities or introduce new risks through updates. CleanStart shall not be liable for security issues originating from third-party libraries, including but not limited to zero-day exploits, supply chain attacks, or contributor-introduced risks.

Security remains a shared responsibility: CleanStart provides updated images and guidance where possible, while users are responsible for evaluating deployments and implementing appropriate controls.