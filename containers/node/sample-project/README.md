# Execute Node.js Web Application on CleanStart Container - Node.js

A modern web application for user management built with **Node.js**, **Express**, and **EJS**.

## Objective

The objective of this project is to utilize CleanStart Container Image - Node.js and build a lightweight, containerized web application in Node.js that provides a user-friendly interface and REST APIs for performing user management operations.

## Summary

This project demonstrates how to combine Node.js, Express, EJS, and CleanStart to create a modern web application. It offers both a web-based dashboard and API endpoints to manage users—supporting create, read, update, and delete (CRUD) operations—packaged in a Dockerized environment for easy deployment and scalability.

## Quick Start - Run Locally

### Prerequisites
Pull CleanStart Node.js image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart) 
```bash
docker pull cleanstart/node:latest
```

### Step 1: Navigate to Node.js Directory
```bash
cd containers/node/sample-project
```

### Step 2: Build and Run the Application
### Make Dockerfile
```bash
# Base image with Node.js pre-installed
FROM cleanstart/node:latest

# Set working directory
WORKDIR /app

# Copy package.json first (for caching dependencies)
COPY package.json ./

# Install dependencies
RUN npm install

# Copy the source code
COPY . .

# Expose port
EXPOSE 3000

# Run the application
CMD ["npm", "start"]
```

### Step 3: Build the image
```bash
docker build -t node-web-app .
```

### Step 4: Run the image
```bash
docker run --rm -p 3000:3000 node-web-app
```

### Step 5: Access the Web Application
```bash
docker run --rm -p 3000:3000 cleanstart/node:latest node app.js
```

Open your browser and go to: **http://localhost:3000**

### Node.js Build Output
You should see output like this:
```
npm WARN deprecated express@4.18.2: express 4.18.2 is a security release
npm WARN deprecated express@4.18.2: express 4.18.2 is a security release
added 50 packages, and audited 51 packages in 2s
Server running on http://localhost:3000
```

### Application Access
Once started, you can access the application at: **http://localhost:3000**

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

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [Node.js Official Documentation](https://nodejs.org/en/docs/)
- [Express.js Documentation](https://expressjs.com/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).
