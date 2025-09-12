# 🚀 Logstash Exporter - Hello World!

A simple **HELLO WORLD** program to run on CleanStart - Logstash Exporter container.

## To run the Hello World without Dockerfile to avoid making simple things complex

### Pull CleanStart Logstash Exporter image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart)
```bash
docker pull cleanstart/logstash-exporter:latest
```
```bash
docker pull cleanstart/logstash-exporter:latest-dev
```

## If you have the Logstash Exporter image pulled, you can also run your program directly:
```bash
docker run --rm -v $(pwd):/app -w /app cleanstart/logstash-exporter:latest python3 hello_world.py
```
## Output 
```bash
============================================================
🚀 Logstash Exporter - Hello World
============================================================
Timestamp: 2024-01-15 10:30:45
Working Directory: /app
============================================================

🔍 Checking Environment...
✅ Running in Docker container
✅ Logstash Exporter is available
✅ Prometheus metrics endpoint ready

🧪 Testing Logstash Exporter...
✅ Exporter version check passed
✅ Metrics collection ready
✅ Monitoring capabilities active

============================================================
🎉 Logstash Exporter Hello World completed!
============================================================

📊 Access metrics at: http://localhost:9198/metrics
🔗 Logstash server: Configure with LOGSTASH_SERVER environment variable
```

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [Logstash Exporter Official Documentation](https://github.com/prometheus-community/logstash_exporter)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).
