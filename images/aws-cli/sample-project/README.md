# ☁️ AWS CLI Sample Projects

This directory contains sample projects for testing the `cleanstart/aws-cli` Docker image that you already pulled from Docker Hub. These examples demonstrate AWS CLI operations for cloud management, S3 operations, and EC2 instance management.

## 🚀 Quick Start

### Prerequisites
- Docker installed and running
- AWS credentials configured (optional for testing)

### Setup
```bash
# Navigate to this directory
cd images/aws-cli/sample-project

# Test the image (you already pulled cleanstart/aws-cli:latest from Docker Hub)
docker run --rm cleanstart/aws-cli:latest aws --version
```

### Run Examples

#### Basic AWS Operations
```bash
# List S3 buckets
docker run --rm -e AWS_ACCESS_KEY_ID=your_key -e AWS_SECRET_ACCESS_KEY=your_secret \
  cleanstart/aws-cli:latest aws s3 ls

# Get AWS account info
docker run --rm -e AWS_ACCESS_KEY_ID=your_key -e AWS_SECRET_ACCESS_KEY=your_secret \
  cleanstart/aws-cli:latest aws sts get-caller-identity
```

#### S3 File Management
```bash
# List files in bucket
docker run --rm -e AWS_ACCESS_KEY_ID=your_key -e AWS_SECRET_ACCESS_KEY=your_secret \
  cleanstart/aws-cli:latest aws s3 ls s3://your-bucket-name/

# Upload a file
docker run --rm -v $(pwd):/workspace -e AWS_ACCESS_KEY_ID=your_key -e AWS_SECRET_ACCESS_KEY=your_secret \
  cleanstart/aws-cli:latest aws s3 cp /workspace/data/test.txt s3://your-bucket-name/
```

#### EC2 Instance Management
```bash
# List EC2 instances
docker run --rm -e AWS_ACCESS_KEY_ID=your_key -e AWS_SECRET_ACCESS_KEY=your_secret \
  cleanstart/aws-cli:latest aws ec2 describe-instances

# Get instance details
docker run --rm -e AWS_ACCESS_KEY_ID=your_key -e AWS_SECRET_ACCESS_KEY=your_secret \
  cleanstart/aws-cli:latest aws ec2 describe-instances --instance-ids i-1234567890abcdef0
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
├── basic-aws-operations/       # Basic AWS examples
│   ├── data/                   # Sample data files
│   ├── docker-compose.yml      # Basic operations setup
│   ├── README.md              # Basic operations guide
│   └── scripts/               # Helper scripts
├── ec2-instance-management/   # EC2 examples
│   └── docker-compose.yml     # EC2 management setup
├── s3-file-management/        # S3 examples
│   └── docker-compose.yml     # S3 operations setup
├── setup.bat                  # Windows setup script
└── setup.sh                   # Linux/Mac setup script
```

## 🎯 Features

- AWS CLI operations (S3, EC2, IAM, etc.)
- S3 file upload/download operations
- EC2 instance management
- AWS account information
- Cloud resource monitoring
- Automated AWS operations
- Multi-region support

## 📊 Output

AWS operations output includes:
- S3 bucket listings and file operations
- EC2 instance information
- AWS account details
- Cloud resource status

## 🔒 Security

- AWS credentials management
- IAM role-based access
- Secure credential handling
- Least privilege principles

## 🤝 Contributing

To add new AWS operations:
1. Create script in appropriate directory
2. Add documentation
3. Test with AWS CLI
