# 🚀 MinIO - Hello World!

A simple **HELLO WORLD** program to run on CleanStart - MinIO container.

## To run the Hello World without Dockerfile to avoid making simple things complex

### Pull CleanStart MinIO image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart)
```bash
docker pull cleanstart/minio:latest
```
```bash
docker pull cleanstart/minio:latest-dev
```

## If you have the MinIO image pulled, you can also run your program directly:
```bash
docker run --rm -v $(pwd):/app -w /app cleanstart/minio:latest python3 hello_world.py
```
## Output 
```bash
============================================================
🚀 MinIO - Hello World
============================================================
Timestamp: 2024-01-15 10:30:45
Working Directory: /app
============================================================

🔍 Checking Environment...
✅ Running in Docker container
✅ MinIO server is available
✅ S3-compatible API ready
✅ Web console accessible

🧪 Testing MinIO...
✅ MinIO version check passed
✅ Object storage ready
✅ Web interface available

============================================================
🎉 MinIO Hello World completed!
============================================================

🌐 Access web console at: http://localhost:9001
🔑 Default credentials: minioadmin / minioadmin123
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
