### Executable permissions
```bash
chmod +x server.sh
```

### Build Docker file
```bash
docker build -t stakater-demo-web .
```

### Start the container:
```bash
docker run --rm -p 8080:8080 stakater-demo-web
```