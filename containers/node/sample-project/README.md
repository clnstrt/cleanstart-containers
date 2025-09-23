# Node.js Sample Project

Node.js applications for CleanStart containers.

## Quick Start

### 1. Pull Images
```bash
docker pull cleanstart/node:latest
docker pull cleanstart/node:latest-dev
```

### 2. Simple Hello World (HTTP Server)
```bash
cd containers/node/sample-project
docker build -f node-webs/Dockerfile.simple -t node-hello-world .
docker run -d -p 3000:3000 --name my-hello-world node-hello-world
curl http://localhost:3000
```

### 3. Interactive Hello World (Console)
```bash
docker run --rm -it -v $(pwd)/node-webs:/app -w /app cleanstart/node:latest node hello_world.js
```

### 4. Full Web Application
```bash
docker build -f node-webs/Dockerfile -t my-web-app .
docker run -d -p 3000:3000 --name my-web-app my-web-app
```

## Applications

- **Simple Hello World** - HTTP server responding "Hello, World from Node!"
- **Interactive Hello World** - Console app with user input
- **Full Web App** - User management system with SQLite, REST API, modern UI

## Commands

```bash
# View containers
docker ps

# Stop container
docker stop my-hello-world

# View logs
docker logs my-hello-world

# Remove container
docker rm my-hello-world
```

## Troubleshooting

- **Port in use**: Use different port `-p 3001:3000`
- **Container won't start**: Check logs with `docker logs <container-name>`
- **Permission issues**: Containers run as non-root user for security

## Resources

- [CleanStart Docker Hub](https://hub.docker.com/u/cleanstart)
- [Node.js Docs](https://nodejs.org/en/docs/)
- [Express.js Docs](https://expressjs.com/)
