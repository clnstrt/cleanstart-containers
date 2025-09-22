# 🚀 Hello World!!! 

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
docker run --rm -p 9198:9198 cleanstart/logstash-exporter:latest
```
## Output 
```bash
logstash_exporter, version 1.0.0 (branch: HEAD, revision: abc123)
build user:       root@logstash-exporter
build date:       20240115-10:30:45
go version:       go1.21.0
platform:         linux/amd64
level=info ts=2024-01-15T10:30:45.123Z caller=main.go:456 msg="Starting Logstash Exporter" mode=server
level=info ts=2024-01-15T10:30:45.124Z caller=main.go:457 msg="Build context" go_version=go1.21.0
level=info ts=2024-01-15T10:30:45.125Z caller=main.go:458 msg="Listening on" address=:9198
level=info ts=2024-01-15T10:30:45.126Z caller=main.go:459 msg="Server is ready to receive web requests."
```

## Access the Metrics Endpoint
Open your browser and go to: **http://localhost:9198/metrics**

You should see the Prometheus metrics endpoint for Logstash monitoring.

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