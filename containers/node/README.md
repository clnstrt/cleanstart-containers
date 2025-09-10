# Node.js Docker Image

A JavaScript runtime built on Chrome's V8 JavaScript engine for building scalable network applications.

## Pull Image
```bash
docker pull cleanstart/node:latest
```

## Run Container
```bash
# Interactive run
docker run -it --rm cleanstart/node:latest

# Run with volume mount
docker run -it --rm -v $(pwd):/app -w /app cleanstart/node:latest

# Run Node.js program
docker run --rm -v $(pwd):/app -w /app cleanstart/node:latest node hello_world.js
```

## Check Version
```bash
docker run --rm cleanstart/node:latest node --version
```

## Check Image Size
```bash
docker images cleanstart/node:latest
```

## Test Container
```bash
# Test Node.js installation
docker run --rm cleanstart/node:latest node --version

# Run hello world
docker run --rm cleanstart/node:latest node hello_world.js
```

## Sample Projects
For detailed usage examples and demonstrations, see the `sample-project/` directory.
