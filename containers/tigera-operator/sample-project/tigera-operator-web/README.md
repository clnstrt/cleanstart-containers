## Build Docker file

```bash
docker build -t tigera-operator-web .
```

## Run the image

```bash
docker run -d --name tigera-op -p 8080:8080 tigera-operator-web
```

## View Logs

```bash
docker logs -f tigera-op
```bash