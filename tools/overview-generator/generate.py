#!/usr/bin/env python3
"""
Dynamic Security Container Documentation Generator
A Python script to generate enhanced container documentation using Anthropic's Claude API.
Works dynamically for any container image with fully dynamic registry/path/site support.
Now creates JSON first, then generates MD from JSON.
Enhanced with content_blocks for all commands and Hello World examples.
Completely dynamic - no hardcoded registry or site names.
"""

import os
import sys
import argparse
import requests
import json
from datetime import datetime
from pathlib import Path
from typing import List, Dict, Optional, Any
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

class ContainerDocsGenerator:
    """Generate dynamic container documentation using Claude API."""
    
    def __init__(self, default_registry="{registry.example.com}", site_name="Container Registry"):
        self.default_registry = default_registry
        self.site_name = site_name
        self.api_key = os.getenv('GROK_API_KEY')
        self.api_url = 'https://api.anthropic.com/v1/messages'
        self.model = 'claude-3-5-sonnet-20241022'
        self.output_dir = Path('responses')
        self.json_dir = Path('responses/json')
        self.md_dir = Path('responses/markdown')
        
        # Create directories
        self.output_dir.mkdir(exist_ok=True)
        self.json_dir.mkdir(exist_ok=True)
        self.md_dir.mkdir(exist_ok=True)
        
        self.custom_descriptions = {}
        self.dynamic_foundation_text = f"Security-hardened, minimal base OS designed for enterprise containerized environments from {self.site_name}."
        
        if not self.api_key:
            raise ValueError("GROK_API_KEY environment variable is required")
    
    def parse_image_path(self, image_input: str) -> tuple[str, str, str]:
        """
        Parse image input to extract registry/path, image name, and site name.
        
        Examples:
        - 'nginx' -> ('{registry.example.com}', 'nginx', 'Registry Example')
        - 'myregistry/nginx' -> ('myregistry', 'nginx', 'Myregistry')
        - 'docker.io/library/nginx' -> ('docker.io/library', 'nginx', 'Docker Hub')
        - 'gcr.io/project/my-app' -> ('gcr.io/project', 'my-app', 'Google Container Registry')
        - 'ghcr.io/owner/repo' -> ('ghcr.io/owner', 'repo', 'GitHub Container Registry')
        """
        if '/' in image_input:
            # Split on last '/' to get registry/path and image name
            parts = image_input.rsplit('/', 1)
            registry_path = parts[0]
            image_name = parts[1]
        else:
            # Use default registry if no path specified
            registry_path = self.default_registry
            image_name = image_input
        
        # Generate site name from registry
        site_name = self.get_site_name_from_registry(registry_path)
        
        return registry_path, image_name, site_name
    
    def get_site_name_from_registry(self, registry_path: str) -> str:
        """Generate a human-readable site name from registry path."""
        # Handle common registries with known names
        registry_names = {
            'docker.io': 'Docker Hub',
            'docker.io/library': 'Docker Hub',
            'gcr.io': 'Google Container Registry',
            'ghcr.io': 'GitHub Container Registry',
            'quay.io': 'Quay Container Registry',
            'registry.redhat.io': 'Red Hat Container Registry',
            'mcr.microsoft.com': 'Microsoft Container Registry',
            'public.ecr.aws': 'Amazon ECR Public',
            'k8s.gcr.io': 'Kubernetes Container Registry',
            'registry.k8s.io': 'Kubernetes Container Registry',
            'nvcr.io': 'NVIDIA NGC Registry',
        }
        
        # Check for exact matches first
        if registry_path in registry_names:
            return registry_names[registry_path]
        
        # Check for partial matches
        for registry, name in registry_names.items():
            if registry_path.startswith(registry):
                return name
        
        # Generate a name from the registry path
        # Remove common TLD and convert to title case
        base_name = registry_path.split('/')[0]  # Get the base domain
        base_name = base_name.replace('.io', '').replace('.com', '').replace('.org', '').replace('.net', '')
        
        # Handle special cases
        if 'gcr' in base_name:
            return 'Google Container Registry'
        elif 'ghcr' in base_name:
            return 'GitHub Container Registry'
        elif 'ecr' in base_name:
            return 'Amazon ECR'
        elif 'azurecr' in base_name:
            return 'Azure Container Registry'
        
        # Default: convert to title case and add "Registry"
        return f"{base_name.title()} Registry"
    
    def get_full_image_path(self, image_input: str, tag: str = "latest") -> str:
        """Get the full image path with tag."""
        registry_path, image_name, _ = self.parse_image_path(image_input)
        return f"{registry_path}/{image_name}:{tag}"
    
    def add_custom_description(self, image: str, description: str):
        """Add custom description for a specific image."""
        self.custom_descriptions[image.lower()] = description
    
    def set_foundation_text(self, text: str):
        """Set custom foundation text."""
        self.dynamic_foundation_text = text
    
    def get_image_description(self, image: str) -> str:
        """Get custom description for specific images."""
        return self.custom_descriptions.get(image.lower(), "")
    
    def get_container_specific_commands(self, image_input: str) -> str:
        """Generate container-specific command blocks based on image type."""
        registry_path, image_name, _ = self.parse_image_path(image_input)
        image_lower = image_name.lower()
        
        # Define common patterns for different container types
        if any(db in image_lower for db in ['postgres', 'mysql', 'mongodb', 'redis', 'elasticsearch']):
            return self._get_database_commands(registry_path, image_name)
        elif any(web in image_lower for web in ['nginx', 'apache', 'httpd']):
            return self._get_webserver_commands(registry_path, image_name)
        elif any(lang in image_lower for lang in ['python', 'node', 'go', 'java', 'php']):
            return self._get_runtime_commands(registry_path, image_name)
        elif 'busybox' in image_lower:
            return self._get_busybox_commands(registry_path, image_name)
        else:
            return self._get_generic_commands(registry_path, image_name)
    
    def _get_busybox_commands(self, registry_path: str, image_name: str) -> str:
        """Get BusyBox-specific commands following the documentation structure."""
        full_image = f"{registry_path}/{image_name}"
        return f'''[
    {{
      "id": "key-features",
      "title": "Key Features",
      "description": "Core capabilities and strengths of this BusyBox container",
      "content": [
        {{
          "text": "Over 300 common UNIX utilities in a single executable"
        }},
        {{
          "text": "Minimal footprint ideal for embedded systems"
        }},
        {{
          "text": "Complete shell environment with scripting support"
        }},
        {{
          "text": "Enterprise-grade security hardening and optimization"
        }}
      ],
      "type": "TEXT"
    }},
    {{
      "id": "common-use-cases",
      "title": "Common Use Cases",
      "description": "Typical scenarios where this BusyBox container excels",
      "content": [
        {{
          "text": "Minimal base image for multi-stage Docker builds"
        }},
        {{
          "text": "Debugging and troubleshooting containerized environments"
        }},
        {{
          "text": "Lightweight init systems and process supervision"
        }},
        {{
          "text": "Shell scripting and automation in constrained environments"
        }}
      ],
      "type": "TEXT"
    }},
    {{
      "id": "pull-commands",
      "title": "Pull Commands",
      "description": "Download the BusyBox container images from the registry",
      "content": [
        {{
          "text": "docker pull {registry_path}/{image_name}:latest"
        }},
        {{
          "text": "docker pull {registry_path}/{image_name}:latest-dev"
        }}
      ],
      "type": "CODE",
      "code_language": "bash"
    }},
    {{
      "id": "basic-production-deployment",
      "title": "Basic Production Deployment",
      "description": "Standard production deployment with recommended security settings",
      "content": [
        {{
          "text": "docker run -d --name {image_name}-test \\\\\\n  --read-only \\\\\\n  --security-opt=no-new-privileges \\\\\\n  --user 1000:1000 \\\\\\n  {registry_path}/{image_name}:latest sleep infinity"
        }}
      ],
      "type": "CODE",
      "code_language": "bash"
    }},
    {{
      "id": "development-testing",
      "title": "Development/Testing",
      "description": "Development setup with debugging capabilities",
      "content": [
        {{
          "text": "docker run -it --privileged {registry_path}/{image_name}:latest-dev /bin/sh"
        }}
      ],
      "type": "CODE",
      "code_language": "bash"
    }},
    {{
      "id": "docker-compose",
      "title": "Docker Compose",
      "description": "Production-ready Docker Compose configuration",
      "content": [
        {{
          "text": "version: '3.8'\\nservices:\\n  {image_name}:\\n    image: {registry_path}/{image_name}:latest\\n    container_name: {image_name}\\n    restart: unless-stopped\\n    volumes:\\n      - /tmp:/tmp\\n    security_opt:\\n      - no-new-privileges:true\\n    read_only: true\\n    tmpfs:\\n      - /tmp"
        }}
      ],
      "type": "CODE",
      "code_language": "yaml"
    }},
    {{
      "id": "environment-variables",
      "title": "Environment Variables",
      "description": "Configuration options available through environment variables",
      "content": [
        {{
          "text": "| Variable | Default | Description |\\n|----------|---------|-------------|\\n| PATH | /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin | System PATH configuration |\\n| BUSYBOX_VERSION | latest | Installed BusyBox version |\\n| HOME | /home/busybox | User home directory |"
        }}
      ],
      "type": "TABLE"
    }},
    {{
      "id": "security-best-practices",
      "title": "Security Best Practices",
      "description": "Recommended security configurations and practices",
      "content": [
        {{
          "text": "Use specific image tags for production (avoid latest)"
        }},
        {{
          "text": "Configure resource limits: memory and CPU constraints"
        }},
        {{
          "text": "Enable read-only root filesystem when possible"
        }},
        {{
          "text": "Run containers with non-root user (--user 1000:1000)"
        }},
        {{
          "text": "Use --security-opt=no-new-privileges flag"
        }},
        {{
          "text": "Regularly update container images for security patches"
        }},
        {{
          "text": "Implement proper network segmentation"
        }},
        {{
          "text": "Monitor container metrics for anomalies"
        }}
      ],
      "type": "TEXT"
    }},
    {{
      "id": "kubernetes-security-context",
      "title": "Kubernetes Security Context",
      "description": "Recommended security context for Kubernetes deployments",
      "content": [
        {{
          "text": "securityContext:\\n  runAsNonRoot: true\\n  runAsUser: 1000\\n  runAsGroup: 1000\\n  readOnlyRootFilesystem: true\\n  allowPrivilegeEscalation: false\\n  capabilities:\\n    drop: [\\\"ALL\\\"]"
        }}
      ],
      "type": "CODE",
      "code_language": "yaml"
    }},
    {{
      "id": "multi-platform-images",
      "title": "Multi-Platform Images",
      "description": "Pull images for specific architectures",
      "content": [
        {{
          "text": "docker pull --platform linux/amd64 {registry_path}/{image_name}:latest"
        }},
        {{
          "text": "docker pull --platform linux/arm64 {registry_path}/{image_name}:latest"
        }}
      ],
      "type": "CODE",
      "code_language": "bash"
    }},
    {{
      "id": "common-commands",
      "title": "Common Commands",
      "description": "Essential BusyBox utility commands",
      "content": [
        {{
          "text": "docker run {registry_path}/{image_name}:latest echo \\"Hello World\\""
        }},
        {{
          "text": "docker run {registry_path}/{image_name}:latest --help"
        }},
        {{
          "text": "docker run {registry_path}/{image_name}:latest --list"
        }}
      ],
      "type": "CODE",
      "code_language": "bash"
    }},
    {{
      "id": "documentation-resources",
      "title": "Documentation Resources",
      "description": "Essential links and resources for further information",
      "content": [
        {{
          "text": "**Container Registry**: https://{registry_path.replace('/', '.')}"
        }},
        {{
          "text": "**Go Official Documentation**: https://go.org/"
        }}
      ],
      "type": "TEXT"
    }},
    {{
      "id": "connect-to-running-container",
      "title": "Connect to Running Container",
      "description": "Access shell in running container for debugging",
      "content": [
        {{
          "text": "docker exec -it container-name sh"
        }}
      ],
      "type": "CODE",
      "code_language": "bash"
    }}
  ]'''
    
    def _get_database_commands(self, registry_path: str, image_name: str) -> str:
        """Get database-specific commands."""
        full_image = f"{registry_path}/{image_name}"
        return f'''[
    {{
      "id": "key-features",
      "title": "Key Features",
      "description": "Core capabilities and strengths of this database container",
      "content": [
        {{
          "text": "ACID compliant relational database system"
        }},
        {{
          "text": "Advanced SQL features and extensibility"
        }},
        {{
          "text": "Built-in replication and high availability"
        }},
        {{
          "text": "Enterprise-grade security and performance optimization"
        }}
      ],
      "type": "TEXT"
    }},
    {{
      "id": "common-use-cases",
      "title": "Common Use Cases",
      "description": "Typical scenarios where this database container excels",
      "content": [
        {{
          "text": "Web application backend database"
        }},
        {{
          "text": "Data analytics and reporting systems"
        }},
        {{
          "text": "Microservices persistent storage"
        }},
        {{
          "text": "Enterprise data warehousing solutions"
        }}
      ],
      "type": "TEXT"
    }},
    {{
      "id": "pull-latest-image",
      "title": "Pull Latest Image",
      "description": "Download the database container image from the registry",
      "content": [
        {{
          "text": "docker pull {registry_path}/{image_name}:latest"
        }},
        {{
          "text": "docker pull {registry_path}/{image_name}:latest-dev"
        }}
      ],
      "type": "CODE",
      "code_language": "bash"
    }},
    {{
      "id": "production-deployment",
      "title": "Production Deployment",
      "description": "Deploy database with persistent storage and security settings",
      "content": [
        {{
          "text": "docker run -d --name {image_name}-prod \\\\\\n  -p 5432:5432 \\\\\\n  -e POSTGRES_PASSWORD=secure_password \\\\\\n  -v {image_name}_data:/var/lib/postgresql/data \\\\\\n  --security-opt=no-new-privileges \\\\\\n  {registry_path}/{image_name}:latest"
        }}
      ],
      "type": "CODE",
      "code_language": "bash"
    }},
    {{
      "id": "development-setup",
      "title": "Development Setup",
      "description": "Quick database setup for development and testing",
      "content": [
        {{
          "text": "docker run -d --name {image_name}-dev \\\\\\n  -p 5432:5432 \\\\\\n  -e POSTGRES_PASSWORD=devpass \\\\\\n  {registry_path}/{image_name}:latest-dev"
        }}
      ],
      "type": "CODE",
      "code_language": "bash"
    }},
    {{
      "id": "docker-compose-setup",
      "title": "Docker Compose Setup",
      "description": "Complete database service configuration",
      "content": [
        {{
          "text": "version: '3.8'\\nservices:\\n  {image_name}:\\n    image: {registry_path}/{image_name}:latest\\n    container_name: {image_name}\\n    restart: unless-stopped\\n    ports:\\n      - \\"5432:5432\\"\\n    environment:\\n      POSTGRES_PASSWORD: secure_password\\n    volumes:\\n      - {image_name}_data:/var/lib/postgresql/data\\n    security_opt:\\n      - no-new-privileges:true\\nvolumes:\\n  {image_name}_data:"
        }}
      ],
      "type": "CODE",
      "code_language": "yaml"
    }},
    {{
      "id": "environment-variables",
      "title": "Environment Variables",
      "description": "Configuration options available through environment variables",
      "content": [
        {{
          "text": "| Variable | Default | Description |\\n|----------|---------|-------------|\\n| POSTGRES_PASSWORD | (required) | Password for the PostgreSQL superuser |\\n| POSTGRES_USER | postgres | PostgreSQL superuser username |\\n| POSTGRES_DB | postgres | Default database name |\\n| POSTGRES_HOST_AUTH_METHOD | trust | Authentication method for host connections |"
        }}
      ],
      "type": "TABLE"
    }},
    {{
      "id": "security-best-practices",
      "title": "Security Best Practices",
      "description": "Recommended security configurations and practices",
      "content": [
        {{
          "text": "Use strong, unique passwords for database users"
        }},
        {{
          "text": "Enable SSL/TLS encryption for connections"
        }},
        {{
          "text": "Configure proper firewall rules and network segmentation"
        }},
        {{
          "text": "Regular security updates and patch management"
        }},
        {{
          "text": "Implement proper backup and recovery procedures"
        }},
        {{
          "text": "Use read-only filesystems where possible"
        }},
        {{
          "text": "Monitor database access and query logs"
        }},
        {{
          "text": "Configure resource limits and connection pooling"
        }}
      ],
      "type": "TEXT"
    }},
    {{
      "id": "kubernetes-security-context",
      "title": "Kubernetes Security Context",
      "description": "Recommended security context for Kubernetes deployments",
      "content": [
        {{
          "text": "securityContext:\\n  runAsNonRoot: true\\n  runAsUser: 999\\n  runAsGroup: 999\\n  readOnlyRootFilesystem: false\\n  allowPrivilegeEscalation: false\\n  capabilities:\\n    drop: [\\\"ALL\\\"]"
        }}
      ],
      "type": "CODE",
      "code_language": "yaml"
    }},
    {{
      "id": "documentation-resources",
      "title": "Documentation Resources",
      "description": "Essential links and resources for further information",
      "content": [
        {{
          "text": "**Container Registry**: https://{registry_path.replace('/', '.')}"
        }},
        {{
          "text": "**Go Official Documentation**: https://go.org/"
        }}
      ],
      "type": "TEXT"
    }},
    {{
      "id": "connect-to-database",
      "title": "Connect to Database",
      "description": "Access database shell for administration",
      "content": [
        {{
          "text": "docker exec -it {image_name}-prod psql -U postgres"
        }}
      ],
      "type": "CODE",
      "code_language": "bash"
    }}
  ]'''
    
    def _get_webserver_commands(self, registry_path: str, image_name: str) -> str:
        """Get web server-specific commands."""
        full_image = f"{registry_path}/{image_name}"
        return f'''[
    {{
      "id": "key-features",
      "title": "Key Features",
      "description": "Core capabilities and strengths of this web server container",
      "content": [
        {{
          "text": "High-performance HTTP server and reverse proxy"
        }},
        {{
          "text": "Lightweight architecture with low memory footprint"
        }},
        {{
          "text": "Advanced load balancing and caching capabilities"
        }},
        {{
          "text": "Enterprise-grade security features and SSL/TLS support"
        }}
      ],
      "type": "TEXT"
    }},
    {{
      "id": "common-use-cases",
      "title": "Common Use Cases",
      "description": "Typical scenarios where this web server container excels",
      "content": [
        {{
          "text": "Static website hosting and content delivery"
        }},
        {{
          "text": "Reverse proxy for microservices architecture"
        }},
        {{
          "text": "Load balancer for distributed applications"
        }},
        {{
          "text": "SSL termination and security gateway"
        }}
      ],
      "type": "TEXT"
    }},
    {{
      "id": "pull-commands",
      "title": "Pull Commands",
      "description": "Download the web server container images",
      "content": [
        {{
          "text": "docker pull {registry_path}/{image_name}:latest"
        }},
        {{
          "text": "docker pull {registry_path}/{image_name}:latest-dev"
        }}
      ],
      "type": "CODE",
      "code_language": "bash"
    }},
    {{
      "id": "basic-web-server",
      "title": "Basic Web Server",
      "description": "Start web server with default configuration",
      "content": [
        {{
          "text": "docker run -d --name {image_name}-server \\\\\\n  -p 80:80 \\\\\\n  --security-opt=no-new-privileges \\\\\\n  {registry_path}/{image_name}:latest"
        }}
      ],
      "type": "CODE",
      "code_language": "bash"
    }},
    {{
      "id": "custom-content-mount",
      "title": "Custom Content Mount",
      "description": "Serve custom content by mounting local directory",
      "content": [
        {{
          "text": "docker run -d --name {image_name}-custom \\\\\\n  -p 8080:80 \\\\\\n  -v $(pwd)/html:/usr/share/nginx/html:ro \\\\\\n  {registry_path}/{image_name}:latest"
        }}
      ],
      "type": "CODE",
      "code_language": "bash"
    }},
    {{
      "id": "reverse-proxy-setup",
      "title": "Reverse Proxy Setup",
      "description": "Configure as reverse proxy for backend services",
      "content": [
        {{
          "text": "docker run -d --name {image_name}-proxy \\\\\\n  -p 80:80 \\\\\\n  -v $(pwd)/nginx.conf:/etc/nginx/nginx.conf:ro \\\\\\n  {registry_path}/{image_name}:latest"
        }}
      ],
      "type": "CODE",
      "code_language": "bash"
    }},
    {{
      "id": "docker-compose-web",
      "title": "Docker Compose Web Service",
      "description": "Complete web service configuration",
      "content": [
        {{
          "text": "version: '3.8'\\nservices:\\n  {image_name}:\\n    image: {registry_path}/{image_name}:latest\\n    container_name: {image_name}\\n    restart: unless-stopped\\n    ports:\\n      - \\"80:80\\"\\n    volumes:\\n      - ./html:/usr/share/nginx/html:ro\\n    security_opt:\\n      - no-new-privileges:true"
        }}
      ],
      "type": "CODE",
      "code_language": "yaml"
    }},
    {{
      "id": "environment-variables",
      "title": "Environment Variables",
      "description": "Configuration options available through environment variables",
      "content": [
        {{
          "text": "| Variable | Default | Description |\\n|----------|---------|-------------|\\n| NGINX_HOST | localhost | Server hostname |\\n| NGINX_PORT | 80 | Server listening port |\\n| NGINX_ENVSUBST_TEMPLATE_DIR | /etc/nginx/templates | Template directory for configuration |\\n| NGINX_ENVSUBST_TEMPLATE_SUFFIX | .template | Template file suffix |"
        }}
      ],
      "type": "TABLE"
    }},
    {{
      "id": "security-best-practices",
      "title": "Security Best Practices",
      "description": "Recommended security configurations and practices",
      "content": [
        {{
          "text": "Configure SSL/TLS certificates for HTTPS"
        }},
        {{
          "text": "Implement proper access controls and rate limiting"
        }},
        {{
          "text": "Use security headers (HSTS, CSP, X-Frame-Options)"
        }},
        {{
          "text": "Regular security updates and vulnerability scanning"
        }},
        {{
          "text": "Configure proper logging and monitoring"
        }},
        {{
          "text": "Use read-only filesystems for static content"
        }},
        {{
          "text": "Implement proper firewall rules"
        }},
        {{
          "text": "Hide server version information"
        }}
      ],
      "type": "TEXT"
    }},
    {{
      "id": "kubernetes-security-context",
      "title": "Kubernetes Security Context",
      "description": "Recommended security context for Kubernetes deployments",
      "content": [
        {{
          "text": "securityContext:\\n  runAsNonRoot: true\\n  runAsUser: 101\\n  runAsGroup: 101\\n  readOnlyRootFilesystem: true\\n  allowPrivilegeEscalation: false\\n  capabilities:\\n    drop: [\\\"ALL\\\"]"
        }}
      ],
      "type": "CODE",
      "code_language": "yaml"
    }},
    {{
      "id": "documentation-resources",
      "title": "Documentation Resources",
      "description": "Essential links and resources for further information",
      "content": [
        {{
          "text": "**Container Registry**: https://{registry_path.replace('/', '.')}"
        }},
        {{
          "text": "**Go Official Documentation**: https://go.org/"
        }}
      ],
      "type": "TEXT"
    }}
  ]'''
    
    def _get_runtime_commands(self, registry_path: str, image_name: str) -> str:
        """Get programming language runtime-specific commands."""
        full_image = f"{registry_path}/{image_name}"
        
        # Determine the proper interpreter command based on image type
        if image_name.lower() == 'node':
            hello_world_cmd = f"docker run --rm <<{registry_path}>>/{image_name}:latest-dev node -e 'console.log(\\\"Hello, World!\\\")'"
        elif image_name.lower() == 'python':
            hello_world_cmd = f"docker run --rm <<{registry_path}>>/{image_name}:latest-dev python -c 'print(\\\"Hello, World!\\\")'"
        elif image_name.lower() == 'java':
            hello_world_cmd = f"docker run --rm <<{registry_path}>>/{image_name}:latest-dev java -version"
        elif image_name.lower() == 'go':
            hello_world_cmd = f"docker run --rm <<{registry_path}>>/{image_name}:latest-dev go version"
        elif image_name.lower() == 'php':
            hello_world_cmd = f"docker run --rm <<{registry_path}>>/{image_name}:latest-dev php -r 'echo \\\"Hello, World!\\\\n\\\";'"
        else:
            hello_world_cmd = f"docker run --rm <<{registry_path}>>/{image_name}:latest-dev -c 'print(\\\"Hello, World!\\\")'"
        
        return f'''[
    {{
      "id": "key-features",
      "title": "Key Features",
      "description": "Core capabilities and strengths of this runtime container",
      "content": [
        {{
          "text": "Integrated development runtime environment"
        }},
        {{
          "text": "Built-in package management system"
        }},
        {{
          "text": "Support for multiple programming paradigms"
        }},
        {{
          "text": "Enterprise-grade security features and hardening"
        }}
      ],
      "type": "TEXT"
    }},
    {{
      "id": "common-use-cases",
      "title": "Common Use Cases",
      "description": "Typical scenarios where this runtime container excels",
      "content": [
        {{
          "text": "Web application development and deployment"
        }},
        {{
          "text": "Data processing and analysis pipelines"
        }},
        {{
          "text": "API service development"
        }},
        {{
          "text": "Automation and scripting tasks"
        }}
      ],
      "type": "TEXT"
    }},
    {{
      "id": "pull-commands",
      "title": "Pull Commands",
      "description": "Download the runtime container images",
      "content": [
        {{
          "text": "docker pull {registry_path}/{image_name}:latest"
        }},
        {{
          "text": "docker pull {registry_path}/{image_name}:latest-dev"
        }}
      ],
      "type": "CODE",
      "code_language": "bash"
    }},
    {{
      "id": "interactive-development",
      "title": "Interactive Development",
      "description": "Start interactive session for development",
      "content": [
        {{
          "text": "docker run -it --name {image_name}-dev \\\\\\n  -v $(pwd):/workspace \\\\\\n  -w /workspace \\\\\\n  {registry_path}/{image_name}:latest-dev /bin/sh"
        }}
      ],
      "type": "CODE",
      "code_language": "bash"
    }},
    {{
      "id": "run-hello-world",
      "title": "Run Hello World",
      "description": "Execute a simple Hello World program",
      "content": [
        {{
          "text": "{hello_world_cmd}"
        }}
      ],
      "type": "CODE",
      "code_language": "bash"
    }},
    {{
      "id": "mount-workspace",
      "title": "Mount Workspace",
      "description": "Run container with local workspace mounted",
      "content": [
        {{
          "text": "docker run --rm -v $(pwd):/app -w /app {registry_path}/{image_name}:latest-dev {image_name} --version"
        }}
      ],
      "type": "CODE",
      "code_language": "bash"
    }},
    {{
      "id": "application-server",
      "title": "Application Server",
      "description": "Run application with port forwarding",
      "content": [
        {{
          "text": "docker run -d --name {image_name}-app \\\\\\n  -p 8000:8000 \\\\\\n  -v $(pwd):/app \\\\\\n  -w /app \\\\\\n  {registry_path}/{image_name}:latest"
        }}
      ],
      "type": "CODE",
      "code_language": "bash"
    }},
    {{
      "id": "environment-variables",
      "title": "Environment Variables",
      "description": "Configuration options available through environment variables",
      "content": [
        {{
          "text": "| Variable | Default | Description |\\n|----------|---------|-------------|\\n| PATH | /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin | System PATH configuration |\\n| LANG | C.UTF-8 | Language and locale settings |\\n| {image_name.upper()}_VERSION | latest | Runtime version |\\n| HOME | /home/{image_name} | User home directory |"
        }}
      ],
      "type": "TABLE"
    }},
    {{
      "id": "security-best-practices",
      "title": "Security Best Practices",
      "description": "Recommended security configurations and practices",
      "content": [
        {{
          "text": "Use specific runtime versions in production"
        }},
        {{
          "text": "Implement proper dependency management"
        }},
        {{
          "text": "Configure secure coding practices"
        }},
        {{
          "text": "Regular security updates and vulnerability scanning"
        }},
        {{
          "text": "Use read-only filesystems where possible"
        }},
        {{
          "text": "Implement proper logging and monitoring"
        }},
        {{
          "text": "Configure resource limits and constraints"
        }},
        {{
          "text": "Use multi-stage builds for production images"
        }}
      ],
      "type": "TEXT"
    }},
    {{
      "id": "kubernetes-security-context",
      "title": "Kubernetes Security Context",
      "description": "Recommended security context for Kubernetes deployments",
      "content": [
        {{
          "text": "securityContext:\\n  runAsNonRoot: true\\n  runAsUser: 1000\\n  runAsGroup: 1000\\n  readOnlyRootFilesystem: true\\n  allowPrivilegeEscalation: false\\n  capabilities:\\n    drop: [\\\"ALL\\\"]"
        }}
      ],
      "type": "CODE",
      "code_language": "yaml"
    }},
    {{
      "id": "documentation-resources",
      "title": "Documentation Resources",
      "description": "Essential links and resources for further information",
      "content": [
        {{
          "text": "**Container Registry**: https://{registry_path.replace('/', '.')}"
        }},
        {{
          "text": "**Go Official Documentation**: https://go.org/"
        }}
      ],
      "type": "TEXT"
    }}
  ]'''
    
    def _get_generic_commands(self, registry_path: str, image_name: str) -> str:
        """Get generic commands for unknown container types."""
        full_image = f"{registry_path}/{image_name}"
        return f'''[
    {{
      "id": "key-features",
      "title": "Key Features",
      "description": "Core capabilities and strengths of this container",
      "content": [
        {{
          "text": "Optimized container runtime environment"
        }},
        {{
          "text": "Security-hardened base configuration"
        }},
        {{
          "text": "Enterprise-ready deployment capabilities"
        }},
        {{
          "text": "Multi-architecture support and compatibility"
        }}
      ],
      "type": "TEXT"
    }},
    {{
      "id": "common-use-cases",
      "title": "Common Use Cases",
      "description": "Typical scenarios where this container excels",
      "content": [
        {{
          "text": "Application deployment and hosting"
        }},
        {{
          "text": "Microservices architecture components"
        }},
        {{
          "text": "Development and testing environments"
        }},
        {{
          "text": "Production workload execution"
        }}
      ],
      "type": "TEXT"
    }},
    {{
      "id": "pull-latest-image",
      "title": "Pull Latest Image",
      "description": "Download the container image from the registry",
      "content": [
        {{
          "text": "docker pull {registry_path}/{image_name}:latest"
        }},
        {{
          "text": "docker pull {registry_path}/{image_name}:latest-dev"
        }}
      ],
      "type": "CODE",
      "code_language": "bash"
    }},
    {{
      "id": "basic-run",
      "title": "Basic Run",
      "description": "Run the container with basic configuration",
      "content": [
        {{
          "text": "docker run -it --name {image_name}-test {registry_path}/{image_name}:latest-dev"
        }}
      ],
      "type": "CODE",
      "code_language": "bash"
    }},
    {{
      "id": "production-deployment",
      "title": "Production Deployment",
      "description": "Deploy with production security settings",
      "content": [
        {{
          "text": "docker run -d --name {image_name}-prod \\\\\\n  --read-only \\\\\\n  --security-opt=no-new-privileges \\\\\\n  --user 1000:1000 \\\\\\n  {registry_path}/{image_name}:latest"
        }}
      ],
      "type": "CODE",
      "code_language": "bash"
    }},
    {{
      "id": "volume-mount",
      "title": "Volume Mount",
      "description": "Mount local directory for persistent data",
      "content": [
        {{
          "text": "docker run -v $(pwd)/data:/data {registry_path}/{image_name}:latest"
        }}
      ],
      "type": "CODE",
      "code_language": "bash"
    }},
    {{
      "id": "port-forwarding",
      "title": "Port Forwarding",
      "description": "Run with custom port mappings",
      "content": [
        {{
          "text": "docker run -p 8080:80 {registry_path}/{image_name}:latest"
        }}
      ],
      "type": "CODE",
      "code_language": "bash"
    }},
    {{
      "id": "environment-variables",
      "title": "Environment Variables",
      "description": "Configuration options available through environment variables",
      "content": [
        {{
          "text": "| Variable | Default | Description |\\n|----------|---------|-------------|\\n| PATH | /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin | System PATH configuration |\\n| HOME | /home/user | User home directory |\\n| USER | user | Default username |\\n| SHELL | /bin/sh | Default shell |"
        }}
      ],
      "type": "TABLE"
    }},
    {{
      "id": "security-best-practices",
      "title": "Security Best Practices",
      "description": "Recommended security configurations and practices",
      "content": [
        {{
          "text": "Use specific image tags for production (avoid latest)"
        }},
        {{
          "text": "Configure resource limits: memory and CPU constraints"
        }},
        {{
          "text": "Enable read-only root filesystem when possible"
        }},
        {{
          "text": "Run containers with non-root user (--user 1000:1000)"
        }},
        {{
          "text": "Use --security-opt=no-new-privileges flag"
        }},
        {{
          "text": "Regularly update container images for security patches"
        }},
        {{
          "text": "Implement proper network segmentation"
        }},
        {{
          "text": "Monitor container metrics for anomalies"
        }}
      ],
      "type": "TEXT"
    }},
    {{
      "id": "kubernetes-security-context",
      "title": "Kubernetes Security Context",
      "description": "Recommended security context for Kubernetes deployments",
      "content": [
        {{
          "text": "securityContext:\\n  runAsNonRoot: true\\n  runAsUser: 1000\\n  runAsGroup: 1000\\n  readOnlyRootFilesystem: true\\n  allowPrivilegeEscalation: false\\n  capabilities:\\n    drop: [\\\"ALL\\\"]"
        }}
      ],
      "type": "CODE",
      "code_language": "yaml"
    }},
    {{
      "id": "documentation-resources",
      "title": "Documentation Resources",
      "description": "Essential links and resources for further information",
      "content": [
        {{
          "text": "**Container Registry**: https://{registry_path.replace('/', '.')}"
        }},
        {{
          "text": "**Go Official Documentation**: https://go.org/"
        }}
      ],
      "type": "TEXT"
    }}
  ]'''

    def generate_json_prompt(self, image_input: str) -> str:
        """Generate a prompt to get structured JSON data for container documentation."""
        
        registry_path, image_name, site_name = self.parse_image_path(image_input)
        full_image_path = f"{registry_path}/{image_name}"
        
        custom_description = self.get_image_description(image_name)
        content_blocks = self.get_container_specific_commands(image_input)
        
        # Dynamic foundation text based on site
        foundation_text = f"Security-hardened, minimal base OS designed for enterprise containerized environments from {site_name}."
        
        # Determine featured tags based on image type and FIPS availability
        if "fips" in image_name.lower():
            featured_tags = '''[
    {"value": "fips-validated", "label": "FIPS Validated"},
    {"value": "stig-hardened", "label": "STIG Hardened"}
  ]'''
        else:
            featured_tags = '''[
    {"value": "fips-available", "label": "FIPS Available"},
    {"value": "security-hardened", "label": "Security Hardened"}
  ]'''
        
        return f"""CRITICAL INSTRUCTION: You MUST respond with ONLY valid JSON. No explanations, no markdown, no code blocks, no text before or after. Just pure JSON that can be parsed directly.

Generate JSON data for container documentation for the image "{full_image_path}" from {site_name}.

The JSON must follow this EXACT structure - fill in the placeholder values with appropriate content:

{{
  "image_name": "{image_name}",
  "full_image_path": "{full_image_path}",
  "registry_path": "{registry_path}",
  "site_name": "{site_name}",
  "title": "Container Documentation for {image_name.title()}",
  "description": "{custom_description if custom_description else '[Provide comprehensive description of ' + image_name + ' container purpose, features, and enterprise use cases]'}",
  "foundation_description": "{foundation_text}",
  "category": "[Select ONE from: Networking, Security, Languages & frameworks, Integration & delivery, Message queues, API management, Internet of things, Machine learning & AI, Developer tools, Data science, Web servers, Operating systems, Content management system, Databases & storage, Monitoring & observability, Web analytics]",
  "architecture": ["amd64", "arm64"],
  "os": "linux",
  "license": "[Research actual license for {image_name} - common ones: Apache-2.0, MIT, GPL-3.0, BSD-3-Clause, Proprietary]",
  "tags": [
    {{"value": "example-tag", "label": "Example Tag"}}
  ],
  "featured": {featured_tags},
  "content_blocks": {content_blocks}
}}

RESPOND WITH ONLY THE JSON OBJECT ABOVE - NO OTHER TEXT OR FORMATTING."""

    def get_registry_url(self, registry_path: str) -> str:
        """Generate appropriate URL for the registry."""
        if registry_path == self.default_registry:
            return f"https://{registry_path}"
        
        # Handle known registries
        if registry_path.startswith('docker.io'):
            return "https://hub.docker.com"
        elif registry_path.startswith('gcr.io'):
            return "https://gcr.io"
        elif registry_path.startswith('ghcr.io'):
            return "https://github.com/features/packages"
        elif registry_path.startswith('quay.io'):
            return "https://quay.io"
        elif registry_path.startswith('registry.redhat.io'):
            return "https://registry.redhat.io"
        elif registry_path.startswith('mcr.microsoft.com'):
            return "https://mcr.microsoft.com"
        elif registry_path.startswith('public.ecr.aws'):
            return "https://gallery.ecr.aws"
        elif registry_path.startswith('nvcr.io'):
            return "https://ngc.nvidia.com"
        else:
            return f"https://{registry_path.split('/')[0]}"

    def generate_markdown_from_json(self, json_data: Dict[str, Any]) -> str:
        """Generate markdown documentation from JSON data following dynamic structure."""
        
        content_blocks = json_data['content_blocks']
        full_image_path = json_data.get('full_image_path', f"{json_data.get('registry_path', 'unknown')}/{json_data['image_name']}")
        site_name = json_data.get('site_name', 'Container Registry')
        
        md_content = f"""**{json_data['title']}**

{json_data['description']}

📌 **Base Foundation**: {json_data.get('foundation_description', json_data.get('cleanstart_foundation', 'Optimized container environment'))}

**Image Path**: `{full_image_path}`
**Registry**: {site_name}

"""

        # Generate markdown sections from content_blocks
        for block in content_blocks:
            md_content += f"**{block['title']}**\n"
            md_content += f"{block['description']}\n\n"
            
            if block['type'] == 'CODE':
                for content_item in block['content']:
                    md_content += f"```{block['code_language']}\n{content_item['text']}\n```\n\n"
            elif block['type'] == 'TABLE':
                for content_item in block['content']:
                    md_content += f"{content_item['text']}\n\n"
            else:  # TEXT type
                for content_item in block['content']:
                    md_content += f"- {content_item['text']}\n"
                md_content += "\n"



        return md_content

    def call_claude_api(self, prompt: str, system_prompt: Optional[str] = None) -> str:
        """Call Claude API and return the response."""
        headers = {
            'Content-Type': 'application/json',
            'x-api-key': self.api_key,
            'anthropic-version': '2023-06-01'
        }
        
        data = {
            'model': self.model,
            'max_tokens': 4096,
            'messages': [{'role': 'user', 'content': prompt}],
            'temperature': 0.1
        }
        
        if system_prompt:
            data['system'] = system_prompt
        
        try:
            response = requests.post(self.api_url, headers=headers, json=data, timeout=30)
            response.raise_for_status()
            return response.json()['content'][0]['text']
        except requests.exceptions.RequestException as e:
            raise RuntimeError(f"API call failed: {e}")
    
    def save_json_response(self, content: str, image_input: str) -> tuple[str, Dict[str, Any]]:
        """Save the JSON response to a file and return the filename and parsed data."""
        registry_path, image_name, _ = self.parse_image_path(image_input)
        filename = f"{image_name}.json"
        filepath = self.json_dir / filename
        
        # Debug: Print the raw response
        print(f"🔍 Raw API response length: {len(content)} characters")
        print(f"🔍 First 200 chars: {content[:200]}...")
        
        try:
            # Parse JSON to validate it
            json_data = json.loads(content.strip())
            
            # Pretty print JSON to file
            with open(filepath, 'w', encoding='utf-8') as f:
                json.dump(json_data, f, indent=2, ensure_ascii=False)
            
            print(f"✅ Valid JSON parsed and saved")
            return filename, json_data
            
        except json.JSONDecodeError as e:
            # Save the raw response for debugging
            debug_filename = f"DEBUG-{filename}.txt"
            debug_filepath = self.json_dir / debug_filename
            with open(debug_filepath, 'w', encoding='utf-8') as f:
                f.write(f"RAW API RESPONSE:\n{content}\n\nJSON ERROR: {e}")
            
            print(f"❌ JSON parsing failed. Raw response saved to: {debug_filename}")
            raise ValueError(f"Invalid JSON response from API: {e}\nCheck {debug_filename} for raw response")
    
    def save_markdown_response(self, content: str, image_input: str) -> str:
        """Save the markdown content to a file and return the filename."""
        registry_path, image_name, _ = self.parse_image_path(image_input)
        filename = f"{image_name}.md"
        filepath = self.md_dir / filename
        
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content.strip())
        
        return filename
    
    def generate_docs(self, image_input: str, system_prompt: Optional[str] = None) -> tuple[str, str]:
        """Generate documentation for any container image. Returns (json_filename, md_filename)."""
        registry_path, image_name, site_name = self.parse_image_path(image_input)
        full_image_path = f"{registry_path}/{image_name}"
        
        print(f"🚀 Generating documentation for {full_image_path} from {site_name}...")
        
        # Step 1: Generate JSON data with strict system prompt
        print(f"📊 Step 1: Generating JSON structure...")
        json_prompt = self.generate_json_prompt(image_input)
        
        # Use a very strict system prompt for JSON generation
        json_system_prompt = (
            "You are a JSON data generator. You MUST respond with ONLY valid JSON. "
            "Do not include any markdown formatting, code blocks, explanations, or additional text. "
            "Your entire response must be a single valid JSON object that can be parsed directly. "
            "Never use markdown code blocks (```json) or any other formatting."
        )
        
        json_response = self.call_claude_api(json_prompt, json_system_prompt)
        
        # Clean the response - remove any potential markdown formatting
        json_response = json_response.strip()
        if json_response.startswith('```json'):
            json_response = json_response[7:]  # Remove ```json
        if json_response.endswith('```'):
            json_response = json_response[:-3]   # Remove ```
        json_response = json_response.strip()
        
        json_filename, json_data = self.save_json_response(json_response, image_input)
        print(f"✅ JSON saved to: {json_filename}")
        
        # Step 2: Generate Markdown from JSON
        print(f"📝 Step 2: Generating Markdown from JSON...")
        markdown_content = self.generate_markdown_from_json(json_data)
        md_filename = self.save_markdown_response(markdown_content, image_input)
        print(f"✅ Markdown saved to: {md_filename}")
        
        return json_filename, md_filename
    
    def generate_multiple_docs(self, images: List[str], system_prompt: Optional[str] = None) -> List[tuple[str, str]]:
        """Generate documentation for multiple container images."""
        results = []
        total = len(images)
        
        print(f"📝 Starting documentation generation for {total} container image(s)...\n")
        
        for i, image_input in enumerate(images, 1):
            try:
                registry_path, image_name, site_name = self.parse_image_path(image_input)
                full_path = f"{registry_path}/{image_name}"
                
                print(f"[{i}/{total}] Processing: {full_path} from {site_name}")
                json_file, md_file = self.generate_docs(image_input, system_prompt)
                results.append((json_file, md_file))
                print()
            except Exception as e:
                print(f"❌ Failed to generate docs for {image_input}: {e}\n")
        
        return results

