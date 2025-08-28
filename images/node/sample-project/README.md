# 🟢 Node.js Sample Projects

This directory contains sample projects for testing the `cleanstart/node` Docker image that you already pulled from Docker Hub. These examples demonstrate Node.js applications for web development, API development, and server-side JavaScript.

## 🚀 Quick Start

### Prerequisites
- Docker installed and running
- Port 3000 available (optional)

### Setup
```bash
# Navigate to this directory
cd images/node/sample-project

# Test the image (you already pulled cleanstart/node:latest from Docker Hub)
docker run --rm cleanstart/node:latest node --version
```

### Run Examples

#### Basic Node.js Application
```bash
# Run Node.js web app
docker run --rm -p 3000:3000 -v $(pwd):/app \
  cleanstart/node:latest node /app/app.js

# Access at http://localhost:3000
```

#### Package Management
```bash
# Install dependencies
docker run --rm -v $(pwd):/app cleanstart/node:latest \
  npm install

# Run with npm
docker run --rm -p 3000:3000 -v $(pwd):/app \
  cleanstart/node:latest npm start
```

#### Using Docker Compose
```bash
# Start Node.js application
docker-compose up -d

# Access application
curl http://localhost:3000
```

## 📁 Project Structure

```
sample-project/
├── README.md                    # This file
├── app.js                      # Main application file
├── package.json                # Node.js dependencies
├── views/                      # EJS templates
│   ├── index.ejs              # Main page template
│   ├── add_user.ejs           # Add user form
│   └── layout.ejs             # Layout template
├── Dockerfile                  # Docker configuration
├── setup.bat                   # Windows setup script
└── setup.sh                    # Linux/Mac setup script
```

## 🎯 Features

- Node.js web applications
- Express.js framework
- EJS templating engine
- RESTful APIs
- Database integration
- File uploads
- Authentication
- Real-time applications

## 📊 Output

Node.js applications generate:
- Web application responses
- API endpoints
- Database records
- Log files
- Static assets

## 🔒 Security

- Non-root user execution
- Secure Node.js configurations
- Input validation
- Error handling
- HTTPS support

## 🤝 Contributing

To add new Node.js applications:
1. Create JavaScript file in appropriate directory
2. Add documentation
3. Test with Node.js
