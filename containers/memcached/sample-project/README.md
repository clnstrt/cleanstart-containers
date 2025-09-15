# 🚀 Memcached Sample Projects

This directory contains sample projects demonstrating Memcached caching capabilities, session management, and performance optimization techniques.

## 📁 Sample Projects

### 1. Basic Operations (`basic-operations/`)
- **Cache Operations**: SET, GET, DELETE operations
- **Data Types**: String, numeric, and binary data handling
- **Expiration**: TTL and expiration management

### 2. Advanced Features (`advanced-features/`)
- **Atomic Operations**: CAS (Compare and Swap) operations
- **Statistics**: Performance monitoring and statistics
- **Memory Management**: Memory allocation and optimization

### 3. Web Applications (`web-applications/`)
- **Python Flask App**: Web application with Memcached caching
- **Node.js Express App**: REST API with Memcached session store
- **PHP Application**: PHP application with Memcached integration

### 4. Performance Testing (`performance-testing/`)
- **Load Testing**: Performance benchmarking tools
- **Memory Profiling**: Memory usage analysis
- **Connection Pooling**: Connection management optimization

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose
- Basic understanding of caching concepts
- Programming language knowledge (Python, Node.js, PHP)

### Running Memcached Locally

1. **Clone and Navigate**:
```bash
cd containers/memcached/sample-project
```

2. **Start Memcached Container**:
```bash
docker run --rm -d -p 11211:11211 --name memcached cleanstart/memcached:latest
```

3. **Test Connection**:
```bash
echo "stats" | nc localhost 11211
```

4. **Run Sample Scripts**:
```bash
python basic-operations/test_memcached.py
```

### Running Web Applications

1. **Start Python Flask App**:
```bash
cd web-applications/python-flask
docker-compose up -d
```

2. **Access the Application**:
```bash
curl http://localhost:5000/api/cache/test
```

3. **Start Node.js Express App**:
```bash
cd web-applications/node-express
docker-compose up -d
```

## 📚 Memcached Examples

### Basic Cache Operations
```python
import memcache

# Connect to Memcached
mc = memcache.Client(['localhost:11211'])

# Set a value
mc.set('user:1', 'John Doe', time=3600)  # Expires in 1 hour

# Get a value
user = mc.get('user:1')
print(user)  # Output: John Doe

# Delete a value
mc.delete('user:1')

# Set multiple values
mc.set_multi({
    'user:1': 'John Doe',
    'user:2': 'Jane Smith',
    'user:3': 'Bob Wilson'
})

# Get multiple values
users = mc.get_multi(['user:1', 'user:2', 'user:3'])
print(users)
```

### Advanced Operations
```python
# Atomic operations with CAS
def update_user_counter(user_id):
    while True:
        counter = mc.gets(f'counter:{user_id}')
        if counter is None:
            counter = 0
        counter += 1
        if mc.cas(f'counter:{user_id}', counter):
            break
    return counter

# Increment/Decrement operations
mc.incr('page_views', 1)  # Increment by 1
mc.decr('remaining_items', 1)  # Decrement by 1

# Check and set
if mc.get('lock:resource') is None:
    mc.set('lock:resource', 'locked', time=60)
    # Perform critical section
    mc.delete('lock:resource')
```

### Session Management
```python
import json
import time

class MemcachedSession:
    def __init__(self, mc_client):
        self.mc = mc_client
        self.session_timeout = 3600  # 1 hour
    
    def create_session(self, user_id, data):
        session_id = f"session:{user_id}:{int(time.time())}"
        session_data = {
            'user_id': user_id,
            'data': data,
            'created_at': time.time(),
            'last_access': time.time()
        }
        self.mc.set(session_id, json.dumps(session_data), time=self.session_timeout)
        return session_id
    
    def get_session(self, session_id):
        session_data = self.mc.get(session_id)
        if session_data:
            data = json.loads(session_data)
            data['last_access'] = time.time()
            self.mc.set(session_id, json.dumps(data), time=self.session_timeout)
            return data
        return None
```

## 🧪 Testing Memcached

### Basic Testing
```bash
# Test connection
echo "version" | nc localhost 11211

# Test basic operations
echo -e "set test 0 0 4\r\ntest\r\n" | nc localhost 11211
echo -e "get test\r\n" | nc localhost 11211

# Check statistics
echo "stats" | nc localhost 11211
```

### Performance Testing
```python
import time
import threading
import memcache

def benchmark_memcached():
    mc = memcache.Client(['localhost:11211'])
    
    # Test SET operations
    start_time = time.time()
    for i in range(10000):
        mc.set(f'key:{i}', f'value:{i}')
    set_time = time.time() - start_time
    
    # Test GET operations
    start_time = time.time()
    for i in range(10000):
        mc.get(f'key:{i}')
    get_time = time.time() - start_time
    
    print(f"SET operations: {10000/set_time:.2f} ops/sec")
    print(f"GET operations: {10000/get_time:.2f} ops/sec")

benchmark_memcached()
```

### Memory Testing
```bash
# Check memory usage
echo "stats" | nc localhost 11211 | grep "bytes"

# Monitor memory allocation
echo "stats slabs" | nc localhost 11211

# Check item statistics
echo "stats items" | nc localhost 11211
```

## 🔧 Configuration

### Memcached Configuration
```bash
# Memory allocation
memcached -m 64  # 64MB memory

# Connection limits
memcached -c 1024  # Max 1024 connections

# Thread count
memcached -t 4  # 4 threads

# Verbose logging
memcached -v  # Verbose output

# Custom port
memcached -p 11212  # Port 11212
```

### Environment Variables
```bash
export MEMCACHED_MEMORY=128
export MEMCACHED_MAX_CONNECTIONS=2048
export MEMCACHED_THREADS=8
export MEMCACHED_PORT=11211
```

## 📊 Monitoring

### Statistics Monitoring
```python
import memcache

mc = memcache.Client(['localhost:11211'])

# Get statistics
stats = mc.get_stats()
print("Memcached Statistics:")
for server, stats_dict in stats:
    print(f"Server: {server}")
    for key, value in stats_dict.items():
        print(f"  {key}: {value}")
```

### Health Checks
```python
def check_memcached_health():
    try:
        mc = memcache.Client(['localhost:11211'])
        mc.set('health_check', 'ok', time=10)
        result = mc.get('health_check')
        return result == 'ok'
    except:
        return False

if check_memcached_health():
    print("Memcached is healthy")
else:
    print("Memcached is not responding")
```

## 🛠️ Troubleshooting

### Common Issues
1. **Connection Refused**: Check if Memcached is running
2. **Memory Full**: Increase memory allocation or implement eviction
3. **Slow Performance**: Optimize connection pooling and data size

### Debug Commands
```bash
# Check if Memcached is running
ps aux | grep memcached

# Check port usage
netstat -tlnp | grep 11211

# Monitor connections
echo "stats" | nc localhost 11211 | grep "curr_connections"
```

## 📚 Resources

- [Memcached Documentation](https://github.com/memcached/memcached/wiki)
- [Memcached Protocol](https://github.com/memcached/memcached/wiki/Protocol)
- [CleanStart Website](https://www.cleanstart.com/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Adding new Memcached examples
- Improving documentation
- Reporting issues
- Suggesting new features

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