def main():
    """Main function to handle command line arguments and execute the generator."""
    parser = argparse.ArgumentParser(
        description="Generate container documentation for ANY container image with fully dynamic registry/path/site support using Claude API",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Simple image names (uses default registry)
  python3 container_docs.py nginx postgres redis --registry myregistry.com --site-name "My Registry"
  
  # Full registry paths (auto-detects site names)
  python3 container_docs.py docker.io/library/nginx gcr.io/project/my-app
  python3 container_docs.py ghcr.io/owner/repo quay.io/organization/redis
  
  # Mixed paths with custom defaults
  python3 container_docs.py nginx docker.io/library/postgres custom-registry/my-app
  
  # With custom options
  python3 container_docs.py custom-registry.io/team/my-app --output-dir ./docs
  python3 container_docs.py ghcr.io/owner/repo --system-prompt "Focus on enterprise features"
        """
    )
    parser.add_argument(
        '--registry',
        help='Default container registry URL (default: registry.example.com). Used when no registry is specified in image path.',
        default='registry.example.com'
    )
    parser.add_argument(
        '--site-name',
        help='Default site name for documentation (default: auto-generated from registry)',
        default=None
    )
    parser.add_argument(
        'images',
        nargs='+',
        help='Container image names or paths to generate documentation for. Examples: nginx, docker.io/library/nginx, gcr.io/project/app'
    )
    parser.add_argument(
        '--system-prompt',
        help='Custom system prompt for the API call'
    )
    parser.add_argument(
        '--output-dir',
        help='Output directory for generated files (default: responses)'
    )
    
    args = parser.parse_args()
    
    try:
        # Determine site name
        default_site_name = args.site_name
        if not default_site_name:
            # Auto-generate from registry
            if args.registry == '{registry.example.com}':
                default_site_name = 'Example Registry'
            else:
                base_name = args.registry.split('.')[0]
                default_site_name = f"{base_name.title()} Registry"
        
        generator = ContainerDocsGenerator(args.registry or "{registry.example.com}", default_site_name)
        
        # Add enhanced custom descriptions (these work for any registry)
        busybox_description = """BusyBox combines tiny versions of many common UNIX utilities into a single small executable. It provides a complete environment for any small or embedded system, featuring over 300 common Linux commands. BusyBox is known as 'The Swiss Army Knife of Embedded Linux' and serves as a minimal foundation for containerized applications."""
        
        nginx_description = """High-performance web server and reverse proxy server known for its stability, rich feature set, simple configuration, and low resource consumption. This container image provides a secure, lightweight, and production-ready web server environment optimized for containerized deployments."""
        
        postgres_description = """PostgreSQL is a powerful, open source object-relational database system that uses and extends the SQL language combined with many features that safely store and scale the most complicated data workloads. This container provides a production-ready PostgreSQL database server."""
        
        node_description = """Node.js is a JavaScript runtime built on Chrome's V8 JavaScript engine. This container image provides a complete Node.js development and runtime environment with npm package manager, optimized for building scalable network applications, APIs, and microservices in containerized environments."""
        
        generator.add_custom_description('busybox', busybox_description)
        generator.add_custom_description('nginx', nginx_description)
        generator.add_custom_description('postgres', postgres_description)
        generator.add_custom_description('postgresql', postgres_description)
        generator.add_custom_description('node', node_description)
        generator.add_custom_description('nodejs', node_description)
        
        if args.output_dir:
            generator.output_dir = Path(args.output_dir)
            generator.json_dir = generator.output_dir / 'json'
            generator.md_dir = generator.output_dir / 'markdown'
            
            generator.output_dir.mkdir(exist_ok=True)
            generator.json_dir.mkdir(exist_ok=True)
            generator.md_dir.mkdir(exist_ok=True)
        
        default_system_prompt = (
            "You are a technical documentation specialist for containerized applications. "
            "Generate comprehensive, well-structured JSON data for container documentation. "
            "Research the specific technology if you know it, otherwise provide professional generic templates. "
            "Return ONLY valid JSON without any markdown formatting or code blocks. "
            "Focus on accuracy, security best practices, enterprise use cases, and real-world usage scenarios. "
            "Structure the documentation following enterprise container documentation standards. "
            "Always respect the registry and site information provided in the prompt."
        )
        
        system_prompt = args.system_prompt or default_system_prompt
        
        # Print summary of what will be processed
        print("🔍 Processing the following images:")
        for image_input in args.images:
            registry_path, image_name, site_name = generator.parse_image_path(image_input)
            full_path = f"{registry_path}/{image_name}"
            print(f"  • {image_input} → {full_path} from {site_name}")
        print()
        
        file_pairs = generator.generate_multiple_docs(args.images, system_prompt)
        
        print("=" * 80)
        print(f"🎉 Successfully generated {len(file_pairs)} documentation set(s):")
        for json_file, md_file in file_pairs:
            print(f"  📊 JSON: {json_file}")
            print(f"  📄 MD:   {md_file}")
            print()
        print(f"📁 JSON files: {generator.json_dir}")
        print(f"📁 Markdown files: {generator.md_dir}")
        print("=" * 80)
            
    except KeyboardInterrupt:
        print("\n⚠️  Operation cancelled by user")
        sys.exit(1)
    except Exception as e:
        print(f"❌ Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
