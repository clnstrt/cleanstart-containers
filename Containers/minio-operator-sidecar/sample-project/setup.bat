@echo off
REM MinIO Operator Sidecar Sample Project Setup Script for Windows
REM This script sets up the MinIO Operator Sidecar sample project environment

echo 🚀 Setting up MinIO Operator Sidecar Sample Project
echo ==================================================

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not installed. Please install Docker first.
    exit /b 1
)
echo ✅ Docker is installed

REM Check if kubectl is installed
kubectl version --client >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ kubectl is not installed. Please install kubectl first.
    exit /b 1
)
echo ✅ kubectl is installed

REM Check if we can connect to cluster
kubectl cluster-info >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Cannot connect to Kubernetes cluster
    echo Please ensure your cluster is running and kubectl is configured
    exit /b 1
)
echo ✅ Connected to Kubernetes cluster

REM Check if MinIO operator image is available
echo Checking MinIO operator image availability...
docker pull minio/operator:latest >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ MinIO operator image is available
) else (
    echo ⚠️  Failed to pull MinIO operator image
)

REM Create necessary directories
echo Creating directories...
if not exist "basic-tenant" mkdir basic-tenant
if not exist "multi-tenant" mkdir multi-tenant
if not exist "production-setup" mkdir production-setup
if not exist "monitoring" mkdir monitoring
if not exist "config" mkdir config
if not exist "manifests" mkdir manifests
if not exist "scripts" mkdir scripts

echo ✅ Directories created

REM Create basic configuration files
echo Creating configuration files...

REM Create basic tenant operator configuration
(
echo apiVersion: v1
echo kind: Namespace
echo metadata:
echo   name: minio-operator
echo   labels:
echo     name: minio-operator
echo ---
echo apiVersion: v1
echo kind: ServiceAccount
echo metadata:
echo   name: minio-operator
echo   namespace: minio-operator
echo ---
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: ClusterRole
echo metadata:
echo   name: minio-operator
echo rules:
echo - apiGroups: [""]
echo   resources: ["pods", "services", "endpoints", "persistentvolumeclaims", "events", "configmaps", "secrets"]
echo   verbs: ["*"]
echo - apiGroups: [""]
echo   resources: ["nodes"]
echo   verbs: ["list", "get", "watch"]
echo - apiGroups: ["apps"]
echo   resources: ["deployments", "daemonsets", "replicasets", "statefulsets"]
echo   verbs: ["*"]
echo - apiGroups: ["minio.min.io"]
echo   resources: ["*"]
echo   verbs: ["*"]
echo ---
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: ClusterRoleBinding
echo metadata:
echo   name: minio-operator
echo roleRef:
echo   apiGroup: rbac.authorization.k8s.io
echo   kind: ClusterRole
echo   name: minio-operator
echo subjects:
echo - kind: ServiceAccount
echo   name: minio-operator
echo   namespace: minio-operator
echo ---
echo apiVersion: apps/v1
echo kind: Deployment
echo metadata:
echo   name: minio-operator
echo   namespace: minio-operator
echo   labels:
echo     app: minio-operator
echo spec:
echo   replicas: 1
echo   selector:
echo     matchLabels:
echo       app: minio-operator
echo   template:
echo     metadata:
echo       labels:
echo         app: minio-operator
echo     spec:
echo       serviceAccountName: minio-operator
echo       containers:
echo       - name: minio-operator
echo         image: minio/operator:latest
echo         command:
echo         - operator
echo         - --watch-namespace=""
echo         - --log-level=info
echo         ports:
echo         - containerPort: 4222
echo           name: http
echo         resources:
echo           requests:
echo             cpu: 100m
echo             memory: 128Mi
echo           limits:
echo             cpu: 500m
echo             memory: 512Mi
echo         env:
echo         - name: WATCH_NAMESPACE
echo           value: ""
echo         - name: POD_NAME
echo           valueFrom:
echo             fieldRef:
echo               fieldPath: metadata.name
echo         - name: OPERATOR_NAME
echo           value: "minio-operator"
echo         livenessProbe:
echo           httpGet:
echo             path: /healthz
echo             port: 4222
echo           initialDelaySeconds: 30
echo           periodSeconds: 10
echo         readinessProbe:
echo           httpGet:
echo             path: /readyz
echo             port: 4222
echo           initialDelaySeconds: 5
echo           periodSeconds: 5
) > basic-tenant\minio-operator.yaml

