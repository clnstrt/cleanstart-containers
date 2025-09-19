**🚀 Memcached on Kubernetes**

This project provides a ready-to-use Kubernetes manifest to deploy **Memcached** using the `cleanstart/memcached:latest` image.  
It includes a `Deployment` and a `Service` to expose Memcached inside your cluster.

---

📂 Files

- `deployment.yaml` → Kubernetes manifest (Deployment + Service + Namespace)

---

**🛠️ Deploy Memcached**

Apply the manifest:

```bash
kubectl apply -f deployment.yaml
```

**Verify resources:**

```bash
kubectl get all -n memcached-sample
```

**✅ Basic Test:**
Check pods are running

```bash
kubectl get pods -n memcached-sample
```

Run a client pod to connect to Memcached

```bash
kubectl run memcached-client -n memcached-sample --rm -it \
  --image=busybox --restart=Never -- sh
```

**Inside the client pod, connect via telnet**

```bash
telnet memcached-service 11211
```

**Store and retrieve a key**

```bash
set mykey 0 900 5
hello
get mykey
```

**✅ Expected output:**

```bash
STORED
VALUE mykey 0 5
hello
END
```

**🔍 Clean Up**
To remove everything:

```bash
kubectl delete -f deployment.yaml
```

**📌 Notes**

Namespace: memcached-sample

Service type: ClusterIP (accessible inside the cluster)

Default Memcached port: 11211

