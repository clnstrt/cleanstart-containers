# BusyBox Basic Examples

Three demonstration scripts showcasing BusyBox capabilities:

- **filesystem.sh** - File operations and utilities
- **networking.sh** - Network connectivity and web requests  
- **process.sh** - Process management and background jobs

## Setup

Make scripts executable:
```bash
chmod +x ./filesystem.sh
chmod +x ./networking.sh
chmod +x ./process.sh
```

## Usage

```bash
./filesystem.sh
./networking.sh
./process.sh
```

**Optional networking parameters:**
```bash
./networking.sh [ping_target] [wget_url]
```

## Docker

```bash
docker run -it --rm cleanstart/busybox:latest-dev
chmod +x *.sh
./filesystem.sh
./networking.sh
./process.sh
```
