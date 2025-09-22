**Executable permissions**

```bash
chmod +x server.sh
```

**Build Dockerfile**

```bash
docker build -t velero-aws-webtest .
```

**Run the Image**

```bash
docker run --rm -p 8080:8080 velero-aws-webtest
```

Then visit http://localhost:8080 

