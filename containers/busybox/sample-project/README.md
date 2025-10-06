# 🚀 BusyBox HTTP Server Sample Project

A simple BusyBox HTTP server that serves files and demonstrates CleanStart container capabilities.

## Quick Start

### 1. Build the Image
```bash
docker build --no-cache -t my-cleanstart-busybox .
```

### 2. Run the Container
```bash
docker run --rm -p 8080:8080 my-cleanstart-busybox
```

### 3. Access the Server
Open your browser and visit:
- **Main page**: http://localhost:8080
- **JSON data**: http://localhost:8080/data.json

## What It Does

- ✅ **Smart Directory Selection**: Automatically finds a writable directory for web files
- ✅ **HTTP Server**: Serves HTML and JSON content on port 8080
- ✅ **Fallback Support**: Uses netcat if BusyBox httpd applet is not available
- ✅ **File Serving**: Serves both `index.html` and `data.json` files
- ✅ **Error Handling**: Graceful fallbacks for missing files and directories

## Expected Output
```bash
🚀 Cleanstart BusyBox started as user: clnstrt
📦 BusyBox version: BusyBox v1.37.0 (2025-07-11 07:44:34 UTC) multi-call binary.
✅ Created web directory: /tmp/www
✅ Copied data.json from /work
🚀 Starting BusyBox HTTP server on port 8080...
📁 Serving files from /tmp/www directory
⚠️  httpd applet not available, using simple HTTP server
⏳ BusyBox HTTP server is running at http://localhost:8080
```

## Files Included
- `Dockerfile` - Container build configuration
- `start.sh` - Main script that sets up and runs the HTTP server
- `data.json` - Sample JSON data file
- `docker-compose.yml` - Docker Compose configuration

## Troubleshooting

**Permission Denied Errors**: The script automatically tries multiple directories and falls back gracefully.

**HTTP Server Not Responding**: Ensure port 8080 is exposed with `-p 8080:8080`.

**httpd Applet Not Available**: This is normal - the script uses netcat as a fallback.

## Directory Structure
```bash
cleanstart-containers/
└── busybox
    └── sample-project/                  # Root sample project folder                    
        ├── Dockerfile                   # Container build file
        ├── start.sh                     # Main HTTP server script
        ├── data.json                    # Sample JSON data
        ├── docker-compose.yml           # Docker Compose config
        └── README.md                    # This file
```
