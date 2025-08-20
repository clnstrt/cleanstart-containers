# Container Documentation Generator Makefile
# Common commands for using the overview generator

.PHONY: help install test clean example docs unit-test lint

# Default target
help:
	@echo "Container Documentation Generator - Available Commands:"
	@echo ""
	@echo "  install    - Install Python dependencies"
	@echo "  test       - Run setup tests to verify installation"
	@echo "  unit-test  - Run unit tests"
	@echo "  lint       - Run code linting"
	@echo "  example    - Run example script with sample containers"
	@echo "  docs       - Generate documentation for common containers"
	@echo "  clean      - Clean generated files and cache"
	@echo "  help       - Show this help message"
	@echo ""
	@echo "Examples:"
	@echo "  make docs"
	@echo "  python generate.py nginx redis postgres"
	@echo "  python example.py"

# Install dependencies
install:
	@echo "📦 Installing Python dependencies..."
	@pip install -r requirements.txt
	@echo "✅ Dependencies installed successfully!"

# Run setup tests
test:
	@echo "🧪 Running setup tests..."
	@python test_setup.py

# Run unit tests
unit-test:
	@echo "🧪 Running unit tests..."
	@python -m pytest test_generator.py -v

# Run code linting (if flake8 is available)
lint:
	@echo "🔍 Running code linting..."
	@if command -v flake8 >/dev/null 2>&1; then \
		flake8 generate.py example.py test_*.py --max-line-length=120 --ignore=E501,W503; \
		echo "✅ Linting completed!"; \
	else \
		echo "⚠️  flake8 not found. Install with: pip install flake8"; \
	fi

# Run example script
example:
	@echo "🚀 Running example script..."
	@python example.py

# Generate docs for common containers
docs:
	@echo "📝 Generating documentation for common containers..."
	@python generate.py nginx redis postgres mongodb elasticsearch

# Clean generated files
clean:
	@echo "🧹 Cleaning generated files..."
	@rm -rf responses/
	@rm -rf __pycache__/
	@rm -rf *.pyc
	@rm -rf .pytest_cache/
	@rm -rf *.egg-info/
	@find . -name "*.pyc" -delete
	@find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
	@echo "✅ Cleanup completed!"

# Create .env file template
env-template:
	@echo "🔧 Creating .env template..."
	@echo "# Anthropic Claude API Key" > .env.template
	@echo "GROK_API_KEY=your_api_key_here" >> .env.template
	@echo "✅ .env.template created!"
	@echo "📝 Copy .env.template to .env and add your API key"

# Setup complete environment
setup: install env-template
	@echo "🎉 Setup completed!"
	@echo "📝 Next steps:"
	@echo "1. Copy .env.template to .env"
	@echo "2. Add your GROK_API_KEY to .env"
	@echo "3. Run: make test"
	@echo "4. Run: make unit-test"
	@echo "5. Run: make example"

# Full test suite
test-all: test unit-test lint
	@echo "🎉 All tests completed!"

# Development setup
dev-setup: setup
	@echo "📦 Installing development dependencies..."
	@pip install pytest flake8
	@echo "✅ Development environment ready!"
