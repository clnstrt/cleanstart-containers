## CleanStart Containers Samples Projects
The aim is to create sample projects for all CleanStart community images. 

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
