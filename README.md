# CleanStart Containers

A collection of containerized applications demonstrating cross-language database operations and web development patterns.

## 🏗️ Project Structure

```
cleanstart-containers/
├── containers/
│   ├── app1/           # Java Spring Boot application
│   ├── app2/           # Node.js/Express application  
│   ├── app3/           # Python Flask application
│   └── database-examples/  # Cross-language database examples
├── tools/              # Development and documentation tools
└── venv/              # Python virtual environment
```

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose
- Python 3.x
- Node.js (for app2)
- Java 8+ (for app1)

### Running Applications

#### Option 1: Run All Applications
```bash
# Build and run all containers
docker-compose up --build
```

#### Option 2: Run Individual Applications

**App1 (Java Spring Boot)**
```bash
cd containers/app1
docker build -t app1 .
docker run -p 8080:8080 app1
```

**App2 (Node.js Express)**
```bash
cd containers/app2
docker build -t app2 .
docker run -p 3000:3000 app2
```

**App3 (Python Flask)**
```bash
cd containers/app3
docker build -t app3 .
docker run -p 5000:5000 app3
```

## 📚 Database Examples

The `database-examples` directory contains cross-language examples showing how to work with SQLite databases:

- **Python** - Using built-in sqlite3 module
- **JavaScript** - Using sqlite3 npm package
- **Java** - Using JDBC with SQLite
- **C** - Using SQLite C API
- **Web Application** - Flask web interface

```bash
cd containers/database-examples
make run-all
```

## 🛠️ Development

### Adding New Applications
1. Create a new directory in `containers/`
2. Add a `Dockerfile` and `README.md`
3. Include source code in `src/` directory
4. Add tests in `test/` directory

### Building Documentation
```bash
cd tools/overview-generator
python generate.py
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## 📞 Support

For questions or issues, please open an issue on GitHub or contact the maintainers.
