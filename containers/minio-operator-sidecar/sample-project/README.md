# 🚀 Hello from Minio-Operator-Sidecar!!! 

A simple program to run on CleanStart - MinIO Operator Sidecar container. 

### Pull CleanStart MinIO Operator Sidecar image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart) 
```bash
docker pull cleanstart/minio-operator-sidecar:latest
```
```bash
docker pull cleanstart/minio-operator-sidecar:latest-dev
```

##Build with Dockerfile and run basic verification of Minio Operator sidecar
## Output 
```bash
FROM cleanstart/minio-operator-sidecar:latest-dev

# Switch to root temporarily
USER root

# Update and install only lightweight tools available in custom repo
RUN apk update && apk add --no-cache bash curl


# Switch back to the non-root user already defined in base
USER clnstrt

# Default to bash shell for debugging
ENTRYPOINT ["/minio-operator-sidecar"]
```
## Docker build command 
```bash
docker build --no-cache -t my-minio-sidecar-debug .
```
## Docker run command
```bash
docker run -it --rm my-minio-sidecar-debug
```

## Output
```bash
NAME:
 minio-operator-sidecar - MinIO Operator Sidecar

DESCRIPTION:
 MinIO Operator automates the orchestration of MinIO Tenants on Kubernetes.

USAGE:
 minio-operator-sidecar [FLAGS] COMMAND [ARGS...]

COMMANDS:
 sidecar, s   Start MinIO Operator Sidecar
 validate, v  Start MinIO Operator Config Validator
 
FLAGS:
 --help, -h     show help
 --version, -v  print the version
 
VERSION:
 (dev) - (dev)
```

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [MinIO Official Documentation](https://docs.min.io/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).