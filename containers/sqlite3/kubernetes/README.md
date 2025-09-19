**📘 SQLite3 on Kubernetes**

This project demonstrates how to run SQLite3 inside Kubernetes using the cleanstart/sqlite3:latest
Since SQLite is a lightweight embedded database (not a server), it is mainly accessed from inside the pod using the SQLite CLI.

**📂 Contents**

deployment.yaml → Kubernetes Deployment, PVC, and Service manifest

README.md → Usage instructions (this file)

**🚀 Deploy to Kubernetes**

1. Apply Deployment

```bash
kubectl apply -f deployment.yaml
```

**Verify resources:**

```bash
kubectl get pods -n sqlite-sample
```

You should see a pod like:

```bash
NAME                                READY   STATUS    RESTARTS   AGE
sqlite-deployment-xxxxxx-xxxxx      1/1     Running   0          10s
```

**🛠️ Run CRUD Operations**

Since this is a minimal image, there is no shell (sh/bash).
You can directly exec into the SQLite CLI:

```bash
kubectl exec -it -n sqlite-sample deploy/sqlite-deployment -- sqlite3 /data/test.db
```

Now you will be inside the SQLite CLI.

**🔹 Create Table**
```bash
CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT);
```

**🔹 Insert Records**
```bash
INSERT INTO users(name) VALUES ('Alice');
INSERT INTO users(name) VALUES ('Bob');
```

**🔹 Read Records**
```bash
SELECT * FROM users;
```

**Expected output:**

```bash
1|Alice
2|Bob
```

**🔹 Update a Record**

```bash
UPDATE users SET name='Charlie' WHERE name='Alice';
SELECT * FROM users;
```

**🔹 Delete a Record**

```bash
DELETE FROM users WHERE name='Bob';
SELECT * FROM users;
```

**Exit SQLite CLI**

```bash
.quit
```

**📌 Notes**

Data is stored in /data/test.db and persists via the PersistentVolumeClaim.

✅ Now you can test SQLite inside Kubernetes with full CRUD support.