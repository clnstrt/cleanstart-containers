# 🔗 Step CLI - Integration Examples

Advanced integration examples demonstrating how to connect Step CLI with various tools and platforms including Kubernetes, CI/CD pipelines, web servers, databases, and cloud platforms.

## 🎯 What This Example Demonstrates

- **Kubernetes Integration**: Certificate management in K8s environments
- **CI/CD Integration**: Automated certificate management in pipelines
- **Web Server Integration**: Nginx, Apache, and other web servers
- **Database Integration**: Certificate management for databases
- **Cloud Integration**: AWS, Azure, and GCP certificate management
- **Custom Integrations**: Building custom certificate workflows

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose installed
- Kubernetes cluster (for K8s examples)
- Basic understanding of integration concepts
- Ports 8080, 9090, 3000, 443 available

### 1. Choose Your Integration

```bash
# Navigate to the integration examples directory
cd images/step-cli/sample-project/integration-examples

# List available integrations
ls -la

# Choose an integration to explore
cd kubernetes-integration  # or ci-cd-integration, web-server-integration, etc.
```

## 📊 Available Integrations

### 1. Kubernetes Integration (`kubernetes-integration/`)

Complete Kubernetes certificate management with Step CLI integration.

**Components:**
- **Kubernetes Manifests**: Deployments, services, and configurations
- **Certificate Manager**: Automated certificate management in K8s
- **Ingress Controller**: TLS termination and certificate management
- **Service Mesh**: Istio integration with certificate management
- **Monitoring**: K8s-native monitoring and alerting

**Access Points:**
- Kubernetes Dashboard: `http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/`
- Certificate Manager: `http://localhost:8080`
- Ingress Controller: `http://localhost:80`
- Service Mesh: `http://localhost:15000`

### 2. CI/CD Integration (`ci-cd-integration/`)

Automated certificate management in CI/CD pipelines.

**Components:**
- **Jenkins**: Automated certificate deployment
- **GitHub Actions**: Certificate management workflows
- **GitLab CI**: Certificate automation pipelines
- **Azure DevOps**: Certificate management in Azure pipelines
- **Certificate Automation**: Automated certificate lifecycle management

**Access Points:**
- Jenkins: `http://localhost:8080`
- GitHub Actions: GitHub repository workflows
- GitLab CI: GitLab project pipelines
- Azure DevOps: Azure DevOps project pipelines

### 3. Web Server Integration (`web-server-integration/`)

Certificate management for web servers and load balancers.

**Components:**
- **Nginx**: TLS termination and certificate management
- **Apache**: SSL/TLS configuration and certificate management
- **HAProxy**: Load balancer with certificate management
- **Traefik**: Reverse proxy with automatic certificate management
- **Certificate Automation**: Automated certificate deployment

**Access Points:**
- Nginx: `http://localhost:80`
- Apache: `http://localhost:8080`
- HAProxy: `http://localhost:8081`
- Traefik: `http://localhost:8082`

### 4. Database Integration (`database-integration/`)

Certificate management for databases and data stores.

**Components:**
- **PostgreSQL**: SSL/TLS configuration and certificate management
- **MySQL**: SSL/TLS setup and certificate management
- **MongoDB**: TLS configuration and certificate management
- **Redis**: TLS setup and certificate management
- **Certificate Automation**: Automated database certificate management

**Access Points:**
- PostgreSQL: `localhost:5432`
- MySQL: `localhost:3306`
- MongoDB: `localhost:27017`
- Redis: `localhost:6379`

### 5. Cloud Integration (`cloud-integration/`)

Certificate management for cloud platforms and services.

**Components:**
- **AWS Integration**: ACM, IAM, and EC2 certificate management
- **Azure Integration**: Key Vault and App Service certificate management
- **GCP Integration**: Certificate Manager and Cloud KMS integration
- **Terraform**: Infrastructure as Code with certificate management
- **Cloud Automation**: Automated cloud certificate management

**Access Points:**
- AWS Console: AWS Management Console
- Azure Portal: Azure Management Portal
- GCP Console: Google Cloud Console
- Terraform: Local Terraform state

## 🔍 Integration Examples

### Kubernetes Integration

