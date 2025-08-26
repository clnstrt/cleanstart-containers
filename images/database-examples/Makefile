# Makefile for Cross-Language Database Examples

.PHONY: all clean python javascript java c run-all

# Default target
all: python javascript java c

# Python example (no compilation needed)
python:
	@echo "Python example is ready to run: cd python && python database_example.py"

# JavaScript example (install dependencies)
javascript:
	@echo "Installing JavaScript dependencies..."
	cd javascript && npm install
	@echo "JavaScript example is ready to run: cd javascript && node database_example.js"

# Java example (download JDBC driver and compile)
java:
	@echo "Setting up Java example..."
	@if [ ! -f java/sqlite-jdbc-3.42.0.0.jar ]; then \
		echo "Downloading SQLite JDBC driver..."; \
		cd java && curl -O https://repo1.maven.org/maven2/org/xerial/sqlite-jdbc/3.42.0.0/sqlite-jdbc-3.42.0.0.jar; \
	fi
	@echo "Compiling Java example..."
	cd java && javac -cp ".:sqlite-jdbc-3.42.0.0.jar" DatabaseExample.java
	@echo "Java example is ready to run: cd java && java -cp '.:sqlite-jdbc-3.42.0.0.jar' DatabaseExample"

# C example (compile)
c:
	@echo "Compiling C example..."
	cd c && gcc -o database_example database_example.c -lsqlite3
	@echo "C example is ready to run: cd c && ./database_example"

# Run all examples
run-all: all
	@echo "Running all examples..."
	@echo "=== Python Example ==="
	cd python && python database_example.py
	@echo ""
	@echo "=== JavaScript Example ==="
	cd javascript && node database_example.js
	@echo ""
	@echo "=== Java Example ==="
	cd java && java -cp ".:sqlite-jdbc-3.42.0.0.jar" DatabaseExample
	@echo ""
	@echo "=== C Example ==="
	cd c && ./database_example

# Clean up generated files
clean:
	@echo "Cleaning up..."
	rm -f python/users.db
	rm -f javascript/users.db
	rm -f java/users.db
	rm -f c/users.db
	rm -f java/*.class
	rm -f c/database_example
	rm -rf javascript/node_modules
	rm -f java/sqlite-jdbc-3.42.0.0.jar
	@echo "Cleanup complete"

# Help target
help:
	@echo "Available targets:"
	@echo "  all        - Prepare all examples (default)"
	@echo "  python     - Prepare Python example"
	@echo "  javascript - Install dependencies and prepare JavaScript example"
	@echo "  java       - Download JDBC driver and compile Java example"
	@echo "  c          - Compile C example"
	@echo "  run-all    - Run all examples"
	@echo "  clean      - Remove generated files and databases"
	@echo "  help       - Show this help message"
