# Memcached Demo Project (Standalone Docker)

A comprehensive demonstration of Memcached caching patterns using Docker without Docker Compose

## Quick Start

### 1. Clone or create the project
```bash
cd cleanstart-containers/containers/memcached/sample-project
```

# Execute the command
```bash
docker run -d --name memcached-demo -p 11211:11211 cleanstart/memcached:latest-dev memcached -m 128 -p 11211 -u memcache -l 0.0.0.0 -vv
```

# Execute the requirements.txt first 
```bash
pip install -r requirements.txt
```
# Execute the actual python script
python3 app.py

# Execute the another python script to check cache related logs!
python3 test_memcached.py

# Exit the script after the execution and close the localhost!
