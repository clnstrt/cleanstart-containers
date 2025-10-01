**AWS CLI Docker Migration Project**

This project demonstrates how to migrate from the public amazon/aws-cli:latest image (v1) to a Cleanstart image cleanstart/aws-cli:latest (v2). The project includes building, running, and using the AWS CLI in Docker.

We migrate a containerized AWS CLI environment from:

v1: amazon/aws-cli:latest

v2: cleanstart/aws-cli:latest

The Cleanstart image is a slim, production-ready image maintained by Cleanstart. It only includes the aws executable and its dependencies; it does not include a shell (sh).

**Prerequisites:**

```bash
Docker installed on your system
Internet access to pull public and Cleanstart images
(Optional) AWS credentials in ~/.aws/ if you want to run real commands
```

Project Structure
aws-cli/
│
├── Dockerfile.v1      # Based on amazon/aws-cli:latest
├── Dockerfile.v2      # Based on cleanstart/aws-cli:latest
└── README.md

Dockerfile.v1:

```bash
FROM amazon/aws-cli:latest
WORKDIR /app
```

Dockerfile.v2

```bash
FROM cleanstart/aws-cli:latest
WORKDIR /app
```

Note: The Cleanstart image is minimal; it only includes aws. No shell is available.

**Build and Run Instructions**

Build v1 (Amazon AWS CLI)
```bash
docker build -t aws-cli-v1 -f Dockerfile.v1 .
```

Run v1 container
```bash
docker run -it --name aws-cli-v1-container aws-cli-v1
```

This will fail if no command is provided:

aws: [ERROR]: the following arguments are required: command

```bash
docker run -it --entrypoint sh --name aws-cli-v2-container aws-cli-v2
```

Build v2 (Cleanstart AWS CLI)

```bash
docker build -t aws-cli-v2 -f Dockerfile.v2 .
```

Run v2 container

```bash
docker run --rm aws-cli-v2 --help
```

Example: Check version

```bash
docker run --rm aws-cli-v2 --version
```

Running AWS CLI Commands

Since there is no shell inside aws-cli-v2, you must run commands directly via Docker:

# S3 listing example

```bash
docker run --rm aws-cli-v2 s3 ls
```

# List EC2 instances

```bash
docker run --rm aws-cli-v2 ec2 describe-instances
```

**Using AWS Credentials:**

Mount your local AWS configuration into the container to authenticate:

```bash
docker run --rm -it \
  -v ~/.aws:/root/.aws \
  aws-cli-v2 s3 ls
```

This ensures the container can access your AWS resources.