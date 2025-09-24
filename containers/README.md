## CleanStart Containers Samples Projects
The aim is to create sample projects for all CleanStart community images. 

## Index images, Use Cases and their sample projects

| Sr No | Image Name        | Use Case                        | Dockerfile-Based Projects | Kubernetes-Based Projects | Helm-Based Projects |
|-------|-------------------|---------------------------------|---------------------------|---------------------------|----------------------|
| 1     | argocd            | Continuous Deployment (CD)      | Yes                       | No                        | No                   |
| 2     | argo-workflow      | Workflow Automation             | Yes                       | No                       | no                 |
| 3     | busybox           | Lightweight Utility             | Yes                       | No                       | no                  |
| 4     | curl              | Data Transfer                   | Yes                       | No                       | no                 |
| 5     | jre               | Java Runtime                    | Yes                       | No                        | no                 |
| 6     | jdk               | Java Development Kit            | Yes                       | No                       | no                 |
| 7     | go                | Web Applications & Microservices| Yes                       | Yes                       | no                 |
| 8     | python            | Data Science & Web Apps         | Yes                       | Yes                       | Yes                 |
| 9     | nginx             | Web Server & Reverse Proxy      | Yes                       | No                        | no                 |
| 10    | node              | JavaScript Runtime              | Yes                       | No                        | no                 |
| 11    | postgres          | Relational Database             | Yes                       | No                        | no                 |
| 12    | step-cli          | PKI & Certificates              | Yes                       | no                        | no                 |

# Available Docker Images

## Core Development & Runtime
- **argocd** - Continuous Deployment (CD) platform for Kubernetes
- **argo-workflow** - Workflow automation and orchestration engine
- **python** - Python runtime for data science, web applications, and scripting
- **go** - Go language runtime for building web applications and microservices
- **node** - Node.js JavaScript runtime for server-side applications
- **jre** - Java Runtime Environment for running Java applications
- **jdk** - Java Development Kit for building and running Java applications

## Web Servers & Databases
- **nginx** - High-performance web server and reverse proxy
- **postgres** - PostgreSQL relational database management system
- **memcached** - In-memory key-value store for caching
- **sqlite3** - Lightweight embedded SQL database

## DevOps & Infrastructure
- **kyverno-kyvernopre** - Kubernetes policy engine for security and governance
- **logstash-exporter** - Elasticsearch Logstash metrics exporter
- **metallb-controller** - Load balancer implementation for bare metal Kubernetes
- **minio-operator-sidecar** - MinIO object storage operator sidecar container
- **minio** - High-performance object storage server

## Utilities & Tools
- **busybox** - Lightweight multi-call binary with essential Unix utilities
- **curl** - Command-line tool for data transfer with URL syntax
- **step-cli** - PKI toolkit for certificate management and security

## Additional Images
- **redis** - In-memory data structure store for caching and messaging
- **mongodb** - NoSQL document-oriented database
- **mysql** - Popular relational database management system
- **alpine** - Security-oriented lightweight Linux distribution
- **ubuntu** - Popular Linux distribution for general-purpose containers
- **docker** - Docker-in-Docker for CI/CD pipelines
- **jenkins** - Automation server for continuous integration
- **grafana** - Analytics and monitoring platform
- **prometheus** - Systems monitoring and alerting toolkit
- **elasticsearch** - Distributed search and analytics engine
- **rabbitmq** - Message broker for distributed systems
- **kafka** - Distributed streaming platform
- **consul** - Service mesh solution and key-value store
- **vault** - Secrets management and data protection
- **traefik** - Modern HTTP reverse proxy and load balancer


## BEST PRACTICE BEFORE RUNNING ANY PROJECT

 Find the Process ID (PID) using a specific port (e.g., 8080)
 For Linux/macOS:
 ```bash
lsof -i :8080
```

# For Windows (PowerShell):
Get-Process -Id (Get-NetTCPConnection -LocalPort 8080).OwningProcess

 Kill the process using its PID
 For Linux/macOS:
 ```bash
kill -9 <PID>
```

# For Windows:
```bash
Stop-Process -Id <PID>
```




