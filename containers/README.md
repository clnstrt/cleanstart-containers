### Container Management
This section covers common container images and best practices for managing them.

Container Images Index
```bash
Container Image	Use Case
Argocd-installion-extension | Continuous Deployment (CD)
argo-workflow	| Workflow Automation
busyboxcLightweight Utility
curl	| Data Transfer
jre	| Java Runtime
jdk	| Java Development Kit
go |	Web Applications & Microservices
python	| Data Science & Web Apps
nginx	|  Web Server & Reverse Proxy
node |	JavaScript Runtime
postgres	| Relational Database
prometheus	| Monitoring & Alerting
step-cli	| PKI & Certificates
```
### Best Practices
Resolving Port Conflicts
Bash

 Find the Process ID (PID) using a specific port (e.g., 8080)
For Linux/macOS:
```bash
lsof -i :8080
```

For Windows (PowerShell):
#Get-Process -Id (Get-NetTCPConnection -LocalPort 8080).OwningProcess

#Kill the process using its PID
#For Linux/macOS:
```bash
kill -9 <PID>
```

 For Windows:
Stop-Process -Id <PID>
Clear Docker Build Cache
Bash

#Build a new image, ignoring the local cache
```bash
docker build --no-cache -t my-image .
```

