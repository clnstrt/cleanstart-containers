# Curl Container - Kubernetes Testing on GKE

Simple Kubernetes testing for the `cleanstart/curl` container in Google Kubernetes Engine (GKE).

## Prerequisites

- **kubectl** configured to connect to your GKE cluster
- **GKE cluster** running with appropriate permissions
- **Network access** from your GKE cluster to external endpoints

```bash
# Verify prerequisites
kubectl config current-context
kubectl cluster-info
```

## Deploy

```bash
# Create namespace
kubectl create namespace curl-testing

# Deploy the job
kubectl apply -f job.yaml

# Check job status
kubectl get jobs -n curl-testing
kubectl get pods -n curl-testing

# View results
kubectl logs job/curl-test-job -n curl-testing
```

**Expected Output:**
```
curl 7.68.0 (x86_64-pc-linux-gnu) libcurl/7.68.0 OpenSSL/1.1.1f zlib/1.2.11 brotli/1.0.7 libidn2/2.2.0 libpsl/0.21.0 (+libidn2/2.2.0) libssh/0.9.3/openssl/zlib nghttp2/1.40.0 librtmp/2.3
Release-Date: 2020-01-08
Protocols: dict file ftp ftps gopher http https imap imaps ldap ldaps pop3 pop3s rtmp rtsp scp sftp smb smbs smtp smtps telnet tftp
Features: AsynchDNS brotli GSS-API HTTP2 HTTPS-proxy IDN IPv6 Kerberos Largefile libz NTLM NTLM_WB PSL SPNEGO SSL TLS-SRP UnixSockets
```

## Test

### Basic Tests

```bash
# Test curl version
kubectl run curl-test --image=cleanstart/curl:latest --rm -it --restart=Never -n curl-testing -- curl --version

# Test HTTP GET request
kubectl run curl-test --image=cleanstart/curl:latest --rm -it --restart=Never -n curl-testing -- curl -s https://httpbin.org/get

# Test POST request with JSON
kubectl run curl-test --image=cleanstart/curl:latest --rm -it --restart=Never -n curl-testing -- curl -s -X POST https://httpbin.org/post \
  -H "Content-Type: application/json" \
  -d '{"test": "data from GKE"}'
```

## Troubleshooting

### Common Issues

**Pod stuck in Pending:**
```bash
kubectl describe pod <pod-name> -n curl-testing
kubectl top nodes
```

**Image pull errors:**
```bash
kubectl describe pod <pod-name> -n curl-testing
```

**Network connectivity issues:**
```bash
kubectl run nettest --image=cleanstart/curl:latest --rm -it --restart=Never -n curl-testing -- curl -v --connect-timeout 5 https://google.com
```

## Cleanup

```bash
# Delete job
kubectl delete -f job.yaml

# Delete namespace (removes all resources)
kubectl delete namespace curl-testing

# Verify cleanup
kubectl get all -n curl-testing 2>/dev/null || echo "Namespace curl-testing does not exist"
```
