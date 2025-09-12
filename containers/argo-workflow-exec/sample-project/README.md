# 🚀 Hello World!!! 

A simple **HELLO WORLD** program to run on CleanStart - Argo Workflow Exec container. 

## To run the Hello World without Dockerfile to avoid making simple things complex

### Pull CleanStart Argo Workflow Exec image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart) 
```bash
docker pull cleanstart/argo-workflow-exec:latest
```
```bash
docker pull cleanstart/argo-workflow-exec:latest-dev
```

## If you have the Argo Workflow Exec image pulled, you can also run your program directly:
```bash
docker run --rm -v $(pwd):/app -w /app cleanstart/argo-workflow-exec:latest argoexec version
```
## Output 
```bash
argoexec: v3.4.4+1a1b2c3d
  BuildDate: 2024-01-15T10:30:45Z
  GitCommit: 1a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0
  GitTreeState: clean
  GitTag: v3.4.4
  GoVersion: go1.21.0
  Compiler: gc
  Platform: linux/amd64
```

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [Argo Workflows Official Documentation](https://argoproj.github.io/argo-workflows/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).