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

## Here is the Dockerfile
```bash
# Start with the prometheus base image
FROM cleanstart/prometheus:latest-dev

# Set the working directory
WORKDIR /etc/prometheus

# Switch to the root user to gain the necessary permissions
USER root

# Create the data directory and set permissions
# This command will now succeed because it's run by the root user
RUN mkdir -p /etc/prometheus/data && \
    chown -R prometheus:prometheus /etc/prometheus/data

# Switch back to the prometheus user for security best practices
USER prometheus

# Copy your prometheus configuration file
# This command is now safe to run as the prometheus user
COPY --chown=prometheus:prometheus prometheus.yml /etc/prometheus/prometheus.yml
```


## If you have the Prometheus image pulled, you can build and run the dockerfile for running the application given above:
```bash
docker build --no-cache -t prometheus-app .
```

## Now run the container and your application will be live!
```bash
docker run --rm -p 9090:9090  prometheus-app
```
## Access the application
http://localhost:9090/

## Output 
```bash
time=2025-09-16T11:50:25.017Z level=INFO source=main.go:1544 msg="updated GOGC" old=100 new=75
time=2025-09-16T11:50:25.017Z level=INFO source=main.go:676 msg="Leaving GOMAXPROCS=16: CPU quota undefined" component=automaxprocs
time=2025-09-16T11:50:25.018Z level=INFO source=memlimit.go:198 msg="GOMEMLIMIT is updated" component=automemlimit package=github.com/KimMachineGun/automemlimit/memlimit GOMEMLIMIT=7164883353 previous=9223372036854775807
time=2025-09-16T11:50:25.018Z level=INFO source=main.go:718 msg="No time or size retention was set so using the default time retention" duration=15d
time=2025-09-16T11:50:25.018Z level=INFO source=main.go:769 msg="Starting Prometheus Server" mode=server version="(version=3.5.0, branch=master, revision=AlpineLinux)"
time=2025-09-16T11:50:25.018Z level=INFO source=main.go:774 msg="operational information" build_context="(go=go1.24.5, platform=linux/amd64, user=bhavik@build-amd64-aa, date=20250729-11:13:53, tags=netgo,builtinassets)" host_details="(Linux 6.6.87.2-microsoft-standard-WSL2 #1 SMP PREEMPT_DYNAMIC Thu Jun  5 18:30:46 UTC 2025 x86_64 3f7a513eff03 localdomain)" fd_limits="(soft=1048576, hard=1048576)" vm_limits="(soft=unlimited, hard=unlimited)"
time=2025-09-16T11:50:25.024Z level=INFO source=web.go:656 msg="Start listening for connections" component=web address=0.0.0.0:9090
time=2025-09-16T11:50:25.025Z level=INFO source=main.go:1288 msg="Starting TSDB ..."
time=2025-09-16T11:50:25.027Z level=INFO source=tls_config.go:347 msg="Listening on" component=web address=[::]:9090
time=2025-09-16T11:50:25.028Z level=INFO source=tls_config.go:350 msg="TLS is disabled." component=web http2=false address=[::]:9090
time=2025-09-16T11:50:25.034Z level=INFO source=head.go:657 msg="Replaying on-disk memory mappable chunks if any" component=tsdb
time=2025-09-16T11:50:25.034Z level=INFO source=head.go:744 msg="On-disk memory mappable chunks replay completed" component=tsdb duration=1.48µs
time=2025-09-16T11:50:25.034Z level=INFO source=head.go:752 msg="Replaying WAL, this may take a while" component=tsdb
time=2025-09-16T11:50:25.036Z level=INFO source=head.go:825 msg="WAL segment loaded" component=tsdb segment=0 maxSegment=0 duration=1.655201ms
time=2025-09-16T11:50:25.036Z level=INFO source=head.go:862 msg="WAL replay completed" component=tsdb checkpoint_replay_duration=61.591µs wal_replay_duration=1.721596ms 
```

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

