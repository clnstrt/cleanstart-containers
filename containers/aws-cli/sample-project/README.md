# AWS CLI Sample Projects

This directory contains three comprehensive sample projects demonstrating different AWS CLI use cases using CleanStart containers. Each project provides a complete, containerized environment for learning and practicing AWS operations.

## 📁 Project Structure

```bash
aws-cli/
├── sample-project/
│   ├── basic-aws-operations/          # General AWS CLI operations
│   │   ├── data/                      # Shared data directory
│   │   ├── scripts/                   # Custom scripts
│   │   ├── docker-compose.yaml        # Basic operations setup
│   │   └── README.md                  # Project documentation
│   ├── ec2-instance-management/       # EC2 instance operations
│   │   ├── configs/                   # EC2 configuration files
│   │   ├── data/                      # Instance data and logs
│   │   ├── scripts/                   # EC2 management scripts
│   │   ├── docker-compose.yaml        # EC2 services setup
│   │   └── README.md                  # Project documentation
│   ├── s3-file-management/            # S3 file operations
│   │   ├── uploads/                   # Files to upload to S3
│   │   ├── downloads/                 # Files downloaded from S3
│   │   ├── data/                      # S3 operation data
│   │   ├── scripts/                   # S3 management scripts
│   │   ├── docker-compose.yaml        # S3 services setup
│   │   └── README.md                  # Project documentation
│   └── README.md                      # This file
└── README.md
```

## 🚀 Available Sample Projects

### 1. Basic AWS Operations
**Location:** `basic-aws-operations/`

A beginner-friendly introduction to AWS CLI operations. This project demonstrates fundamental AWS commands and provides an interactive environment for learning.

**Features:**
- General AWS CLI operations and commands
- Interactive shell for learning and testing
- Basic AWS service interactions (IAM, STS, S3, EC2)
- Health monitoring and status reporting
- Non-root user execution for security

**Quick Start:**
```bash
cd basic-aws-operations
docker compose up -d
```

### 2. EC2 Instance Management
**Location:** `ec2-instance-management/`

Comprehensive EC2 instance lifecycle management with specialized services for launching, monitoring, and managing EC2 instances.

**Features:**
- Complete EC2 instance lifecycle management
- Specialized launcher and monitor services
- Configuration management for instances
- Environment variables for customization
- Multiple service profiles (launcher, monitor)

**Quick Start:**
```bash
cd ec2-instance-management
docker compose up -d
```

**Available Services:**
- `aws-ec2`: Main EC2 management service
- `ec2-launcher`: Instance launching service (profile: launcher)
- `ec2-monitor`: Instance monitoring service (profile: monitor)

### 3. S3 File Management
**Location:** `s3-file-management/`

Dedicated S3 file operations with specialized upload and download services for efficient file management.

**Features:**
- Complete S3 file operations (upload, download, sync)
- Dedicated upload and download services
- Organized file directories (uploads/, downloads/)
- Bucket management operations
- Multiple service profiles (uploader, downloader)

**Quick Start:**
```bash
cd s3-file-management
docker compose up -d
```

**Available Services:**
- `aws-s3`: Main S3 management service
- `s3-uploader`: File upload service (profile: uploader)
- `s3-downloader`: File download service (profile: downloader)

## 🛠️ Common Features Across All Projects

All sample projects share these common features:

- **CleanStart Container**: Uses `cleanstart/aws-cli:latest` image
- **Security**: Non-root user execution (`awsuser`)
- **Credential Management**: Secure AWS credential mounting
- **Data Persistence**: Shared volumes for data and scripts
- **Health Monitoring**: Built-in health checks
- **Environment Variables**: Configurable AWS settings
- **Network Isolation**: Dedicated networks for each project

## 📋 Prerequisites

Before running any sample project:

1. **Docker and Docker Compose** must be installed and running
2. **AWS Credentials** must be configured in `~/.aws/` directory
3. **AWS CLI** should be accessible (for credential verification)

## 🔧 Environment Variables

All projects support these common environment variables:

- `AWS_DEFAULT_REGION`: AWS region (default: us-east-1)
- `AWS_CONFIG_FILE`: Path to AWS config file
- `AWS_SHARED_CREDENTIALS_FILE`: Path to AWS credentials file

**Project-specific variables:**
- **EC2 Project**: `EC2_INSTANCE_TYPE`, `EC2_AMI_ID`
- **S3 Project**: `S3_BUCKET_NAME`

## 🎯 Getting Started

1. **Choose a project** based on your learning goals
2. **Navigate to the project directory**
3. **Review the project-specific README** for detailed instructions
4. **Start the services** using `docker compose up -d`
5. **Access the containers** for interactive learning

## 📚 Learning Path

**Recommended order for beginners:**
1. Start with **Basic AWS Operations** to learn fundamentals
2. Move to **S3 File Management** for storage operations
3. Advance to **EC2 Instance Management** for compute operations

Each project builds upon the previous one, providing a comprehensive learning experience for AWS CLI operations.