# 🚀 Argo Workflows Executor Docker Image

A comprehensive Docker image for Argo Workflows execution, management, and development. This image provides the Argo Workflows CLI, kubectl, and essential tools for working with Argo Workflows in Kubernetes environments.

## 📚 What is Argo Workflows?

**Argo Workflows** is an open-source container-native workflow engine for orchestrating parallel jobs on Kubernetes. It provides:
- **Workflow Orchestration** - Define complex workflows as Kubernetes resources
- **Parallel Processing** - Execute multiple tasks simultaneously
- **Conditional Logic** - Implement if/then/else workflows
- **Artifact Management** - Handle data between workflow steps
- **Retry Mechanisms** - Automatic retry with backoff strategies
- **Monitoring & Visualization** - Web UI for workflow monitoring

## 🎯 What This Image Provides

### **Core Tools**
- **Argo Workflows CLI** - Command-line interface for workflow management
- **kubectl** - Kubernetes command-line tool
- **yq** - YAML processor for workflow templates
- **jq** - JSON processor for workflow outputs

### **Development Tools**
- **Git** - Version control for workflow definitions
- **curl/wget** - HTTP client for API interactions
- **bash** - Shell environment for scripting

## 🚀 Quick Start

### Pull the Image
```bash
docker pull cleanstart/argo-workflow-exec:latest
```

### Run Interactive Shell
```bash
docker run -it --rm cleanstart/argo-workflow-exec:latest
```

### Run with Volume Mount
```bash
docker run -it --rm -v $(pwd):/workspace cleanstart/argo-workflow-exec:latest
```

## 💻 Basic Usage Examples

### 1. Check Argo Workflows Version
```bash
docker run --rm cleanstart/argo-workflow-exec:latest argo version
```

### 2. List Workflows
```bash
docker run --rm -v ~/.kube:/home/argo/.kube cleanstart/argo-workflow-exec:latest argo list
```

### 3. Submit a Workflow
```bash
docker run --rm -v ~/.kube:/home/argo/.kube -v $(pwd):/workspace cleanstart/argo-workflow-exec:latest argo submit workflow.yaml
```

### 4. Get Workflow Status
```bash
docker run --rm -v ~/.kube:/home/argo/.kube cleanstart/argo-workflow-exec:latest argo get @latest
```

## 🔧 Advanced Usage

### 1. Workflow Development
```bash
# Start development container
docker run -it --rm \
  -v ~/.kube:/home/argo/.kube \
  -v $(pwd):/workspace \
  cleanstart/argo-workflow-exec:latest

# Inside container
argo submit hello-world.yaml
argo watch @latest
argo logs @latest
```

### 2. Workflow Template Management
```bash
# Submit workflow template
argo template submit template.yaml

# List templates
argo template list

# Get template details
argo template get my-template
```

### 3. Artifact Management
```bash
# Download artifacts
argo get @latest --output artifacts

# Upload artifacts
argo artifacts upload @latest my-artifact /path/to/file
```

## 📁 Sample Projects

### Basic Workflow Examples
- **Hello World** - Simple workflow with single step
- **Parallel Processing** - Multiple tasks running simultaneously
- **Conditional Workflows** - If/then/else logic examples
- **Artifact Handling** - Data passing between steps

### Advanced Examples
- **CI/CD Pipeline** - Complete deployment workflow
- **Data Processing** - ETL workflow with multiple stages
- **Machine Learning** - ML training and inference pipeline
- **Monitoring** - Health checks and alerting workflows

## 🔒 Security Features

- **Non-root User** - Runs as `argo` user (UID 1001)
- **Minimal Base Image** - Alpine Linux for reduced attack surface
- **Certificate Validation** - Proper CA certificates for secure connections
- **Resource Limits** - Configurable CPU and memory limits

## 🌐 Integration Examples

### Kubernetes Integration
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: argo-executor
spec:
  containers:
  - name: argo
    image: cleanstart/argo-workflow-exec:latest
    command: ["argo", "submit", "/workspace/workflow.yaml"]
    volumeMounts:
    - name: kubeconfig
      mountPath: /home/argo/.kube
    - name: workflows
      mountPath: /workspace
  volumes:
  - name: kubeconfig
    secret:
      secretName: kubeconfig
  - name: workflows
    configMap:
      name: workflow-definitions
```

### Docker Compose
```yaml
version: '3.8'
services:
  argo-executor:
    image: cleanstart/argo-workflow-exec:latest
    container_name: argo-executor
    volumes:
      - ~/.kube:/home/argo/.kube
      - ./workflows:/workspace
    environment:
      - KUBECONFIG=/home/argo/.kube/config
    command: ["tail", "-f", "/dev/null"]
```

## 🧪 Testing

### Verify Installation
```bash
# Test Argo CLI
docker run --rm cleanstart/argo-workflow-exec:latest argo version

# Test kubectl
docker run --rm cleanstart/argo-workflow-exec:latest kubectl version --client

# Test yq
docker run --rm cleanstart/argo-workflow-exec:latest yq --version
```

### Run Sample Workflow
```bash
# Start container with sample workflow
docker run -it --rm \
  -v ~/.kube:/home/argo/.kube \
  -v $(pwd)/sample-project:/workspace \
  cleanstart/argo-workflow-exec:latest

# Submit and monitor workflow
argo submit hello-world.yaml
argo watch @latest
```

## 📊 Monitoring & Debugging

### Workflow Monitoring
```bash
# Watch workflow in real-time
argo watch @latest

# Get detailed logs
argo logs @latest

# Get workflow status
argo get @latest -o yaml
```

### Debugging Tools
```bash
# Check workflow events
argo get @latest --events

# Get pod logs
argo logs @latest -c main

# Describe workflow
argo describe @latest
```

## 🔄 Version Information

- **Argo Workflows**: v3.4.8
- **kubectl**: v1.28.0
- **yq**: v4.35.1
- **Base Image**: Alpine Linux 3.18

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

For support and questions:
- **GitHub Issues**: Create an issue in the repository
- **Documentation**: Check the Argo Workflows official docs
- **Community**: Join the Argo Workflows Slack channel
