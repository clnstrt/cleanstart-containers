# 🚀 Hello World!!! 

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
docker run --rm -p 9000:9000 -p 9001:9001 -e MINIO_ROOT_USER=minioadmin -e MINIO_ROOT_PASSWORD=minioadmin123 cleanstart/minio:latest
```
## Output 
```bash
MinIO Object Storage Server
Copyright: 2015-2024 MinIO, Inc.
License: GNU AGPLv3 <https://www.gnu.org/licenses/agpl-3.0.html>
Version: RELEASE.2024-01-15T10-30-45Z (go1.21.0 linux/amd64)

Status:         1 Online, 0 Offline. 
API: http://0.0.0.0:9000  http://127.0.0.1:9000
Console: http://0.0.0.0:9001 http://127.0.0.1:9001

WARNING: Console endpoint is listening on a dynamic port (9001), please use --console-address ":PORT" to choose a static port.
```

## Access the MinIO Console
Open your browser and go to: **http://localhost:9001**

Default credentials: `minioadmin` / `minioadmin123`

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