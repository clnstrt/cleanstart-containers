# 🚀 Argo-Workflow-Exec Sample

A simple test for CleanStart Argo Workflow Exec container.

## Quick Start

### Option 1: Automated Build and Test
```bash
# Run the automated build and test script
./build-and-test.sh
```

### Option 2: Manual Build and Run
```bash
# Build the Docker image
docker build -t argo-test .

# Run the container
docker run --rm argo-test
```

### Option 3: Test Base Image Directly
```bash
# Test the base image directly
docker run --rm cleanstart/argo-workflow-exec:latest-dev --help
```

## Expected Output

The enhanced test script will provide detailed information about the environment and argoexec availability:

```bash
🚀 Testing argoexec...
Script is running...
Current user: clnstrt
Current directory: /
PATH: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

✅ argoexec found in PATH
Running argoexec --help:
----------------------------------------
argoexec is the executor sidecar to workflow containers

Usage:
  argoexec [flags]
  argoexec [command]

Available Commands:
  agent       
  artifact    
  completion  Generate the autocompletion script for the specified shell
  data        Process data
  emissary    
  help        Help about any command
  init        Load artifacts
  kill        
  resource    update a resource and wait for resource conditions
  version     Print version information
  wait        wait for main container to finish and save artifacts
----------------------------------------

Testing argoexec version:
argoexec version v3.4.4

🔍 Additional system information:
Operating System: Linux x86_64
Available disk space:
Filesystem      Size  Used Avail Use% Mounted on
overlay          20G  1.2G   18G   7% /

Test completed.
```

If argoexec is not found, the script will search common locations and provide debugging information.

## 📚 Resources

- [CleanStart](https://cleanstart.com/)
- [Argo Workflows](https://argoproj.github.io/argo-workflows/)