# Step CLI Docker Image

A zero-trust network identity and certificate management tool for PKI operations.

## Pull Image
```bash
docker pull cleanstart/step-cli:latest
```

## Run Container
```bash
# Interactive run
docker run -it --rm cleanstart/step-cli:latest

# Run with volume mounts
docker run -it --rm -v $(pwd)/certs:/app/certs -v $(pwd)/secrets:/app/secrets cleanstart/step-cli:latest

# Run Step CLI commands
docker run --rm -v $(pwd):/app -w /app cleanstart/step-cli:latest step version
```

## Check Version
```bash
docker run --rm cleanstart/step-cli:latest step version
```

## Check Image Size
```bash
docker images cleanstart/step-cli:latest
```

## Test Container
```bash
# Test Step CLI installation
docker run --rm cleanstart/step-cli:latest step version

# Run hello world
docker run --rm cleanstart/step-cli:latest python hello_world.py
```

## Sample Projects
For detailed usage examples and demonstrations, see the `sample-project/` directory.
