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
| 12    | prometheus        | Monitoring & Alerting           | Yes                       | no                        | no                 |
| 13    | step-cli          | PKI & Certificates              | Yes                       | no                        | no                 |

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
