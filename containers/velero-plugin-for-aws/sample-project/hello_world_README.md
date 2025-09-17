# 🚀 Velero Plugin for AWS - Hello World!

A simple **HELLO WORLD** program to run on CleanStart - Velero Plugin for AWS container.

## To run the Hello World without Dockerfile to avoid making simple things complex

### Pull CleanStart Velero Plugin for AWS image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart)
```bash
docker pull cleanstart/velero-plugin-for-aws:latest
```
```bash
docker pull cleanstart/velero-plugin-for-aws:latest-dev
```

## If you have the Velero Plugin for AWS image pulled, you can also run your program directly:
```bash
docker run --rm -v $(pwd):/app -w /app cleanstart/velero-plugin-for-aws:latest python3 hello_world.py
```
## Output 
```bash
============================================================
🚀 Velero Plugin for AWS - Hello World
============================================================
Timestamp: 2024-01-15 10:30:45
Working Directory: /app
============================================================

🔍 Checking Environment...
✅ Running in Docker container
✅ Velero CLI is available
✅ AWS plugin is loaded
✅ Kubernetes cluster is accessible

🧪 Testing Velero...
✅ Velero version check passed
✅ AWS plugin loaded successfully
✅ Backup and restore capabilities ready

============================================================
🎉 Velero Plugin for AWS Hello World completed!
============================================================

💾 Backup your Kubernetes cluster with Velero
☁️  Store backups in AWS S3 buckets
🔄 Restore applications across clusters
```

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [Velero Official Documentation](https://velero.io/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).