REM Create basic tenant configuration
(
echo apiVersion: v1
echo kind: Namespace
echo metadata:
echo   name: minio-tenant
echo   labels:
echo     name: minio-tenant
echo ---
echo apiVersion: v1
echo kind: Secret
echo metadata:
echo   name: minio-tenant-secret
echo   namespace: minio-tenant
echo type: Opaque
echo data:
echo   # minioadmin / minioadmin123
echo   accesskey: bWluaW9hZG1pbg==
echo   secretkey: bWluaW9hZG1pbg==
echo ---
echo apiVersion: minio.min.io/v2
echo kind: Tenant
echo metadata:
echo   name: minio-tenant
echo   namespace: minio-tenant
echo   labels:
echo     app: minio
echo spec:
echo   image: minio/minio:latest
echo   imagePullPolicy: IfNotPresent
echo   podTemplate:
echo     metadata: {}
echo     spec:
echo       containers:
echo       - name: minio
echo         image: minio/minio:latest
echo         command:
echo         - /bin/bash
echo         - -c
echo         - minio server --console-address ":9001" http://minio-{0...3}.minio-tenant-hl.minio-tenant.svc.cluster.local/data
echo         env:
echo         - name: MINIO_ROOT_USER
echo           valueFrom:
echo             secretKeyRef:
echo               name: minio-tenant-secret
echo               key: accesskey
echo         - name: MINIO_ROOT_PASSWORD
echo           valueFrom:
echo             secretKeyRef:
echo               name: minio-tenant-secret
echo               key: secretkey
echo         ports:
echo         - containerPort: 9000
echo           name: api
echo         - containerPort: 9001
echo           name: console
echo         livenessProbe:
echo           httpGet:
echo             path: /minio/health/live
echo             port: 9000
echo           initialDelaySeconds: 30
echo           periodSeconds: 10
echo         readinessProbe:
echo           httpGet:
echo             path: /minio/health/ready
echo             port: 9000
echo           initialDelaySeconds: 5
echo           periodSeconds: 5
echo         resources:
echo           requests:
echo             cpu: 100m
echo             memory: 256Mi
echo           limits:
echo             cpu: 500m
echo             memory: 1Gi
echo         volumeMounts:
echo         - name: data
echo           mountPath: /data
echo   pools:
echo   - servers: 4
echo     volumesPerServer: 1
echo     volumeClaimTemplate:
echo       metadata:
echo         name: data
echo       spec:
echo         accessModes:
echo         - ReadWriteOnce
echo         resources:
echo           requests:
echo             storage: 10Gi
echo         storageClassName: standard
echo   credentials:
echo     secret:
echo       name: minio-tenant-secret
echo   requestAutoCert: false
echo   s3:
echo     bucketDNS: false
echo   console:
echo     image: minio/console:latest
echo     imagePullPolicy: IfNotPresent
echo     replicas: 1
echo     resources:
echo       requests:
echo         cpu: 100m
echo         memory: 128Mi
echo       limits:
echo         cpu: 200m
echo         memory: 256Mi
echo   serviceMetadata:
echo     minioService:
echo       type: LoadBalancer
echo       ports:
echo         api: 9000
echo         console: 9001
echo     consoleService:
echo       type: LoadBalancer
echo       ports:
echo         console: 9001
echo   securityContext:
echo     runAsNonRoot: true
echo     runAsUser: 1000
echo     runAsGroup: 1000
echo     fsGroup: 1000
) > basic-tenant\minio-tenant.yaml

echo ✅ Configuration files created

REM Create a simple test script
(
echo @echo off
echo echo 🧪 Testing MinIO Operator Sidecar Sample Project Setup
echo echo =====================================================
echo.
echo REM Test Kubernetes connectivity
echo echo Testing Kubernetes connectivity...
echo kubectl cluster-info ^>nul 2^>^&1
echo if %%errorlevel%% neq 0 ^(
echo     echo ❌ Kubernetes cluster is not accessible
echo     exit /b 1
echo ^)
echo echo ✅ Kubernetes cluster is accessible
echo.
echo REM Test MinIO operator deployment
echo echo Testing MinIO operator deployment...
echo kubectl get pods -n minio-operator ^| findstr "Running" ^>nul 2^>^&1
echo if %%errorlevel%% equ 0 ^(
echo     echo ✅ MinIO operator is running
echo ^) else ^(
echo     echo ❌ MinIO operator is not running
echo     echo Run: kubectl apply -f basic-tenant\minio-operator.yaml
echo ^)
echo.
echo REM Test MinIO tenant deployment
echo echo Testing MinIO tenant deployment...
echo kubectl get tenant minio-tenant -n minio-tenant ^>nul 2^>^&1
echo if %%errorlevel%% equ 0 ^(
echo     echo ✅ MinIO tenant exists
echo ^) else ^(
echo     echo ❌ MinIO tenant does not exist
echo     echo Run: kubectl apply -f basic-tenant\minio-tenant.yaml
echo ^)
echo.
echo echo.
echo echo 🎯 Access URLs:
echo echo   MinIO API: http://localhost:9000 ^(after port-forward^)
echo echo   MinIO Console: http://localhost:9001 ^(after port-forward^)
echo echo   Default credentials: minioadmin / minioadmin123
echo echo.
echo echo 📚 Sample Projects:
echo echo   Basic Tenant: .\basic-tenant\
echo echo   Multi-Tenant: .\multi-tenant\
echo echo   Production Setup: .\production-setup\
echo echo   Monitoring: .\monitoring\
echo echo.
echo echo 🎉 Setup test completed!
) > test-setup.bat

echo ✅ Test script created

echo.
echo 🎉 Setup completed successfully!
echo.
echo 📋 Next Steps:
echo 1. Deploy MinIO operator: kubectl apply -f basic-tenant\minio-operator.yaml
echo 2. Deploy MinIO tenant: kubectl apply -f basic-tenant\minio-tenant.yaml
echo 3. Test the setup: .\test-setup.bat
echo 4. Explore the sample projects in the subdirectories
echo.
echo 🔗 Access URLs ^(after deployment^):
echo   MinIO API: http://localhost:9000 ^(after port-forward^)
echo   MinIO Console: http://localhost:9001 ^(after port-forward^)
echo   Default credentials: minioadmin / minioadmin123
echo.
echo 📚 Sample Projects:
echo   Basic Tenant: .\basic-tenant\
echo   Multi-Tenant: .\multi-tenant\
echo   Production Setup: .\production-setup\
echo   Monitoring: .\monitoring\
echo.
echo ✅ Happy MinIO Tenant Management! 🏢
