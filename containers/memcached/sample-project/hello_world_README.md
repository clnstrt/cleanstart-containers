# 🚀 Memcached Hello World

Welcome to the Memcached Hello World example! This simple example demonstrates how to get started with Memcached for high-performance caching.

## 📋 What is Memcached?

Memcached is a high-performance, distributed memory object caching system. It provides:

- **In-Memory Storage**: Ultra-fast data access
- **Distributed**: Scale across multiple servers
- **Simple Protocol**: Easy to integrate
- **High Performance**: Sub-millisecond response times
- **Expiration Support**: Automatic key expiration

## 🚀 Quick Start

### Prerequisites

- Python 3.6+
- Memcached server (optional - uses mock for demo)

### Running the Hello World

1. **Run the Python script:**
   ```bash
   python hello_world.py
   ```

2. **With real Memcached server:**
   ```bash
   # Start Memcached server
   memcached -d -p 11211
   
   # Run the script
   python hello_world.py
   ```

3. **With Docker:**
   ```bash
   # Start Memcached container
   docker run -d -p 11211:11211 memcached:latest
   
   # Run the script
   python hello_world.py
   ```

## 📊 What the Hello World Does

The `hello_world.py` script demonstrates:

1. **Basic Operations**: SET, GET, DELETE operations
2. **Data Types**: Strings, numbers, lists, dictionaries
3. **Expiration**: Time-based key expiration
4. **Counters**: Increment/decrement operations
5. **Multi-Operations**: Batch operations
6. **Session Management**: User session caching
7. **Cache Patterns**: Cache-aside pattern

## 🔧 Basic Operations

### SET Operation
```python
mc.set("key", "value")
mc.set("number", 42)
mc.set("expires_in_5_sec", "temp", time=5)
```

### GET Operation
```python
value = mc.get("key")
number = mc.get("number")
```

### DELETE Operation
```python
mc.delete("key")
```

## ⏰ Expiration

Memcached supports automatic key expiration:

```python
# Set key with 5 second expiration
mc.set("temp_key", "value", time=5)

# Key will be automatically deleted after 5 seconds
```

## 🔢 Counter Operations

Memcached provides atomic counter operations:

```python
# Initialize counter
mc.set("counter", 0)

# Increment counter
mc.incr("counter")  # Returns 1
mc.incr("counter")  # Returns 2

# Decrement counter
mc.decr("counter")  # Returns 1
```

## 📦 Multi-Operations

Batch operations for efficiency:

```python
# Set multiple keys
mc.set("user:1", {"name": "John"})
mc.set("user:2", {"name": "Jane"})

# Get multiple keys
values = mc.get_multi(["user:1", "user:2", "user:3"])
```

## 🔐 Session Management

Common use case for Memcached:

```python
# Store user session
session_data = {
    "user_id": 123,
    "username": "john_doe",
    "login_time": "2024-01-15T10:30:00"
}
mc.set("session:12345", session_data, time=3600)  # 1 hour

# Retrieve session
session = mc.get("session:12345")
```

## 🎯 Cache Patterns

### Cache-Aside Pattern
```python
def get_user_data(user_id):
    cache_key = f"user:{user_id}"
    user_data = mc.get(cache_key)
    
    if user_data is None:
        # Cache miss - fetch from database
        user_data = fetch_from_database(user_id)
        mc.set(cache_key, user_data, time=300)  # 5 minutes
    
    return user_data
```

## 🛠️ Key Features Demonstrated

- **CRUD Operations**: Create, Read, Update, Delete
- **Expiration**: Automatic key expiration
- **Atomic Operations**: Thread-safe counter operations
- **Batch Operations**: Multi-key operations
- **Session Storage**: User session management
- **Cache Patterns**: Common caching strategies

## 📚 Next Steps

1. **Install Real Memcached**: Set up actual Memcached server
2. **Web Integration**: Check out `web-integration/` for Flask examples
3. **Production Patterns**: Learn advanced caching strategies
4. **Monitoring**: Set up Memcached monitoring

## 🔧 Configuration

The hello world uses default Memcached settings:

- **Port**: 11211
- **Memory**: Default allocation
- **Threads**: Default thread count
- **Expiration**: Supported

## 🆘 Troubleshooting

### Common Issues

1. **Connection Refused**: Memcached server not running
2. **Key Not Found**: Key expired or never set
3. **Memory Full**: Memcached memory limit reached

### Debug Commands

```bash
# Check if Memcached is running
telnet localhost 11211

# Monitor Memcached stats
echo "stats" | nc localhost 11211

# Check Memcached logs
tail -f /var/log/memcached.log
```

## 📖 Learn More

- [Memcached Documentation](https://memcached.org/)
- [Python Memcached Library](https://pypi.org/project/python-memcached/)
- [Memcached Best Practices](https://memcached.org/about)

## 🎯 Use Cases

Memcached is perfect for:

- **Web Applications**: Page caching, session storage
- **Database Caching**: Reduce database load
- **API Caching**: Cache API responses
- **Session Storage**: User session management
- **Real-time Data**: Fast data access
- **Distributed Systems**: Shared cache across services

---

**Happy Caching with Memcached!** ⚡
