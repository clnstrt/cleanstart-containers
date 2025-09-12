# 🚀 Hello World!!! 

A simple **HELLO WORLD** program to run on CleanStart - MinIO Operator Sidecar container. 

## To run the Hello World without Dockerfile to avoid making simple things complex

### Pull CleanStart MinIO Operator Sidecar image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart) 
```bash
docker pull cleanstart/minio-operator-sidecar:latest
```
```bash
docker pull cleanstart/minio-operator-sidecar:latest-dev
```

## If you have the MinIO Operator Sidecar image pulled, you can also run your program directly:
```bash
docker run --rm -v $(pwd):/app -w /app cleanstart/minio-operator-sidecar:latest python hello_world.py
```
## Output 
```bash
============================================================
🏢 MinIO Operator Sidecar - Hello World
============================================================
Timestamp: 2024-01-15 10:30:45
Python Version: 3.11.0 (main, Oct 24 2023, 00:00:00) [GCC 11.2.0]
Working Directory: /app
============================================================

🔍 Checking Environment...
✅ Running in Docker container
   MINIO_OPERATOR_NAMESPACE: Not set
   MINIO_OPERATOR_LOG_LEVEL: Not set
   MINIO_OPERATOR_WATCH_NAMESPACE: Not set
✅ kubectl is available
   Version: Client Version: version.Info{Major:"1", Minor:"28", GitVersion:"v1.28.0"}
✅ Kubernetes cluster is accessible

🧪 Testing MinIO Operator...
✅ MinIO operator namespace exists
✅ MinIO operator pod found
✅ Can access MinIO tenants
✅ Found MinIO tenants:
   NAME           NAMESPACE      STATUS    AGE
   minio-tenant   minio-tenant   Ready     5m

🌐 Testing MinIO Connectivity...
✅ MinIO API is accessible at http://localhost:9000
✅ MinIO Console is accessible at http://localhost:9001

📋 Sample MinIO Operator Commands:
----------------------------------------
   Check operator status:
     kubectl get pods -n minio-operator

   List all tenants:
     kubectl get tenants --all-namespaces

   Create a tenant:
     kubectl apply -f minio-tenant.yaml

   Check tenant status:
     kubectl describe tenant <tenant-name>

   Access MinIO API:
     kubectl port-forward svc/minio 9000:9000

   Access MinIO Console:
     kubectl port-forward svc/minio-console 9001:9001

   Check operator logs:
     kubectl logs -l app=minio-operator -n minio-operator

   Scale tenant:
     kubectl scale tenant <tenant-name> --replicas=4

🚀 Next Steps:
--------------------
1. Deploy MinIO operator:
   kubectl apply -f basic-tenant/minio-operator.yaml

2. Deploy a MinIO tenant:
   kubectl apply -f basic-tenant/minio-tenant.yaml

3. Access MinIO Console:
   kubectl port-forward svc/minio-console 9001:9001 -n minio-tenant
   Open http://localhost:9001

4. Explore sample projects:
   - Basic Tenant: ./basic-tenant/
   - Multi-Tenant: ./multi-tenant/
   - Production Setup: ./production-setup/
   - Monitoring: ./monitoring/

5. Run setup scripts:
   ./setup.sh        # Linux/macOS
   setup.bat         # Windows

============================================================
🎉 MinIO Operator Sidecar Hello World completed!
============================================================
```

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [MinIO Official Documentation](https://docs.min.io/)
- [MinIO Operator Documentation](https://docs.min.io/docs/minio-operator-quickstart-guide.html)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).