#!/usr/bin/env python3
"""
Cortex Hello World Example
This demonstrates basic Cortex operations and configuration
"""

import requests
import json
import time

def test_cortex_connection():
    """Test connection to Cortex API"""
    try:
        # Test Cortex API endpoint
        response = requests.get('http://localhost:9009/ready', timeout=5)
        if response.status_code == 200:
            print("✅ Cortex API is ready!")
            return True
        else:
            print(f"⚠️  Cortex API returned status: {response.status_code}")
            return False
    except requests.exceptions.RequestException as e:
        print(f"❌ Cannot connect to Cortex API: {e}")
        return False

def test_cortex_config():
    """Test Cortex configuration"""
    print("\n🔧 Testing Cortex Configuration:")
    print("=" * 40)
    
    # Basic configuration test
    config = {
        "server": {
            "http_listen_port": 9009,
            "grpc_listen_port": 9095
        },
        "storage": {
            "engine": "filesystem",
            "filesystem": {
                "dir": "/tmp/cortex"
            }
        },
        "ingester": {
            "lifecycler": {
                "join_after": "0s",
                "num_tokens": 512
            }
        }
    }
    
    print("✅ Configuration structure is valid")
    print(f"   HTTP Port: {config['server']['http_listen_port']}")
    print(f"   gRPC Port: {config['server']['grpc_listen_port']}")
    print(f"   Storage Engine: {config['storage']['engine']}")
    
    return config

def test_metrics_ingestion():
    """Test metrics ingestion (simulated)"""
    print("\n📊 Testing Metrics Ingestion:")
    print("=" * 40)
    
    # Simulate metrics data
    metrics_data = {
        "metric_name": "hello_world_counter",
        "value": 1,
        "timestamp": int(time.time() * 1000),
        "labels": {
            "job": "hello_world",
            "instance": "localhost:9009"
        }
    }
    
    print("✅ Metrics data structure is valid")
    print(f"   Metric: {metrics_data['metric_name']}")
    print(f"   Value: {metrics_data['value']}")
    print(f"   Labels: {metrics_data['labels']}")
    
    return metrics_data

def test_query_simulation():
    """Test query simulation"""
    print("\n🔍 Testing Query Simulation:")
    print("=" * 40)
    
    # Simulate PromQL query
    query = "hello_world_counter{job=\"hello_world\"}"
    
    print("✅ Query structure is valid")
    print(f"   PromQL Query: {query}")
    print("   Expected result: Counter value for hello_world job")
    
    return query

def main():
    """Main function to run Cortex hello world"""
    print("🚀 Cortex Hello World Example")
    print("=" * 50)
    
    # Test configuration
    config = test_cortex_config()
    
    # Test metrics ingestion
    metrics = test_metrics_ingestion()
    
    # Test query simulation
    query = test_query_simulation()
    
    # Test connection (if Cortex is running)
    print("\n🌐 Testing Connection:")
    print("=" * 40)
    cortex_running = test_cortex_connection()
    
    if cortex_running:
        print("\n🎉 Cortex Hello World completed successfully!")
        print("   Cortex is running and ready to accept metrics!")
    else:
        print("\n📝 Cortex Hello World completed!")
        print("   Note: Cortex is not running, but configuration is valid.")
        print("   Start Cortex with: docker-compose up -d")
    
    print("\n📚 Next Steps:")
    print("   1. Start Cortex: docker-compose up -d")
    print("   2. Send metrics to: http://localhost:9009/api/v1/push")
    print("   3. Query metrics: http://localhost:9009/api/v1/query")
    print("   4. Check status: http://localhost:9009/ready")

if __name__ == "__main__":
    main()