```bash
# Deploy to Kubernetes
cd kubernetes-integration

# Apply Kubernetes manifests
kubectl apply -f namespace.yaml
kubectl apply -f configmap.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f ingress.yaml

# Check deployment status
kubectl get pods -n step-cli-integration
kubectl get services -n step-cli-integration

# Check certificate status
kubectl get certificates -n step-cli-integration
```

### CI/CD Integration

```bash
# Set up Jenkins integration
cd ci-cd-integration

# Start Jenkins with Step CLI integration
docker compose up -d

# Configure certificate automation
curl -X POST http://localhost:8080/job/certificate-automation/build \
  -H "Content-Type: application/json" \
  -d '{"certificate": "example.com", "action": "renew"}'

# Check Jenkins logs
docker compose logs jenkins
```

### Web Server Integration

```bash
# Set up web server integration
cd web-server-integration

# Start web servers with certificate management
docker compose up -d

# Generate certificates for web servers
docker exec -it step-cli-integration step certificate create \
  --san nginx.example.com \
  "nginx.example.com" \
  /app/certs/nginx.crt \
  /app/certs/nginx.key

# Test web server certificates
curl -k https://localhost:80
```

### Database Integration

```bash
# Set up database integration
cd database-integration

# Start databases with TLS
docker compose up -d

# Generate database certificates
docker exec -it step-cli-integration step certificate create \
  --profile client \
  "postgres-client" \
  /app/certs/postgres-client.crt \
  /app/certs/postgres-client.key

# Test database TLS connection
docker exec -it postgres-integration psql -h localhost -U postgres -c "SELECT version();"
```

### Cloud Integration

```bash
# Set up cloud integration
cd cloud-integration

# Configure AWS integration
aws configure
terraform init
terraform plan
terraform apply

# Configure Azure integration
az login
az group create --name step-cli-rg --location eastus
az deployment group create --resource-group step-cli-rg --template-file azure-template.json

# Configure GCP integration
gcloud auth login
gcloud config set project your-project-id
gcloud deployment-manager deployments create step-cli-deployment --config gcp-config.yaml
```

## 📈 Understanding Integration Patterns

### Kubernetes Integration Architecture

```
Kubernetes Cluster
├── Namespace: step-cli-integration
├── Deployment: step-cli
├── Service: step-cli-service
├── ConfigMap: step-cli-config
├── Secret: step-cli-secrets
├── Ingress: step-cli-ingress
└── Certificate: step-cli-certificate
```

### CI/CD Integration Architecture

```
CI/CD Pipeline
├── Source Code Repository
├── Build Stage
│   ├── Certificate Generation
│   └── Certificate Validation
├── Test Stage
│   ├── Certificate Testing
│   └── Security Scanning
├── Deploy Stage
│   ├── Certificate Deployment
│   └── Certificate Verification
└── Monitor Stage
    ├── Certificate Monitoring
    └── Certificate Alerting
```

### Web Server Integration Architecture

```
Web Server Stack
├── Load Balancer (HAProxy/Traefik)
├── Web Servers (Nginx/Apache)
├── Certificate Management
│   ├── Certificate Generation
│   ├── Certificate Deployment
│   └── Certificate Renewal
└── Monitoring
    ├── Certificate Health
    └── Certificate Metrics
```

## 🔧 Configuration Details

### Kubernetes Configuration

**Deployment:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: step-cli
  namespace: step-cli-integration
spec:
  replicas: 2
  selector:
    matchLabels:
      app: step-cli
  template:
    metadata:
      labels:
        app: step-cli
    spec:
      containers:
      - name: step-cli
        image: cleanstart/step-cli:latest
        volumeMounts:
        - name: certs
          mountPath: /app/certs
        - name: secrets
          mountPath: /app/secrets
        env:
        - name: STEPPATH
          value: "/app/secrets"
        - name: STEP_CA_URL
          value: "https://step-ca:443"
      volumes:
      - name: certs
        persistentVolumeClaim:
          claimName: certs-pvc
      - name: secrets
        secret:
          secretName: step-secrets
