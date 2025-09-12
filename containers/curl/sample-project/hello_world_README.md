# 🚀 Curl - Hello World!

A simple **HELLO WORLD** program to run on CleanStart - Curl container.

## To run the Hello World without Dockerfile to avoid making simple things complex

### Pull CleanStart Curl image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart)
```bash
docker pull cleanstart/curl:latest
```
```bash
docker pull cleanstart/curl:latest-dev
```

## If you have the Curl image pulled, you can also run your program directly:
```bash
docker run --rm -v $(pwd):/app -w /app cleanstart/curl:latest sh hello_world.sh
```
## Output 
```bash
============================================================
🚀 Curl - Hello World
============================================================
Timestamp: 2024-01-15 10:30:45
Working Directory: /app
============================================================

🔍 Checking Environment...
✅ Running in Docker container
✅ Curl is available
✅ HTTP/HTTPS requests ready
✅ SSL/TLS support enabled

🧪 Testing Curl...
✅ Curl version check passed
✅ HTTP requests working
✅ SSL certificates valid

============================================================
🎉 Curl Hello World completed!
============================================================

🌐 Make HTTP requests with curl
🔒 Test SSL/TLS connections
📡 Download files and data
```

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [Curl Official Documentation](https://curl.se/docs/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).
