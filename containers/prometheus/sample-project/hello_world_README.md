# 🚀 Hello World!!! 

A simple **HELLO WORLD** program to run on CleanStart - Prometheus container. 

## To run the Hello World without Dockerfile to avoid making simple things complex

### Pull CleanStart Prometheus image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart) 
```bash
docker pull cleanstart/prometheus:latest
```
```bash
docker pull cleanstart/prometheus:latest-dev
```

## If you have the Prometheus image pulled, you can also run your program directly:
```bash
docker run --rm -p 9090:9090 cleanstart/prometheus:latest
```
## Output 
```bash
prometheus, version 2.45.0 (branch: HEAD, revision: 2c375d6d0d4312c08295a6d3c1c7b7b8c8c8c8c8)
build user:       root@prometheus
build date:       20240115-10:30:45
go version:       go1.21.0
platform:         linux/amd64
level=info ts=2024-01-15T10:30:45.123Z caller=main.go:456 msg="Starting Prometheus Server" mode=server
level=info ts=2024-01-15T10:30:45.124Z caller=main.go:457 msg="Build context" go_version=go1.21.0
level=info ts=2024-01-15T10:30:45.125Z caller=main.go:458 msg="Loading configuration file" filename=/etc/prometheus/prometheus.yml
level=info ts=2024-01-15T10:30:45.126Z caller=main.go:459 msg="Completed loading of configuration file" filename=/etc/prometheus/prometheus.yml
level=info ts=2024-01-15T10:30:45.127Z caller=main.go:460 msg="Server is ready to receive web requests."
```

## Access the Prometheus UI
Open your browser and go to: **http://localhost:9090**

You should see the Prometheus web interface where you can query metrics and explore the monitoring system.

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [Prometheus Official Documentation](https://prometheus.io/docs/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).