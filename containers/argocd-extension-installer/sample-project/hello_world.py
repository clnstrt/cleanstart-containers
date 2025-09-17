#!/usr/bin/env python3
"""
ArgoCD Extension Installer - Hello World Demo
This script demonstrates the concepts and capabilities of ArgoCD extension management.
"""

import os
import sys
import json
import subprocess
import time
from datetime import datetime

def get_system_info():
    """Get basic system information"""
    return {
        'timestamp': datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
        'platform': sys.platform,
        'python_version': sys.version,
        'working_directory': os.getcwd(),
        'environment': dict(os.environ)
    }

def get_kubernetes_info():
    """Get Kubernetes cluster information"""
    try:
        # Check if kubectl is available
        result = subprocess.run(['kubectl', 'version', '--client'], 
                              capture_output=True, text=True, timeout=10)
        kubectl_available = result.returncode == 0
        
        # Check if we can connect to a cluster
        cluster_info = {}
        if kubectl_available:
            try:
                result = subprocess.run(['kubectl', 'cluster-info'], 
                                      capture_output=True, text=True, timeout=10)
                cluster_info['connected'] = result.returncode == 0
                if cluster_info['connected']:
                    cluster_info['info'] = result.stdout.strip()
            except:
                cluster_info['connected'] = False
        else:
            cluster_info['connected'] = False
            
        return {
            'kubectl_available': kubectl_available,
            'cluster_connected': cluster_info.get('connected', False),
            'cluster_info': cluster_info.get('info', 'Not available')
        }
    except Exception as e:
        return {
            'kubectl_available': False,
            'cluster_connected': False,
            'error': str(e)
        }

def get_helm_info():
    """Get Helm information"""
    try:
        result = subprocess.run(['helm', 'version'], 
                              capture_output=True, text=True, timeout=10)
        helm_available = result.returncode == 0
        return {
            'helm_available': helm_available,
            'version': result.stdout.strip() if helm_available else 'Not available'
        }
    except Exception as e:
        return {
            'helm_available': False,
            'error': str(e)
        }

def demonstrate_argocd_concepts():
    """Demonstrate ArgoCD extension installer concepts"""
    print("🚀 ArgoCD Extension Installer - Hello World Demo")
    print("=" * 70)
    
    # System Information
    print("\n📊 System Information:")
    system_info = get_system_info()
    print(f"  • Timestamp: {system_info['timestamp']}")
    print(f"  • Platform: {system_info['platform']}")
    print(f"  • Python Version: {system_info['python_version']}")
    print(f"  • Working Directory: {system_info['working_directory']}")
    
    # Kubernetes Information
    print("\n🐳 Kubernetes Information:")
    k8s_info = get_kubernetes_info()
    print(f"  • kubectl Available: {'✅ Yes' if k8s_info['kubectl_available'] else '❌ No'}")
    print(f"  • Cluster Connected: {'✅ Yes' if k8s_info['cluster_connected'] else '❌ No'}")
    if k8s_info['cluster_connected']:
        print(f"  • Cluster Info: {k8s_info['cluster_info']}")
    
    # Helm Information
    print("\n⚓ Helm Information:")
    helm_info = get_helm_info()
    print(f"  • Helm Available: {'✅ Yes' if helm_info['helm_available'] else '❌ No'}")
    if helm_info['helm_available']:
        print(f"  • Helm Version: {helm_info['version']}")
    
    print("\n📈 What ArgoCD Extension Installer Does:")
    print("  • Manages ArgoCD extensions and plugins")
    print("  • Installs and configures ArgoCD extensions")
    print("  • Manages extension dependencies")
    print("  • Provides extension lifecycle management")
    print("  • Supports custom extension development")
    
    print("\n🔧 Key Features:")
    print("  • Extension discovery and installation")
    print("  • Version management and updates")
    print("  • Dependency resolution")
    print("  • Configuration management")
    print("  • Health monitoring")
    print("  • Rollback capabilities")
    
    print("\n🎯 Common Extensions:")
    print("  • ArgoCD Notifications")
    print("  • ArgoCD Image Updater")
    print("  • ArgoCD ApplicationSet")
    print("  • ArgoCD Rollouts")
    print("  • Custom UI extensions")
    print("  • Custom plugins")
    
    print("\n🔗 ArgoCD Web Interface:")
    print("  • Access at: http://localhost:8080")
    print("  • Extension management dashboard")
    print("  • Extension configuration")
    print("  • Health and status monitoring")
    
    print("\n💡 Use Cases:")
    print("  • CI/CD pipeline automation")
    print("  • GitOps workflow management")
    print("  • Application deployment automation")
    print("  • Multi-cluster management")
    print("  • Infrastructure as Code")
    
    print("\n🚀 Getting Started:")
    print("  • Install ArgoCD in your cluster")
    print("  • Configure extension repositories")
    print("  • Install required extensions")
    print("  • Configure extension settings")
    print("  • Monitor extension health")
    
    print("\n" + "=" * 70)
    print("🎉 ArgoCD Extension Installer is ready to manage your extensions!")
    print("Run: docker run -d -p 8080:8080 --name argocd-extensions cleanstart/argocd-extension-installer:latest")
    print("Then visit: http://localhost:8080")
    print("=" * 70)

def main():
    """Main function"""
    try:
        demonstrate_argocd_concepts()
    except KeyboardInterrupt:
        print("\n\n👋 Demo interrupted by user. Goodbye!")
        sys.exit(0)
    except Exception as e:
        print(f"\n❌ Error during demo: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
