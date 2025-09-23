###  Quick Start

```bash
docker build -t metallb-controller-app .
```

```bash                                             
docker run --rm metallb-controller-app
```

###  Output
=== MetalLB Demo Container ===
Version: 0.15.2

👉 What is MetalLB?
MetalLB is a load-balancer implementation for bare-metal Kubernetes clusters.
It allows services of type LoadBalancer to work in environments without
native cloud provider integrations (like AWS ELB or GCP LB).

👉 Use Case:
- Provides external IPs to services in on-prem or bare-metal Kubernetes clusters.
- Works by announcing IPs using protocols like ARP, NDP, or BGP.
- Useful when running Kubernetes in private datacenters or labs.