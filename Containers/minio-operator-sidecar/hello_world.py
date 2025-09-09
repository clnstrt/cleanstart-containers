#!/usr/bin/env python3
"""
MinIO Operator Sidecar Hello World Script

This script demonstrates basic MinIO Operator Sidecar functionality
and provides a simple test to verify the container is working correctly.
"""

import os
import sys
import subprocess
import json
import time
import requests
from datetime import datetime

def print_banner():
    """Print the MinIO Operator Sidecar banner"""
    print("=" * 60)
    print("🏢 MinIO Operator Sidecar - Hello World")
    print("=" * 60)
    print(f"Timestamp: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"Python Version: {sys.version}")
    print(f"Working Directory: {os.getcwd()}")
    print("=" * 60)

def check_environment():
    """Check the environment and dependencies"""
    print("\n🔍 Checking Environment...")
    
    # Check if we're in a container
    if os.path.exists('/.dockerenv'):
        print("✅ Running in Docker container")
    else:
        print("⚠️  Not running in Docker container")
    
    # Check environment variables
    env_vars = [
        'MINIO_OPERATOR_NAMESPACE',
        'MINIO_OPERATOR_LOG_LEVEL',
        'MINIO_OPERATOR_WATCH_NAMESPACE'
    ]
    
    for var in env_vars:
        value = os.environ.get(var, 'Not set')
        print(f"   {var}: {value}")
    
    # Check if kubectl is available
    try:
        result = subprocess.run(['kubectl', 'version', '--client'], 
                              capture_output=True, text=True, timeout=10)
        if result.returncode == 0:
            print("✅ kubectl is available")
            print(f"   Version: {result.stdout.strip().split('\\n')[0]}")
        else:
            print("❌ kubectl is not working properly")
    except (subprocess.TimeoutExpired, FileNotFoundError):
        print("❌ kubectl is not available")
    
    # Check if we can access Kubernetes cluster
    try:
        result = subprocess.run(['kubectl', 'cluster-info'], 
                              capture_output=True, text=True, timeout=10)
        if result.returncode == 0:
            print("✅ Kubernetes cluster is accessible")
        else:
            print("❌ Cannot access Kubernetes cluster")
    except (subprocess.TimeoutExpired, FileNotFoundError):
        print("❌ Cannot access Kubernetes cluster")

def test_minio_operator():
    """Test MinIO Operator functionality"""
    print("\n🧪 Testing MinIO Operator...")
    
    # Check if MinIO operator is running
    try:
        result = subprocess.run(['kubectl', 'get', 'pods', '-n', 'minio-operator'], 
                              capture_output=True, text=True, timeout=10)
        if result.returncode == 0:
            print("✅ MinIO operator namespace exists")
            if 'minio-operator' in result.stdout:
                print("✅ MinIO operator pod found")
            else:
                print("⚠️  MinIO operator pod not found")
        else:
            print("❌ MinIO operator namespace not found")
    except (subprocess.TimeoutExpired, FileNotFoundError):
        print("❌ Cannot check MinIO operator status")
    
    # Check for MinIO tenants
    try:
        result = subprocess.run(['kubectl', 'get', 'tenants', '--all-namespaces'], 
                              capture_output=True, text=True, timeout=10)
        if result.returncode == 0:
            print("✅ Can access MinIO tenants")
            if result.stdout.strip():
                print("✅ Found MinIO tenants:")
                for line in result.stdout.strip().split('\\n')[1:]:
                    if line.strip():
                        print(f"   {line.strip()}")
            else:
                print("⚠️  No MinIO tenants found")
        else:
            print("❌ Cannot access MinIO tenants")
    except (subprocess.TimeoutExpired, FileNotFoundError):
        print("❌ Cannot check MinIO tenants")

def test_minio_connectivity():
    """Test MinIO server connectivity"""
    print("\n🌐 Testing MinIO Connectivity...")
    
    # Test MinIO API health
    minio_urls = [
        'http://localhost:9000',
        'http://minio:9000',
        'http://minio-test:9000'
    ]
    
    for url in minio_urls:
        try:
            response = requests.get(f'{url}/minio/health/live', timeout=5)
            if response.status_code == 200:
                print(f"✅ MinIO API is accessible at {url}")
                break
        except requests.exceptions.RequestException:
            continue
    else:
        print("❌ MinIO API is not accessible")
    
    # Test MinIO Console
    console_urls = [
        'http://localhost:9001',
        'http://minio-console:9001',
        'http://minio-console-test:9001'
    ]
    
    for url in console_urls:
        try:
            response = requests.get(url, timeout=5)
            if response.status_code == 200:
                print(f"✅ MinIO Console is accessible at {url}")
                break
        except requests.exceptions.RequestException:
            continue
    else:
        print("❌ MinIO Console is not accessible")

def show_sample_commands():
    """Show sample MinIO Operator commands"""
    print("\n📋 Sample MinIO Operator Commands:")
    print("-" * 40)
    
    commands = [
        ("Check operator status", "kubectl get pods -n minio-operator"),
        ("List all tenants", "kubectl get tenants --all-namespaces"),
        ("Create a tenant", "kubectl apply -f minio-tenant.yaml"),
        ("Check tenant status", "kubectl describe tenant <tenant-name>"),
        ("Access MinIO API", "kubectl port-forward svc/minio 9000:9000"),
        ("Access MinIO Console", "kubectl port-forward svc/minio-console 9001:9001"),
        ("Check operator logs", "kubectl logs -l app=minio-operator -n minio-operator"),
        ("Scale tenant", "kubectl scale tenant <tenant-name> --replicas=4")
    ]
    
    for description, command in commands:
        print(f"   {description}:")
        print(f"     {command}")
        print()

def show_next_steps():
    """Show next steps for users"""
    print("\n🚀 Next Steps:")
    print("-" * 20)
    print("1. Deploy MinIO operator:")
    print("   kubectl apply -f basic-tenant/minio-operator.yaml")
    print()
    print("2. Deploy a MinIO tenant:")
    print("   kubectl apply -f basic-tenant/minio-tenant.yaml")
    print()
    print("3. Access MinIO Console:")
    print("   kubectl port-forward svc/minio-console 9001:9001 -n minio-tenant")
    print("   Open http://localhost:9001")
    print()
    print("4. Explore sample projects:")
    print("   - Basic Tenant: ./basic-tenant/")
    print("   - Multi-Tenant: ./multi-tenant/")
    print("   - Production Setup: ./production-setup/")
    print("   - Monitoring: ./monitoring/")
    print()
    print("5. Run setup scripts:")
    print("   ./setup.sh        # Linux/macOS")
    print("   setup.bat         # Windows")

def main():
    """Main function"""
    print_banner()
    check_environment()
    test_minio_operator()
    test_minio_connectivity()
    show_sample_commands()
    show_next_steps()
    
    print("\n" + "=" * 60)
    print("🎉 MinIO Operator Sidecar Hello World completed!")
    print("=" * 60)

if __name__ == "__main__":
    main()
