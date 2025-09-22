Build & Run
# Build the wrapper image
```bash
docker build -t tigera-operator-test .
```

# Run (default shows help output)
```bash
docker run --rm tigera-operator-test
```

To explore the container interactively:
```bash
docker run -it --rm tigera-operator-test /bin/sh
```

Notes

The default entrypoint is /usr/bin/operator.

The default user is clnstrt.

The container expects a Kubernetes environment. Running it standalone is for testing and inspection only.

Use --help to list available options:
```bash
docker run --rm cleanstart/tigera-operator:latest
```