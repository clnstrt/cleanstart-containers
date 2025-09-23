**CleanStart Container for AWS CLI**

Official AWS Command Line Interface (CLI) container image providing a unified tool to manage AWS services. This enterprise-ready container includes the latest AWS CLI v2, with support for all AWS services and commands. Features include AWS IAM authentication, S3 operations, EC2 management, and other AWS service interactions. Built on a security-hardened base image with minimal attack surface and FIPS-compliant cryptographic modules.

📌 **CleanStart Foundation**: Security-hardened, minimal base OS designed for enterprise containerized environments.

**Key Features**
* Complete AWS CLI v2 functionality with all service commands
* Built-in credential management and AWS IAM integration
* Support for AWS profiles and configuration
* FIPS 140-2 compliant cryptographic modules for secure operations

**Common Use Cases**
* Automated AWS infrastructure management and deployment
* S3 bucket operations and file transfers
* EC2 instance management and monitoring
* CloudFormation stack deployment and updates

**Quick Start**

**Pull Latest Image**
Download the container image from the registry

```bash
docker pull cleanstart/aws-cli:latest
```
```bash
docker pull cleanstart/aws-cli:latest-dev
```

**Basic Run**
Run the container with basic configuration

```bash
docker run -it --name aws-cli-test cleanstart/aws-cli:latest-dev aws --version

```

**Production Deployment**
Deploy with production security settings

```bash
docker run -d --name aws-cli-prod \
  --read-only \
  --security-opt=no-new-privileges \
  --user 1000:1000 \
  -v ~/.aws:/home/aws/.aws:ro \
  cleanstart/aws-cli:latest
```


**Architecture Support**

**Multi-Platform Images**

```bash
docker pull --platform linux/amd64 cleanstart/aws-cli:latest
```
```bash
docker pull --platform linux/arm64 cleanstart/aws-cli:latest
```

**Resources & Documentation**

**Essential Links**
* **CleanStart Website**: https://www.cleanstart.com
* **AWS CLI Documentation**: https://docs.aws.amazon.com/cli/

---