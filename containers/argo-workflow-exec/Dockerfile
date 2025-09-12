# Use Alpine Linux as base image for Argo Workflows Executor
FROM alpine:3.18

# Set environment variables
ENV ARGO_VERSION=v3.5.2
ENV KUBECTL_VERSION=v1.28.0
ENV YQ_VERSION=v4.35.1

# Install essential packages
RUN apk add --no-cache \
    curl \
    wget \
    git \
    bash \
    jq \
    yaml-cpp \
    ca-certificates \
    && rm -rf /var/cache/apk/*

# Install Argo Workflows CLI
RUN wget -O /usr/local/bin/argo https://github.com/argoproj/argo-workflows/releases/download/${ARGO_VERSION}/argo-linux-amd64 \
    && chmod +x /usr/local/bin/argo

# Install kubectl
RUN wget -O /usr/local/bin/kubectl https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    && chmod +x /usr/local/bin/kubectl

# Install yq for YAML processing
RUN wget -O /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 \
    && chmod +x /usr/local/bin/yq

# Create working directory
WORKDIR /workspace

# Create a non-root user
RUN addgroup -g 1001 -S argo && \
    adduser -u 1001 -S argo -G argo

# Change ownership of workspace
RUN chown -R argo:argo /workspace

# Switch to non-root user
USER argo

# Set default command
CMD ["/bin/bash"]
