# 🚀 Hello World!!! 

A simple **HELLO WORLD** program to run on CleanStart - MinIO Operator Sidecar container. 

## To run the Hello World without Dockerfile to avoid making simple things complex

### Pull CleanStart MinIO Operator Sidecar image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart) 
```bash
docker pull cleanstart/minio-operator-sidecar:latest
```
```bash
docker pull cleanstart/minio-operator-sidecar:latest-dev
```

## If you have the MinIO Operator Sidecar image pulled, you can also run your program directly:
```bash
docker run --rm -v $(pwd):/app -w /app cleanstart/minio-operator-sidecar:latest python hello_world.py
```
## Output 
```bash
============================================================
🏢 MinIO Operator Sidecar - Hello World
============================================================
Timestamp: 2024-01-15 10:30:45
Python Version: 3.11.0 (main, Oct 24 2023, 00:00:00) [GCC 11.2.0]
Working Directory: /app
============================================================

🔍 Checking Environment...
✅ Running in Docker container
✅ kubectl is available
✅ Kubernetes cluster is accessible
✅ MinIO operator pod found
✅ Found MinIO tenants
✅ MinIO API is accessible at http://localhost:9000
✅ MinIO Console is accessible at http://localhost:9001

============================================================
🎉 MinIO Operator Sidecar Hello World completed!
============================================================
```

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [MinIO Official Documentation](https://docs.min.io/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).