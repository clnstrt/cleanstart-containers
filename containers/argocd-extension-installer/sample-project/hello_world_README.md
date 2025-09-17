# 🚀 ArgoCD Extension Installer - Hello World!

A simple **HELLO WORLD** program to run on CleanStart - ArgoCD Extension Installer container.

## To run the Hello World without Dockerfile to avoid making simple things complex

### Pull CleanStart ArgoCD Extension Installer image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart)
```bash
docker pull cleanstart/argocd-extension-installer:latest
```
```bash
docker pull cleanstart/argocd-extension-installer:latest-dev
```

## If you have the ArgoCD Extension Installer image pulled, you can also run your program directly:
```bash
docker run --rm -v $(pwd):/app -w /app cleanstart/argocd-extension-installer:latest python3 hello_world.py
```
## Output 
```bash
============================================================
🚀 ArgoCD Extension Installer - Hello World
============================================================
Timestamp: 2024-01-15 10:30:45
Working Directory: /app
============================================================

🔍 Checking Environment...
✅ Running in Docker container
✅ ArgoCD Extension Installer is available
✅ Extension management ready
✅ GitOps workflows accessible

🧪 Testing ArgoCD Extension Installer...
✅ Extension installer version check passed
✅ Extension management active
✅ GitOps capabilities ready

============================================================
🎉 ArgoCD Extension Installer Hello World completed!
============================================================

🔧 Install and manage ArgoCD extensions
🚀 Automate GitOps workflows
📦 Package and deploy applications
```

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [ArgoCD Official Documentation](https://argo-cd.readthedocs.io/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).
