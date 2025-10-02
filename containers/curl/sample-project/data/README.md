# Data Directory

This directory will contain downloaded files when running the sample scripts.

To download files, run:
```bash
# Create this directory first
mkdir -p ./data

# Then run file operations script
docker run --rm -v $(pwd):/workspace cleanstart/curl:latest \
  bash /workspace/basic-examples/file-operations.sh
```
