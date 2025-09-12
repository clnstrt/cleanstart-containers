# 🚀 AWS CLI - Hello World!

A simple **HELLO WORLD** program to run on CleanStart - AWS CLI container.

## To run the Hello World without Dockerfile to avoid making simple things complex

### Pull CleanStart AWS CLI image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart)
```bash
docker pull cleanstart/aws-cli:latest
```
```bash
docker pull cleanstart/aws-cli:latest-dev
```

## If you have the AWS CLI image pulled, you can also run your program directly:
```bash
docker run --rm -v $(pwd):/app -w /app cleanstart/aws-cli:latest python3 hello_world.py
```
## Output 
```bash
============================================================
🚀 AWS CLI - Hello World
============================================================
Timestamp: 2024-01-15 10:30:45
Working Directory: /app
============================================================

🔍 Checking Environment...
✅ Running in Docker container
✅ AWS CLI is available
✅ AWS credentials configured
✅ AWS regions accessible

🧪 Testing AWS CLI...
✅ AWS CLI version check passed
✅ AWS services accessible
✅ Cloud operations ready

============================================================
🎉 AWS CLI Hello World completed!
============================================================

☁️  Manage AWS resources with AWS CLI
🔧 Configure with AWS credentials
🌍 Deploy across multiple regions
```

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [AWS CLI Official Documentation](https://docs.aws.amazon.com/cli/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).
