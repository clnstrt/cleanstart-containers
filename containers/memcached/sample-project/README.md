# Memcached Test Project

Simple Docker-based test to verify the `cleanstart/memcached:latest-dev` image functionality.

## Quick Start

### Step 1: Build the Image
```bash
docker build -t memcached-test .
```

### Step 2: Run the Container
```bash
docker run -d --name memcached-test -p 11211:11211 memcached-test
```

### Step 3: Test Memcached Functionality

#### Check if container is running:
```bash
docker ps
docker logs memcached-test
```

#### Test with stats command:
```bash
echo "stats" | nc localhost 11211
```

#### Test set operation:
```bash
printf "set testkey 0 900 5\r\nhello\r\n" | nc localhost 11211
```
Expected output: `STORED`

#### Test get operation:
```bash
echo "get testkey" | nc localhost 11211
```
Expected output:
```
VALUE testkey 0 5
hello
END
```

#### Test stats again:
```bash
echo "stats" | nc localhost 11211
```
Look for: `STAT curr_items 1` and `STAT total_items 1`

### Step 4: Cleanup
```bash
docker stop memcached-test
docker rm memcached-test
```

## What This Tests

The test verifies:
- ✅ Memcached container starts correctly
- ✅ Basic set/get operations work
- ✅ Memory management works
- ✅ Statistics tracking works
- ✅ Network connectivity works

## Expected Output

**Stats command:**
```
STAT pid 1
STAT uptime 123
STAT version 1.6.39
STAT limit_maxbytes 134217728
...
```

**Set operation:**
```
STORED
```

**Get operation:**
```
VALUE testkey 0 5
hello
END
```

## Troubleshooting

**"Failed to connect"**
- Make sure Docker is running
- Check container: `docker ps`
- Try: `docker logs memcached-test`

**"Port already in use"**
- Stop existing containers: `docker stop $(docker ps -q)`
- Or stop specific container: `docker stop memcached-test`

**"Command not found: nc"**
- Install netcat: `sudo apt install netcat-openbsd`
- Or use busybox telnet method above

## Project Files

```
sample-project/
├── Dockerfile    # Extends cleanstart/memcached with proper configuration
└── README.md     # This file
```

Simple 2-file project for memcached validation!
