# Contributing to CleanStart Containers

Thank you for your interest in contributing to CleanStart Containers! This document provides guidelines and information for contributors.

## 🤝 How to Contribute

### Reporting Issues
- Use the GitHub issue tracker
- Provide clear, detailed descriptions
- Include steps to reproduce the issue
- Specify your environment (OS, Docker version, etc.)

### Suggesting Enhancements
- Open a feature request issue
- Describe the enhancement clearly
- Explain the benefits and use cases
- Consider implementation complexity

### Code Contributions
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Add tests if applicable
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## 📋 Development Guidelines

### Code Style
- Follow language-specific conventions
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

### Docker Best Practices
- Use multi-stage builds when appropriate
- Minimize layer count
- Use specific base image versions
- Include health checks
- Document exposed ports

### Testing
- Write unit tests for new functionality
- Ensure all tests pass before submitting
- Include integration tests for containerized apps
- Test across different environments

### Documentation
- Update README files when adding new features
- Include usage examples
- Document any new dependencies
- Update the main project README if needed

## 🏗️ Project Structure

### Adding New Applications
When adding a new application container:

1. **Create the directory structure:**
   ```
   containers/app-name/
   ├── Dockerfile
   ├── README.md
   ├── src/
   └── test/
   ```

2. **Dockerfile requirements:**
   - Use appropriate base image
   - Install dependencies efficiently
   - Set working directory
   - Expose necessary ports
   - Include health check

3. **README.md requirements:**
   - Application description
   - Setup instructions
   - Usage examples
   - API documentation (if applicable)
   - Troubleshooting section

### Database Examples
When adding new database examples:

1. Follow the existing pattern in `database-examples/`
2. Use the same database schema
3. Include proper error handling
4. Add to the Makefile for easy execution
5. Update the main documentation

## 🔧 Development Setup

### Prerequisites
```bash
# Install Docker and Docker Compose
# Install Python 3.x
# Install Node.js (for app2)
# Install Java 8+ (for app1)
```

### Local Development
```bash
# Clone the repository
git clone https://github.com/your-username/cleanstart-containers.git
cd cleanstart-containers

# Set up Python virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install development dependencies
pip install -r requirements.txt
```

### Testing Your Changes
```bash
# Test individual applications
cd containers/app1 && docker build -t app1-test .
cd containers/app2 && docker build -t app2-test .
cd containers/app3 && docker build -t app3-test .

# Test database examples
cd containers/database-examples
make run-all
```

## 📝 Commit Guidelines

Use conventional commit messages:
- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation changes
- `style:` for formatting changes
- `refactor:` for code refactoring
- `test:` for adding tests
- `chore:` for maintenance tasks

Example:
```
feat: add Python Flask application to app3

- Add Flask web application with user management
- Include SQLite database integration
- Add Docker configuration
- Update documentation
```

## 🚀 Release Process

1. Update version numbers in relevant files
2. Update CHANGELOG.md with new features/fixes
3. Create a release tag
4. Update documentation
5. Test all applications
6. Deploy to production (if applicable)

## 📞 Getting Help

- **Issues:** Use GitHub issues for bugs and feature requests
- **Discussions:** Use GitHub Discussions for questions and ideas
- **Email:** Contact maintainers directly for sensitive issues

## 📄 License

By contributing to CleanStart Containers, you agree that your contributions will be licensed under the MIT License.

## 🙏 Acknowledgments

Thank you to all contributors who have helped make this project better!
