# 🚀 cAdvisor - Hello World!

A simple **HELLO WORLD** program to run on CleanStart - cAdvisor container.

## To run the Hello World without Dockerfile to avoid making simple things complex

### Pull CleanStart cAdvisor image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart)
```bash
docker pull cleanstart/cadvisor:latest
```
```bash
docker pull cleanstart/cadvisor:latest-dev
```

## If you have the cAdvisor image pulled, you can also run your program directly:
```bash
docker run --rm -v $(pwd):/app -w /app cleanstart/cadvisor:latest python3 hello_world.py
```
## Output 
```bash
============================================================
🚀 cAdvisor - Hello World
============================================================
Timestamp: 2024-01-15 10:30:45
Working Directory: /app
============================================================

🔍 Checking Environment...
✅ Running in Docker container
✅ cAdvisor is available
✅ Container metrics collection ready
✅ Web interface accessible

🧪 Testing cAdvisor...
✅ cAdvisor version check passed
✅ Metrics collection active
✅ Container monitoring ready

============================================================
🎉 cAdvisor Hello World completed!
============================================================

📊 Access web interface at: http://localhost:8080
📈 Monitor container performance and resource usage
🔍 View detailed container metrics and statistics
```

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [cAdvisor Official Documentation](https://github.com/google/cadvisor)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).
