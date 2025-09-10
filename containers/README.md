# Hello World Programs

This directory contains simple "Hello World" programs in different programming languages.

## Available Languages

- **Python**: `hello_world.py`
- **Java**: `HelloWorld.java`
- **Ruby**: `hello_world.rb`
- **Go**: `hello_world.go`
- **Node.js**: `hello_world.js`

## How to Run

### Python
```bash
cd containers/python
python3 hello_world.py
```

### Java
```bash
cd containers/java
javac HelloWorld.java
java HelloWorld
```

### Ruby
```bash
cd containers/Ruby
ruby hello_world.rb
```

### Go
```bash
cd containers/go
go run hello_world.go
```

### Node.js
```bash
cd containers/node
node hello_world.js
```

## Features

Each Hello World program:
- Prints "Hello, World!" and a welcome message
- Asks for the user's name
- Displays a personalized greeting

## Prerequisites

Make sure you have the following installed:
- **Python**: Python 3.x
- **Java**: JDK 8 or higher
- **Ruby**: Ruby 2.x or higher
- **Go**: Go 1.x or higher
- **Node.js**: Node.js 14.x or higher

## Quick Test

You can test all programs at once using Docker (if available):

```bash
# Python
docker run --rm -v $(pwd)/containers/python:/app -w /app python:3.9 python3 hello_world.py

# Java
docker run --rm -v $(pwd)/containers/java:/app -w /app openjdk:11 javac HelloWorld.java && java HelloWorld

# Ruby
docker run --rm -v $(pwd)/containers/Ruby:/app -w /app ruby:3.0 ruby hello_world.rb

# Go
docker run --rm -v $(pwd)/containers/go:/app -w /app golang:1.19 go run hello_world.go

# Node.js
docker run --rm -v $(pwd)/containers/node:/app -w /app node:16 node hello_world.js
```

Enjoy exploring different programming languages! 🚀
