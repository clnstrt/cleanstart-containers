# 🚀 Hello from Argo-Workflow-Exec!!! 

A simple  program to run on CleanStart - Argo Workflow Exec container. 


### Pull CleanStart Argo Workflow Exec image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart) 
```bash
docker pull cleanstart/argo-workflow-exec:latest
```
```bash
docker pull cleanstart/argo-workflow-exec:latest-dev
```
## Build with Dockerfile
```bash
FROM cleanstart/argo-workflow-exec:latest-dev
USER root
COPY test-argoexec.sh /test-argoexec.sh
RUN chmod +x /test-argoexec.sh
ENTRYPOINT ["/test-argoexec.sh"]
CMD []
```

## Create a script 
```bash
#!/bin/bash

# Simple script to check if argoexec is functional.

# Check for the argoexec binary in common locations
if [ -f "/usr/local/bin/argoexec" ]; then
    ARGOEXEC_PATH="/usr/local/bin/argoexec"
elif [ -f "/usr/bin/argoexec" ]; then
    ARGOEXEC_PATH="/usr/bin/argoexec"
else
    echo "❌ Failure: argoexec binary not found in expected locations."
    exit 1
fi

echo "Found argoexec at $ARGOEXEC_PATH."
echo "Running basic test..."

# Run the argoexec --help command to verify functionality
"$ARGOEXEC_PATH" --help
```

## Build Command
```bash
docker build --no-cache  -t argo-test-image .
```
## Run command
```bash
docker run --rm  argo-test-image
```


## Output 
```bash
Found argoexec at /usr/bin/argoexec.
Running basic test...
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

Flags:
      --as string                      Username to impersonate for the operation
      --as-group stringArray           Group to impersonate for the operation, this flag can be repeated to specify multiple groups.
      --as-uid string                  UID to impersonate for the operation
      --certificate-authority string   Path to a cert file for the certificate authority
      --client-certificate string      Path to a client certificate file for TLS
      --client-key string              Path to a client key file for TLS
      --cluster string                 The name of the kubeconfig cluster to use
      --context string                 The name of the kubeconfig context to use
      --disable-compression            If true, opt-out of response compression for all requests to the server
      --gloglevel int                  Set the glog logging level
  -h, --help                           help for argoexec
      --insecure-skip-tls-verify       If true, the server's certificate will not be checked for validity. This will make your HTTPS connections insecure
      --kubeconfig string              Path to a kube config. Only required if out-of-cluster
      --log-format string              The formatter to use for logs. One of: text|json (default "text")
      --loglevel string                Set the logging level. One of: debug|info|warn|error (default "info")
  -n, --namespace string               If present, the namespace scope for this CLI request
      --password string                Password for basic authentication to the API server
      --proxy-url string               If provided, this URL will be used to connect via proxy
      --request-timeout string         The length of time to wait before giving up on a single server request. Non-zero values should contain a corresponding time unit (e.g. 1s, 2m, 3h). A value of zero means don't timeout requests. (default "0")
      --server string                  The address and port of the Kubernetes API server
      --tls-server-name string         If provided, this name will be used to validate server certificate. If this is not provided, hostname used to contact the server is used.
      --token string                   Bearer token for authentication to the API server
      --user string                    The name of the kubeconfig user to use
      --username string                Username for basic authentication to the API server

Use "argoexec [command] --help" for more information about a command.
```

## Use Docker-compose 
```bash
docker-compose down --remove-orphans
```
```bash
docker-compose up --build
```

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [Argo Workflows Official Documentation](https://argoproj.github.io/argo-workflows/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).