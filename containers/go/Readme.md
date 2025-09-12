CleanStart Container for Go

Official Go programming language container image optimized for enterprise environments. Includes the complete Go development toolkit, compiler, and runtime environment. Features security-hardened base image, minimal attack surface, and FIPS-compliant cryptographic modules. Supports both production deployments and development workflows with separate tagged versions. Includes standard Go tools like go test, go fmt, and go mod for dependency management.

Key Features

Complete Go development environment with compiler and standard library
Optimized for cloud-native and microservices architectures
Common Use Cases

Building and deploying Go microservices
Cloud-native application development
Quick Start

Link to DockerHub
https://hub.docker.com/r/cleanstart/go

Pull Commands Download the runtime container images

docker pull cleanstart/go:latest
docker pull cleanstart/go:latest-dev
Interactive Development Start interactive session for development

docker run --rm -it --entrypoint /bin/sh cleanstart/go:latest-dev
Container Start Start the container

docker run --rm -it --name go-web-dev cleanstart/go:latest
Best Practices

Use specific image tags for production (avoid latest)
Configure resource limits: memory and CPU constraints
Enable read-only root filesystem when possible
Architecture Support

Multi-Platform Images

docker pull --platform linux/amd64 cleanstart/go:latest
docker pull --platform linux/arm64 cleanstart/go:latest
Resources & Documentation

Essential Links

CleanStart Website: https://www.cleanstart.com
Go Official: https://go.dev/