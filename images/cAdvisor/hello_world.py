#!/usr/bin/env python3
"""
cAdvisor Hello World - Container Monitoring Demo

This script demonstrates basic container monitoring concepts
that cAdvisor helps visualize and track.
"""

import time
import psutil
import os
import json
from datetime import datetime

def get_system_info():
    """Get basic system information"""
    return {
        "timestamp": datetime.now().isoformat(),
        "hostname": os.uname().nodename,
        "cpu_count": psutil.cpu_count(),
        "memory_total": psutil.virtual_memory().total,
        "disk_usage": psutil.disk_usage('/').percent
    }

def get_container_info():
    """Simulate container information gathering"""
    return {
        "container_id": os.environ.get('HOSTNAME', 'unknown'),
        "cpu_usage": psutil.cpu_percent(interval=1),
        "memory_usage": psutil.virtual_memory().percent,
        "disk_io": psutil.disk_io_counters()._asdict() if psutil.disk_io_counters() else {},
        "network_io": psutil.net_io_counters()._asdict() if psutil.net_io_counters() else {}
    }

def main():
    print("🚀 cAdvisor Hello World - Container Monitoring Demo")
    print("=" * 60)
    
    print("\n📊 System Information:")
    system_info = get_system_info()
    print(f"  • Timestamp: {system_info['timestamp']}")
    print(f"  • Hostname: {system_info['hostname']}")
    print(f"  • CPU Cores: {system_info['cpu_count']}")
    print(f"  • Total Memory: {system_info['memory_total'] / (1024**3):.2f} GB")
    print(f"  • Disk Usage: {system_info['disk_usage']:.1f}%")
    
    print("\n🐳 Container Information:")
    container_info = get_container_info()
    print(f"  • Container ID: {container_info['container_id']}")
    print(f"  • CPU Usage: {container_info['cpu_usage']:.1f}%")
    print(f"  • Memory Usage: {container_info['memory_usage']:.1f}%")
    
    if container_info['disk_io']:
        print(f"  • Disk I/O - Read: {container_info['disk_io']['read_bytes'] / (1024**2):.2f} MB")
        print(f"  • Disk I/O - Write: {container_info['disk_io']['write_bytes'] / (1024**2):.2f} MB")
    
    if container_info['network_io']:
        print(f"  • Network I/O - Bytes Sent: {container_info['network_io']['bytes_sent'] / (1024**2):.2f} MB")
        print(f"  • Network I/O - Bytes Recv: {container_info['network_io']['bytes_recv'] / (1024**2):.2f} MB")
    
    print("\n📈 What cAdvisor Monitors:")
    print("  • CPU usage and limits")
    print("  • Memory usage and limits")
    print("  • Network statistics")
    print("  • Disk I/O metrics")
    print("  • Container lifecycle events")
    print("  • Resource utilization trends")
    
    print("\n🔗 cAdvisor Web UI:")
    print("  • Access at: http://localhost:8080")
    print("  • Real-time container metrics")
    print("  • Historical performance data")
    print("  • Resource usage graphs")
    
    print("\n🎯 Key Features:")
    print("  • Container-level monitoring")
    print("  • Resource usage tracking")
    print("  • Performance analytics")
    print("  • Web-based dashboard")
    print("  • REST API for metrics")
    
    print("\n💡 Use Cases:")
    print("  • Container performance monitoring")
    print("  • Resource optimization")
    print("  • Capacity planning")
    print("  • Troubleshooting")
    print("  • Cost optimization")
    
    print("\n" + "=" * 60)
    print("🎉 cAdvisor is ready to monitor your containers!")
    print("Run: docker run -d -p 8080:8080 --name cadvisor cleanstart/cadvisor:latest")
    print("Then visit: http://localhost:8080")

if __name__ == "__main__":
    main()
