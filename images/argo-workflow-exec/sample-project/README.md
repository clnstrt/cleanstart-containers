# ⚡ Argo Workflows Sample Projects

This directory contains sample projects for testing the `cleanstart/argo-workflow-exec` Docker image that you already pulled from Docker Hub. These examples demonstrate Argo Workflows for workflow automation, CI/CD pipelines, and data processing.

## 🚀 Quick Start

### Prerequisites
- Docker installed and running
- Kubernetes cluster (optional for local testing)

### Setup
```bash
# Navigate to this directory
cd images/argo-workflow-exec/sample-project

# Test the image (you already pulled cleanstart/argo-workflow-exec:latest from Docker Hub)
docker run --rm cleanstart/argo-workflow-exec:latest argoexec version
```

### Run Examples

#### Basic Workflows
```bash
# Hello World workflow
docker run --rm -v $(pwd):/workspace cleanstart/argo-workflow-exec:latest \
  cat /workspace/basic-workflows/hello-world.yaml

# Parallel tasks workflow
docker run --rm -v $(pwd):/workspace cleanstart/argo-workflow-exec:latest \
  cat /workspace/basic-workflows/parallel-tasks.yaml

# Conditional workflow
docker run --rm -v $(pwd):/workspace cleanstart/argo-workflow-exec:latest \
  cat /workspace/basic-workflows/conditional.yaml
```

#### Advanced Workflows
```bash
# CI/CD pipeline
docker run --rm -v $(pwd):/workspace cleanstart/argo-workflow-exec:latest \
  cat /workspace/advanced-workflows/ci-cd-pipeline.yaml

# Data processing workflow
docker run --rm -v $(pwd):/workspace cleanstart/argo-workflow-exec:latest \
  cat /workspace/advanced-workflows/data-processing.yaml
```

#### Using Docker Compose
```bash
# Start development environment
docker-compose --profile development up -d

# Run tests
docker-compose --profile testing up

# Interactive mode
docker-compose --profile interactive up
```

## 📁 Project Structure

```
sample-project/
├── README.md                    # This file
├── docker-compose.yml           # Docker Compose configuration
├── basic-workflows/            # Simple workflow examples
│   ├── hello-world.yaml        # Basic hello world
│   ├── parallel-tasks.yaml     # Parallel execution
│   └── conditional.yaml        # Conditional logic
├── advanced-workflows/         # Complex workflows
│   ├── ci-cd-pipeline.yaml     # CI/CD pipeline
│   └── data-processing.yaml    # Data processing
├── scripts/                    # Helper scripts
│   ├── setup.sh               # Setup script
│   ├── monitor.sh             # Monitoring script
│   └── cleanup.sh             # Cleanup script
├── tests/                     # Test workflows
│   └── smoke-test.yaml        # Smoke test
└── demo-summary.md            # Test results
```

## 🎯 Features

- Basic workflow templates (hello world, parallel tasks, conditional logic)
- Advanced workflows (CI/CD pipelines, data processing)
- Resource management and limits
- Parameter passing and environment variables
- Artifact management
- Error handling and retries
- Monitoring and logging

## 📊 Output

Workflow outputs are stored in:
- Workflow logs and status
- Generated artifacts
- Test results in `demo-summary.md`

## 🤝 Contributing

To add new workflows:
1. Create YAML file in appropriate directory
2. Add documentation
3. Test with Argo Workflows