```

### CI/CD Configuration

**Jenkins Pipeline:**
```groovy
pipeline {
    agent any
    stages {
        stage('Generate Certificate') {
            steps {
                sh 'step certificate create example.com example.crt example.key'
            }
        }
        stage('Validate Certificate') {
            steps {
                sh 'step certificate verify example.crt'
            }
        }
        stage('Deploy Certificate') {
            steps {
                sh 'kubectl apply -f certificate.yaml'
            }
        }
    }
}
```

### Web Server Configuration

**Nginx Configuration:**
```nginx
server {
    listen 443 ssl http2;
    server_name example.com;
    
    ssl_certificate /etc/nginx/ssl/example.crt;
    ssl_certificate_key /etc/nginx/ssl/example.key;
    
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256;
    
    location / {
        proxy_pass http://backend;
    }
}
```

## 🧪 Testing Scenarios

### 1. Kubernetes Integration Test

```bash
# Deploy certificate to Kubernetes
kubectl apply -f certificate.yaml

# Check certificate status
kubectl get certificates -n step-cli-integration

# Verify certificate in pod
kubectl exec -it step-cli-pod -n step-cli-integration -- step certificate inspect /app/certs/example.crt
```

### 2. CI/CD Integration Test

```bash
# Trigger certificate automation
curl -X POST http://localhost:8080/job/certificate-automation/build

# Check build status
curl http://localhost:8080/job/certificate-automation/lastBuild/api/json

# Verify certificate deployment
kubectl get certificates -n step-cli-integration
```

### 3. Web Server Integration Test

```bash
# Test web server certificates
curl -k https://localhost:80

# Check certificate details
openssl s_client -connect localhost:80 -servername example.com

# Verify certificate chain
curl -k https://localhost:80 | openssl x509 -text -noout
```

### 4. Database Integration Test

```bash
# Test database TLS connection
docker exec -it postgres-integration psql -h localhost -U postgres -c "SELECT version();"

# Check database certificate
docker exec -it postgres-integration openssl x509 -in /var/lib/postgresql/server.crt -text -noout

# Verify client certificate
docker exec -it postgres-integration openssl x509 -in /var/lib/postgresql/client.crt -text -noout
```

## 🔍 Troubleshooting

### Common Issues

**Kubernetes integration issues**
```bash
# Check pod status
kubectl get pods -n step-cli-integration

# Check pod logs
kubectl logs -n step-cli-integration -l app=step-cli

# Check certificate status
kubectl describe certificate -n step-cli-integration
```

**CI/CD integration issues**
```bash
# Check Jenkins logs
docker compose logs jenkins

# Check build status
curl http://localhost:8080/job/certificate-automation/lastBuild/consoleText

# Verify certificate generation
docker exec -it jenkins-integration ls -la /var/jenkins_home/certs/
```

**Web server integration issues**
```bash
# Check web server logs
docker compose logs nginx

# Verify certificate files
docker exec -it nginx-integration ls -la /etc/nginx/ssl/

# Test certificate validity
docker exec -it nginx-integration openssl x509 -in /etc/nginx/ssl/example.crt -text -noout
```

**Database integration issues**
```bash
# Check database logs
docker compose logs postgres

# Verify database certificate
docker exec -it postgres-integration cat /var/lib/postgresql/server.crt

# Test database connection
docker exec -it postgres-integration psql -h localhost -U postgres -c "SELECT 1;"
```

### Debug Commands

```bash
# Check all container statuses
docker compose ps

# View real-time logs
docker compose logs -f --tail=100

# Check network connectivity
docker exec -it step-cli-integration ping step-ca

# Verify volume mounts
docker exec -it step-cli-integration ls -la /app/certs/
```

## 📚 Next Steps

After mastering these integrations:

1. **Customize Integrations**: Modify configurations for your specific use case
2. **Add More Integrations**: Connect with additional tools and platforms
3. **Implement Automation**: Build custom automation workflows
4. **Scale to Production**: Implement in production environments

## 🧹 Cleanup

```bash
# Stop all services
docker compose down

# Remove containers and networks
docker compose down --remove-orphans

# Remove volumes (optional - will delete all certificates and data)
docker compose down -v

# Clean up images (optional)
docker compose down --rmi all
```

---

**Happy Integrating! 🔗**
