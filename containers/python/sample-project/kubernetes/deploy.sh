#!/bin/bash

# Flask App Kubernetes Deployment Script
# This script deploys the Flask User Management App to Kubernetes

set -e

echo "🚀 Deploying Flask User Management App to Kubernetes..."

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl is not installed or not in PATH"
    exit 1
fi

# Check if we can connect to Kubernetes cluster
if ! kubectl cluster-info &> /dev/null; then
    echo "❌ Cannot connect to Kubernetes cluster"
    exit 1
fi

echo "✅ Kubernetes cluster connection verified"

# Apply the main deployment file (includes namespace, deployment, and service)
echo "🚀 Deploying application..."
kubectl apply -f k8s-deployment.yaml

echo "⏳ Waiting for deployment to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/flask-user-app -n flask-app

echo "🔍 Checking deployment status..."
kubectl get pods -n flask-app
kubectl get services -n flask-app

echo "✅ Deployment completed successfully!"
echo ""
echo "📋 To access the application:"
echo "   kubectl port-forward -n flask-app service/flask-app-service 8080:80"
echo "   Then open http://localhost:8080 in your browser"
echo ""
echo "📊 To check logs:"
echo "   kubectl logs -n flask-app deployment/flask-user-app"
echo ""
echo "🔧 To scale the application:"
echo "   kubectl scale -n flask-app deployment/flask-user-app --replicas=3"
echo ""
echo "🧹 To clean up:"
echo "   kubectl delete namespace flask-app"
