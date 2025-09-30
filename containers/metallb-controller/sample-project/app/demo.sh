#!/bin/sh
echo "=== MetalLB Demo Container ==="
echo "Version: 0.15.2"
echo ""
echo "👉 What is MetalLB?"
echo "MetalLB is a load-balancer implementation for bare-metal Kubernetes clusters."
echo "It allows services of type LoadBalancer to work in environments without"
echo "native cloud provider integrations (like AWS ELB or GCP LB)."
echo ""
echo "👉 Use Case:"
echo "- Provides external IPs to services in on-prem or bare-metal Kubernetes clusters."
echo "- Works by announcing IPs using protocols like ARP, NDP, or BGP."
echo "- Useful when running Kubernetes in private datacenters or labs."
echo ""

while true; do
  echo "$(date) - Demo Alive"
  sleep 5
done

