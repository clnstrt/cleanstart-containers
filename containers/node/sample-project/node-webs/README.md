# Node.js Web Applications

Node.js applications for CleanStart containers.

## Files

- `app.js` - Full web application with user management
- `hello_world.js` - Interactive console application
- `package.json` - Dependencies
- `Dockerfile` - Container config
- `Dockerfile.simple` - Simple container config

## Quick Start

### Interactive Hello World
```bash
docker run --rm -it -v $(pwd):/app -w /app cleanstart/node:latest node hello_world.js
```

### Simple Hello World (HTTP Server)
```bash
docker build -f Dockerfile.simple -t my-node-app .
docker run -d -p 3000:3000 --name my-app my-node-app
curl http://localhost:3000
```

### Full Web Application
```bash
cd ..
docker build -f node-webs/Dockerfile -t my-web-app .
docker run -d -p 3000:3000 --name my-web-app my-web-app
```

## Applications

### Interactive Hello World
- Console application
- Asks for user input
- Output: "Hello, World! Welcome to Node.js!"

### Full Web Application
- User management system
- SQLite database
- REST API endpoints
- Modern UI with Bootstrap

### API Endpoints
- `GET /` - Dashboard
- `GET /add` - Add user form
- `POST /add` - Create user
- `GET /api/users` - Get all users
- `POST /api/users` - Create user
- `GET /health` - Health check

## Development

```bash
# Install dependencies
npm install

# Run web app
npm start

# Run interactive hello world
node hello_world.js

# Test
npm test
```

## Dependencies

- express - Web framework
- sqlite3 - Database
- ejs - Template engine
- body-parser - Request parsing
- method-override - HTTP method override

## Troubleshooting

- **Module not found**: Use `cleanstart/node:latest-dev` for building
- **Port in use**: Use different port `-p 3001:3000`
- **Permission issues**: Containers run as non-root user

## Resources

- [CleanStart Docker Hub](https://hub.docker.com/u/cleanstart)
- [Node.js Docs](https://nodejs.org/en/docs/)
- [Express.js Docs](https://expressjs.com/)
