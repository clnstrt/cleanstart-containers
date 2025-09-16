# 🚀 Hello from Prometheus!!! 


### Pull CleanStart Prometheus image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart) 
```bash
docker pull cleanstart/prometheus:latest
```
```bash
docker pull cleanstart/prometheus:latest-dev
```

# 🚀 Hello from Prometheus!

A program to run on CleanStart - Prometheus container. 

### Pull CleanStart Prometheus image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart) 
```bash
docker pull cleanstart/prometheus:latest
```
```bash
docker pull cleanstart/prometheus:latest-dev
```

## Here is the Dockerfile
```bash
# Start with the prometheus base image
FROM cleanstart/prometheus:latest-dev

# Set working directory
WORKDIR /etc/prometheus

# Switch to root to set up directories
USER root

# Create storage directory and set permissions
RUN mkdir -p /etc/prometheus/data && \
    chown -R prometheus:prometheus /etc/prometheus/data

# Copy Prometheus config (with proper ownership)
COPY --chown=prometheus:prometheus prometheus.yml /etc/prometheus/prometheus.yml

# Switch back to non-root user for security
USER prometheus

# Expose Prometheus web UI port
EXPOSE 9090

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:9090/-/healthy || exit 1

# Default command to run Prometheus
CMD [ \
  "--config.file=/etc/prometheus/prometheus.yml", \
  "--storage.tsdb.path=/etc/prometheus/data", \
  "--web.enable-lifecycle", \
  "--web.enable-admin-api" \
]
```


## If you have the Prometheus image pulled, you can build and run the dockerfile for running the application given above:
```bash
 docker build -t my-prometheus .
```

## Now run the container and your application will be live!
```bash
docker run -d --name prometheus -p 9090:9090 my-prometheus
```
## Access the application
http://localhost:9090/

## Output 
You will get access to Prometheus Monitoring and Logging Web page

## Access the Prometheus UI
Open your browser and go to: **http://localhost:9090**

You should see the Prometheus web interface where you can query metrics and explore the monitoring system.

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [Prometheus Official Documentation](https://prometheus.io/docs/)
- [Prometheus Configuration Guide](https://prometheus.io/docs/prometheus/latest/configuration/configuration/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).



## Access the Prometheus UI
Open your browser and go to: **http://localhost:9090**

You should see the Prometheus web interface where you can query metrics and explore the monitoring system.

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [Prometheus Official Documentation](https://prometheus.io/docs/)
- [Prometheus Configuration Guide](https://prometheus.io/docs/prometheus/latest/configuration/configuration/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).
