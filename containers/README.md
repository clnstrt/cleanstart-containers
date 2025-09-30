## CleanStart Containers Samples Projects
The aim is to create sample projects for all CleanStart community images. 

## Index images, Use Cases and their sample projects

# Available Docker Images

| Sr No | Image Name              | Use Case                                    | Dockerfile-Based Projects | Kubernetes-Based Projects | Helm-Based Projects |
|-------|-------------------------|---------------------------------------------|---------------------------|---------------------------|----------------------|
| 1     | argocd                  | Continuous Deployment (CD)                  | Yes                       | No                        | No                   |
| 2     | argocd-extension-installer | ArgoCD Extensions & Plugins Installation | Yes                       | Yes                       | Yes                  |
| 3     | argo-workflow           | Workflow Automation                         | Yes                       | No                        | No                   |
| 4     | aws-cli                 | AWS Command Line Interface                  | Yes                       | Yes                       | No                   |
| 5     | busybox                 | Lightweight Utility                         | Yes                       | No                        | No                   |
| 6     | cadvisor                | Container Resource Monitoring               | Yes                       | Yes                       | Yes                  |
| 7     | curl                    | Data Transfer                               | Yes                       | No                        | No                   |
| 8     | go                      | Web Applications & Microservices            | Yes                       | Yes                       | No                   |
| 9     | jdk                     | Java Development Kit                        | Yes                       | No                        | No                   |
| 10    | jre                     | Java Runtime                                | Yes                       | No                        | No                   |
| 11    | kyverno-kyvernopre      | Kubernetes Policy Engine                    | Yes                       | No                        | Yes                  |
| 12    | logstash-exporter       | Elasticsearch Metrics Exporter              | Yes                       | No                        | No                   |
| 13    | memcached               | In-Memory Caching                           | Yes                       | No                        | No                   |
| 14    | metallb-controller      | Kubernetes Load Balancer                    | Yes                       | No                        | Yes                  |
| 15    | minio                   | Object Storage Server                       | Yes                       | No                        | Yes                  |
| 16    | minio-operator-sidecar  | MinIO Storage Operator                      | Yes                       | No                        | Yes                  |
| 17    | nginx                   | Web Server & Reverse Proxy                  | Yes                       | No                        | No                   |
| 18    | node                    | JavaScript Runtime                          | Yes                       | No                        | No                   |
| 19    | postgres                | Relational Database                         | Yes                       | No                        | No                   |
| 20    | python                  | Data Science & Web Apps                     | Yes                       | Yes                       | Yes                  |
| 21    | sqlite3                 | Lightweight SQL Database                    | Yes                       | No                        | No                   |
| 22    | step-cli                | PKI & Certificates                          | Yes                       | No                        | No                   |


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







