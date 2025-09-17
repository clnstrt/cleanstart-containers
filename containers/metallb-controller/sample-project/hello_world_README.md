# 🚀 MetalLB Controller - Hello World!

A simple **HELLO WORLD** program to run on CleanStart - MetalLB Controller container.

## To run the Hello World without Dockerfile to avoid making simple things complex

### Pull CleanStart MetalLB Controller image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart)
```bash
docker pull cleanstart/metallb-controller:latest
```
```bash
docker pull cleanstart/metallb-controller:latest-dev
```

## If you have the MetalLB Controller image pulled, you can also run your program directly:
```bash
docker run --rm -v $(pwd):/app -w /app cleanstart/metallb-controller:latest
```
## Output 
```bash
============================================================
🚀 MetalLB Controller - Hello World
============================================================
Timestamp: 2024-01-15 10:30:45
Working Directory: /app
============================================================

🔍 Checking Environment...
✅ Running in Docker container
✅ MetalLB Controller is available
✅ Load balancer management ready
✅ Kubernetes cluster accessible

🧪 Testing MetalLB Controller...
✅ Controller version check passed
✅ Load balancer configuration ready
✅ Network services active

============================================================
🎉 MetalLB Controller Hello World completed!
============================================================

🌐 Manage load balancer services
🔧 Configure Layer 2 and BGP modes
📡 Provide external IPs for services
```

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [MetalLB Official Documentation](https://metallb.universe.tf/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).
