# 🚀 Go Web App - Kubernetes Quick Reference

## 📋 Quick Commands

### Deploy
```bash
./deploy.sh
```

### Check Status
```bash
./status.sh
```

### Access Application
```bash
# Port forward
kubectl port-forward service/go-web-service 8080:80

# NodePort (if available)
kubectl get nodes -o wide
# Access: http://<NODE_IP>:30080
```

### View Logs
```bash
kubectl logs -l app=go-web-app -f
```

### Scale
```bash
kubectl scale deployment go-web-app --replicas=5
```

### Cleanup
```bash
./undeploy.sh
```

## 🔧 Common Operations

### Check Resources
```bash
kubectl get all -l app=go-web-app
kubectl get pods,svc,ingress,pvc,hpa -l app=go-web-app
```

### Debug Issues
```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
kubectl get events --sort-by=.metadata.creationTimestamp
```

### Update Application
```bash
kubectl set image deployment/go-web-app go-web-app=go-web-app:v2.0.0
kubectl rollout status deployment/go-web-app
```

### Access Database
```bash
kubectl port-forward service/go-web-service 8080:80
curl http://localhost:8080/api/users
```

## 📊 Resource Information

| Resource | Name | Type |
|----------|------|------|
| Deployment | go-web-app | 3 replicas |
| Service | go-web-service | ClusterIP |
| Service | go-web-service-nodeport | NodePort:30080 |
| Ingress | go-web-ingress | HTTP routing |
| HPA | go-web-hpa | 2-10 replicas |
| PVC | go-web-pvc | 1Gi storage |
| ConfigMap | go-web-config | App config |
| Secret | go-web-secrets | Sensitive data |

## 🌐 Access URLs

- **Port Forward**: http://localhost:8080
- **NodePort**: http://<NODE_IP>:30080
- **Ingress**: http://go-web.local (if configured)

## 🔍 Troubleshooting

### Pod Issues
```bash
kubectl get pods -l app=go-web-app
kubectl describe pod <pod-name>
kubectl logs <pod-name> --previous
```

### Service Issues
```bash
kubectl get svc -l app=go-web-app
kubectl describe svc go-web-service
```

### Storage Issues
```bash
kubectl get pvc -l app=go-web-app
kubectl describe pvc go-web-pvc
```

### Network Issues
```bash
kubectl get ingress -l app=go-web-app
kubectl describe ingress go-web-ingress
```

## 📈 Monitoring

### Resource Usage
```bash
kubectl top pods -l app=go-web-app
kubectl top nodes
```

### HPA Status
```bash
kubectl get hpa go-web-hpa
kubectl describe hpa go-web-hpa
```

### Health Checks
```bash
kubectl get pods -l app=go-web-app -o wide
# Check READY column for health status
```

## 🧹 Cleanup

### Remove Everything
```bash
./undeploy.sh
```

### Manual Cleanup
```bash
kubectl delete -f .
kubectl delete namespace go-web-app
```

## 📚 Useful Links

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Gin Web Framework](https://gin-gonic.com/)
- [Go Documentation](https://golang.org/doc/)

---

**Happy Deploying! 🚀**
