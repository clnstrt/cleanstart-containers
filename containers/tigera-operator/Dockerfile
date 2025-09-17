# Tigera Operator Dockerfile
# This container provides Tigera Operator for managing Calico networking and security

# Use Alpine Linux as base image for security and size
FROM alpine:3.18

# Set metadata
LABEL maintainer="CleanStart Team <support@cleanstart.com>"
LABEL description="Tigera Operator for Calico networking and security management"
LABEL version="1.0.0"

# Set environment variables
ENV TIGERA_OPERATOR_VERSION=v1.35.0
ENV CALICO_VERSION=v3.26.4
ENV KUBECTL_VERSION=v1.28.0

# Install required packages
RUN apk add --no-cache \
    curl \
    wget \
    bash \
    jq \
    yq \
    ca-certificates \
    && rm -rf /var/cache/apk/*

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/

# Install Tigera Operator
RUN curl -L "https://github.com/tigera/operator/releases/download/${TIGERA_OPERATOR_VERSION}/tigera-operator.yaml" -o /tmp/tigera-operator.yaml

# Create working directory
WORKDIR /app

# Copy operator configuration files
COPY operator-config.yaml /app/
COPY calico-config.yaml /app/

# Create non-root user for security
RUN adduser -D -s /bin/bash operator
USER operator

# Set default command
CMD ["bash", "-c", "echo 'Tigera Operator container ready. Use kubectl to apply configurations.' && tail -f /dev/null"]
