#!/usr/bin/env python3
"""
Triam Security Container Documentation Generator
A Python script to generate enhanced container documentation using Anthropic's Claude API.
Works dynamically for any container image.
Now creates JSON first, then generates MD from JSON.
Enhanced with comprehensive documentation format matching cAdvisor example.
"""

import os
import sys
import argparse
import requests
import json
import logging
from datetime import datetime
from pathlib import Path
from typing import List, Dict, Optional, Any, Tuple
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)


class ContainerDocsGenerator:
    """Generate Triam Security container documentation using Claude API."""

    def __init__(self, registry_url: str = "cleanstart", output_dir: Optional[str] = None):
        """
        Initialize the ContainerDocsGenerator.
        
        Args:
            registry_url: Container registry URL (default: cleanstart)
            output_dir: Custom output directory (optional)
            
        Raises:
            ValueError: If GROK_API_KEY is not set
        """
        # Validate API key first
        self.api_key = os.getenv('GROK_API_KEY')
        if not self.api_key:
            raise ValueError("GROK_API_KEY environment variable is required")
        
        self.registry_url = registry_url
        self.api_url = 'https://api.anthropic.com/v1/messages'
        self.model = 'claude-3-5-sonnet-20241022'
        
        # Set up output directories
        if output_dir:
            self.output_dir = Path(output_dir)
        else:
            self.output_dir = Path('responses')
        
        self.json_dir = self.output_dir / 'json'
        self.md_dir = self.output_dir / 'markdown'
        
        # Create directories
        self._create_directories()
        
        # Initialize custom configurations
        self.custom_descriptions = {}
        self.cleanstart_foundation_text = "Security-hardened, minimal base OS designed for enterprise containerized environments."
        
        logger.info(f"ContainerDocsGenerator initialized with registry: {registry_url}")

    def _create_directories(self) -> None:
        """Create necessary output directories."""
        try:
            self.output_dir.mkdir(exist_ok=True)
            self.json_dir.mkdir(exist_ok=True)
            self.md_dir.mkdir(exist_ok=True)
            logger.debug(f"Created output directories: {self.output_dir}")
        except Exception as e:
            logger.error(f"Failed to create directories: {e}")
            raise

    def add_custom_description(self, image: str, description: str) -> None:
        """
        Add custom description for a specific image.
        
        Args:
            image: Container image name
            description: Custom description text
        """
        self.custom_descriptions[image.lower()] = description
        logger.debug(f"Added custom description for {image}")

    def set_foundation_text(self, text: str) -> None:
        """
        Set custom CleanStart foundation text.
        
        Args:
            text: Foundation text to use
        """
        self.cleanstart_foundation_text = text
        logger.debug("Updated foundation text")

    def get_image_description(self, image: str) -> str:
        """
        Get custom description for specific images.
        
        Args:
            image: Container image name
            
        Returns:
            Custom description or empty string
        """
        return self.custom_descriptions.get(image.lower(), "")

    def generate_json_prompt(self, image: str) -> str:
        """
        Generate a prompt to get structured JSON data for container documentation.
        
        Args:
            image: Container image name
            
        Returns:
            Formatted prompt string
        """
        custom_description = self.get_image_description(image)
        
        return f"""You are a technical documentation specialist. Generate comprehensive structured JSON data for CleanStart container documentation for the image "{image}".

IMPORTANT: Research and provide accurate information about this specific container image. If you don't have specific knowledge about "{image}", provide a professional generic template but mention it in the description.

Generate the JSON following this EXACT structure:

{{
  "image_name": "{image}",
  "title": "CleanStart {image.title()} Container",
  "container_image": "cleanstart/{image}",
  "license": "[Research and determine the actual license for {image} technology. Common licenses: Apache-2.0, MIT, GPL-3.0, BSD-3-Clause, ISC, MPL-2.0. For proprietary software use 'Proprietary'. If uncertain, use 'Various']",
  "architecture": ["AMD64", "ARM64"],
  "registry": "us-central1-docker.pkg.dev/ct2-dev-build/ct2-image-repo-dev-build",
  "overview": {{
    "description": "{custom_description if custom_description else '[Write a comprehensive 2-3 sentence description of what this ' + image + ' container provides. Include the main purpose, key features, and what tools/runtime it includes. If it is a well-known image, provide specific details.]'}",
    "cleanstart_foundation": "{self.cleanstart_foundation_text}",
    "key_features": [
      "[Feature 1 based on {image} technology - be specific]",
      "[Feature 2 based on {image} technology - be specific]",
      "[Feature 3 based on {image} technology - be specific]",
      "[Feature 4 based on {image} technology - be specific]",
      "Security hardened: Non-root, minimal attack surface",
      "FIPS compliance: Available with -fips tag"
    ]
  }},
  "common_use_cases": [
    "[Use case 1 for {image} based on the technology]",
    "[Use case 2 for {image} based on the technology]",
    "[Use case 3 for {image} based on the technology]",
    "[Use case 4 for {image} based on the technology]"
  ],

  "quick_start": {{
    "basic_production": {{
      "title": "Basic Production Deployment",
      "description": "Standard production deployment with recommended settings",
      "commands": [
        "[Generate appropriate docker run command for {image} in production. For web services include port mapping like -p 8080:8080. For databases include environment variables. For tools include volume mounts if needed.]"
      ],
      "access_info": "[If applicable, provide access information like 'Access: http://localhost:8080' or 'Connect using: docker exec -it container-name /bin/sh']"
    }},
    "development": {{
      "title": "Development/Testing",
      "description": "Development setup with debugging capabilities",
      "commands": [
        "# Interactive session",
        "docker run -it --privileged cleanstart/{image}:latest-dev /bin/sh",
        "# With custom configuration",
        "[Generate appropriate development command with environment variables or custom config for {image}]"
      ]
    }}
  }},
  "docker_compose": {{
    "version": "3.8",
    "services": {{
      "{image}": {{
        "image": "cleanstart/{image}:latest",
        "container_name": "{image}",
        "restart": "unless-stopped",
        "ports": "[Generate appropriate port mapping for {image} if it's a service, or remove if not needed]",
        "volumes": "[Generate appropriate volume mounts for {image} based on its needs]",
        "environment": "[Add environment variables if typically needed for {image}]",
        "security_opt": [
          "no-new-privileges:true"
        ],
        "read_only": true,
        "tmpfs": [
          "/tmp"
        ]
      }}
    }}
  }},
  "configuration": {{
    "environment_variables": [
      {{
        "variable": "[ENV_VAR_1 for {image}]",
        "default": "[default value]",
        "description": "[description of what this variable controls]"
      }},
      {{
        "variable": "[ENV_VAR_2 for {image}]",
        "default": "[default value]",
        "description": "[description of what this variable controls]"
      }}
    ],
    "command_arguments": {{
      "description": "Common command line arguments",
      "example": "docker run cleanstart/{image}:latest [appropriate flags for {image}]",
      "common_flags": [
        "[Flag 1 with description for {image}]",
        "[Flag 2 with description for {image}]",
        "[Flag 3 with description for {image}]"
      ]
    }}
  }},
  "security": {{
    "security_context": {{
      "runAsNonRoot": true,
      "runAsUser": 1000,
      "runAsGroup": 1000,
      "readOnlyRootFilesystem": true,
      "allowPrivilegeEscalation": false,
      "capabilities": {{
        "drop": ["ALL"],
        "add": ["[Any specific capabilities needed for {image}, or leave empty array]"]
      }}
    }},
    "best_practices": [
      "Use specific image tags for production (avoid latest)",
      "Configure resource limits: memory: 1Gi, cpu: 500m",
      "Enable read-only root filesystem",
      "Regularly update container images",
      "[Specific security practice for {image} technology]",
      "Monitor container metrics for anomalies"
    ]
  }},
  "health_monitoring": {{
    "api_endpoints": [
      {{
        "endpoint": "/health",
        "description": "Health check endpoint",
        "example": "curl http://localhost:8080/health"
      }},
      {{
        "endpoint": "[Another endpoint relevant to {image}]",
        "description": "[Description]",
        "example": "curl http://localhost:8080/[endpoint]"
      }}
    ],
    "container_management": [
      {{
        "action": "Check status",
        "command": "docker ps --format \\"table {{{{.Names}}}}\\\\t{{{{.Status}}}}\\\\t{{{{.Ports}}}}\\""
      }},
      {{
        "action": "View logs",
        "command": "docker logs {image}"
      }},
      {{
        "action": "Version info",
        "command": "docker exec {image} [appropriate version command for {image}]"
      }}
    ]
  }},
  "architecture_support": {{
    "description": "Multi-Platform Images",
    "commands": [
      "# Architecture-specific pulls",
      "docker pull --platform linux/amd64 cleanstart/{image}:latest",
      "docker pull --platform linux/arm64 cleanstart/{image}:latest",
      "# Auto-detection (recommended)",
      "docker pull cleanstart/{image}:latest"
    ]
  }},
  "resources": {{
    "essential_links": [
      {{
        "title": "Complete Documentation",
        "url": "cleanstart.io/docs/containers/{image}"
      }},
      {{
        "title": "Kubernetes Examples",
        "url": "github.com/cleanstart/kubernetes-examples"
      }},
      {{
        "title": "Helm Charts",
        "url": "charts.cleanstart.io"
      }},
      {{
        "title": "{image.title()} Official",
        "url": "[Official project URL for {image} if known, otherwise generic placeholder]"
      }}
    ],
    "advanced_usage": [
      "Kubernetes DaemonSet deployments - See full documentation",
      "Helm chart configurations - Available in our chart repository",
      "GitOps with ArgoCD - Complete examples in docs",
      "CI/CD integration - Pipeline templates available",
      "Enterprise monitoring setups - Contact support"
    ]
  }},
  "support": {{
    "issues": "GitHub Issues",
    "community": "Discussions",
    "enterprise": "Contact CleanStart Foundation"
  }},
  "footer": {{
    "organization": "CleanStart Foundation",
    "updated": "{datetime.now().strftime('%B %d, %Y')}",
    "version": "[Appropriate version for {image}]"
  }},
  "generated_at": "{datetime.now().isoformat()}",
  "generator_version": "5.0"
}}

CRITICAL: Return ONLY valid JSON without any markdown formatting, code blocks, or extra text. The response should be parseable JSON. Make sure to research the specific technology for {image} and provide accurate, relevant information."""

    def generate_markdown_from_json(self, json_data: Dict[str, Any]) -> str:
        """
        Generate comprehensive markdown documentation from JSON data.
        
        Args:
            json_data: Parsed JSON data from API response
            
        Returns:
            Formatted markdown content
        """
        data = json_data
        image_name = data['image_name']
        
        # Header section
        md_content = f"""{data['title']}
Container Image: {data['container_image']}
License: {data['license']} | Architecture: {', '.join(data['architecture'])}
Registry: {data['registry']}

## Overview
{data['overview']['description']}

📌 CleanStart Foundation: {data['overview']['cleanstart_foundation']}

### Key Features
{chr(10).join(f"- {feature}" for feature in data['overview']['key_features'])}

### Common Use Cases
{chr(10).join(f"- {use_case}" for use_case in data['common_use_cases'])}

```bash
# Pull commands
docker pull cleanstart/{image_name}:latest
docker pull cleanstart/{image_name}:latest-dev
```

## Quick Start

### {data['quick_start']['basic_production']['title']}
{data['quick_start']['basic_production']['description']}

```bash"""
        for cmd in data['quick_start']['basic_production']['commands']:
            md_content += f"\n{cmd}"
        md_content += "\n```"
        
        if data['quick_start']['basic_production'].get('access_info'):
            md_content += f"\n{data['quick_start']['basic_production']['access_info']}\n"

        md_content += f"""
### {data['quick_start']['development']['title']}
{data['quick_start']['development']['description']}

```bash"""
        for cmd in data['quick_start']['development']['commands']:
            md_content += f"\n{cmd}"
        md_content += "\n```"

        # Docker Compose section
        md_content += f"""

## Docker Compose

```yaml
version: '{data['docker_compose']['version']}'
services:
  {image_name}:"""
        
        service = data['docker_compose']['services'][image_name]
        for key, value in service.items():
            if isinstance(value, list):
                md_content += f"\n    {key}:"
                for item in value:
                    md_content += f"\n      - {item}"
            elif isinstance(value, str):
                md_content += f"\n    {key}: {value}"
            elif isinstance(value, bool):
                md_content += f"\n    {key}: {str(value).lower()}"

        md_content += "\n```"

        # Configuration section
        md_content += f"""

## Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|"""

        for env_var in data['configuration']['environment_variables']:
            md_content += f"\n| {env_var['variable']} | {env_var['default']} | {env_var['description']} |"

        md_content += f"""

### Command Arguments
{data['configuration']['command_arguments']['description']}

```bash
{data['configuration']['command_arguments']['example']}
```

#### Common Flags
{chr(10).join(f"- {flag}" for flag in data['configuration']['command_arguments']['common_flags'])}

## Security & Best Practices

### Recommended Security Context
```yaml
securityContext:
  runAsNonRoot: {str(data['security']['security_context']['runAsNonRoot']).lower()}
  runAsUser: {data['security']['security_context']['runAsUser']}
  runAsGroup: {data['security']['security_context']['runAsGroup']}
  readOnlyRootFilesystem: {str(data['security']['security_context']['readOnlyRootFilesystem']).lower()}
  allowPrivilegeEscalation: {str(data['security']['security_context']['allowPrivilegeEscalation']).lower()}
  capabilities:
    drop: {json.dumps(data['security']['security_context']['capabilities']['drop'])}"""

        if data['security']['security_context']['capabilities']['add']:
            md_content += f"\n    add: {json.dumps(data['security']['security_context']['capabilities']['add'])}"

        md_content += f"""
```

### Best Practices
{chr(10).join(f"- {practice}" for practice in data['security']['best_practices'])}

## Health Checks & Monitoring

### API Endpoints"""

        for endpoint in data['health_monitoring']['api_endpoints']:
            md_content += f"""
```bash
# {endpoint['description']}
{endpoint['example']}
```"""

        md_content += f"""

### Container Management"""

        for mgmt in data['health_monitoring']['container_management']:
            md_content += f"""
```bash
# {mgmt['action']}
{mgmt['command']}
```"""

        md_content += f"""

## Architecture Support

### {data['architecture_support']['description']}
```bash"""
        for cmd in data['architecture_support']['commands']:
            md_content += f"\n{cmd}"
        md_content += "\n```"

        # Resources section
        md_content += f"""

## Resources & Documentation

### Essential Links
{chr(10).join(f"- **{link['title']}**: {link['url']}" for link in data['resources']['essential_links'])}

### Advanced Usage
{chr(10).join(f"- {usage}" for usage in data['resources']['advanced_usage'])}

## Support
- **Issues**: {data['support']['issues']}
- **Community**: {data['support']['community']}
- **Enterprise Support**: {data['support']['enterprise']}

---
**{data['footer']['organization']}** | Updated: {data['footer']['updated']} | Version: {data['footer']['version']}"""

        return md_content

    def call_claude_api(self, prompt: str, system_prompt: Optional[str] = None) -> str:
        """
        Call Claude API and return the response.
        
        Args:
            prompt: User prompt to send to API
            system_prompt: Optional system prompt
            
        Returns:
            API response text
            
        Raises:
            RuntimeError: If API call fails
        """
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
            logger.debug("Making API call to Claude")
            response = requests.post(self.api_url, headers=headers, json=data, timeout=30)
            response.raise_for_status()
            
            response_data = response.json()
            if 'content' not in response_data or not response_data['content']:
                raise RuntimeError("Invalid API response format")
                
            return response_data['content'][0]['text']
            
        except requests.exceptions.RequestException as e:
            logger.error(f"API request failed: {e}")
            raise RuntimeError(f"API call failed: {e}")
        except (KeyError, IndexError) as e:
            logger.error(f"Invalid API response format: {e}")
            raise RuntimeError(f"Invalid API response format: {e}")

    def save_json_response(self, content: str, image: str) -> Tuple[str, Dict[str, Any]]:
        """
        Save the JSON response to a file and return the filename and parsed data.
        
        Args:
            content: JSON content from API
            image: Container image name
            
        Returns:
            Tuple of (filename, parsed_json_data)
            
        Raises:
            ValueError: If JSON is invalid
        """
        timestamp = int(datetime.now().timestamp() * 1000)
        safe_image = ''.join(c for c in image if c.isalnum() or c in '_-')
        filename = f"{timestamp}-{safe_image}.json"
        filepath = self.json_dir / filename
        
        try:
            # Parse JSON to validate it
            json_data = json.loads(content.strip())
            
            # Pretty print JSON to file
            with open(filepath, 'w', encoding='utf-8') as f:
                json.dump(json_data, f, indent=2, ensure_ascii=False)
            
            logger.debug(f"Saved JSON response to {filename}")
            return filename, json_data
            
        except json.JSONDecodeError as e:
            logger.error(f"Invalid JSON response: {e}")
            raise ValueError(f"Invalid JSON response from API: {e}")
        except IOError as e:
            logger.error(f"Failed to save JSON file: {e}")
            raise

    def save_markdown_response(self, content: str, image: str) -> str:
        """
        Save the markdown content to a file and return the filename.
        
        Args:
            content: Markdown content
            image: Container image name
            
        Returns:
            Filename of saved markdown file
            
        Raises:
            IOError: If file cannot be saved
        """
        timestamp = int(datetime.now().timestamp() * 1000)
        safe_image = ''.join(c for c in image if c.isalnum() or c in '_-')
        filename = f"{timestamp}-{safe_image}.md"
        filepath = self.md_dir / filename
        
        try:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content.strip())
            
            logger.debug(f"Saved markdown response to {filename}")
            return filename
            
        except IOError as e:
            logger.error(f"Failed to save markdown file: {e}")
            raise

    def generate_docs(self, image: str, system_prompt: Optional[str] = None) -> Tuple[str, str]:
        """
        Generate documentation for any container image.
        
        Args:
            image: Container image name
            system_prompt: Optional custom system prompt
            
        Returns:
            Tuple of (json_filename, md_filename)
        """
        logger.info(f"Generating documentation for {image}")
        
        # Step 1: Generate JSON data
        logger.info("Step 1: Generating comprehensive JSON structure")
        json_prompt = self.generate_json_prompt(image)
        json_response = self.call_claude_api(json_prompt, system_prompt)
        json_filename, json_data = self.save_json_response(json_response, image)
        logger.info(f"JSON saved to: {json_filename}")
        
        # Step 2: Generate Markdown from JSON
        logger.info("Step 2: Generating comprehensive Markdown from JSON")
        markdown_content = self.generate_markdown_from_json(json_data)
        md_filename = self.save_markdown_response(markdown_content, image)
        logger.info(f"Markdown saved to: {md_filename}")
        
        return json_filename, md_filename

    def generate_multiple_docs(self, images: List[str], system_prompt: Optional[str] = None) -> List[Tuple[str, str]]:
        """
        Generate documentation for multiple container images.
        
        Args:
            images: List of container image names
            system_prompt: Optional custom system prompt
            
        Returns:
            List of tuples (json_filename, md_filename)
        """
        results = []
        total = len(images)
        
        logger.info(f"Starting comprehensive documentation generation for {total} container image(s)")
        
        for i, image in enumerate(images, 1):
            try:
                logger.info(f"[{i}/{total}] Processing: {image}")
                json_file, md_file = self.generate_docs(image, system_prompt)
                results.append((json_file, md_file))
                logger.info(f"Completed: {image}")
            except Exception as e:
                logger.error(f"Failed to generate docs for {image}: {e}")
                # Continue with other images instead of failing completely
        
        return results


def main():
    """Main function to handle command line arguments and execute the generator."""
    parser = argparse.ArgumentParser(
        description="Generate comprehensive CleanStart container documentation for ANY container image using Claude API (Enhanced format with full feature set)",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python3 generate.py cadvisor nginx redis
  python3 generate.py custom-app my-service --output-dir ./docs
  python3 generate.py apache postgres mongodb elasticsearch
  python3 generate.py my-company/custom-image --system-prompt "Focus on enterprise features"
        """
    )
    parser.add_argument(
        '--registry',
        help='Container registry URL (default: cleanstart)',
        default='cleanstart'
    )
    parser.add_argument(
        'images',
        nargs='+',
        help='Container image names to generate documentation for (works with ANY image name)'
    )
    parser.add_argument(
        '--system-prompt',
        help='Custom system prompt for the API call'
    )
    parser.add_argument(
        '--output-dir',
        help='Output directory for generated files (default: responses)'
    )
    parser.add_argument(
        '--verbose', '-v',
        action='store_true',
        help='Enable verbose logging'
    )
    
    args = parser.parse_args()
    
    # Set logging level
    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)
    
    try:
        generator = ContainerDocsGenerator(
            registry_url=args.registry or "cleanstart",
            output_dir=args.output_dir
        )
        
        # Example of how to add custom descriptions dynamically
        cadvisor_description = """cAdvisor (Container Advisor) provides real-time resource usage and performance characteristics of running containers. Built on CleanStart's security-hardened Alpine base with automatic container discovery, historical data collection, and native Prometheus integration."""
        
        generator.add_custom_description('cadvisor', cadvisor_description)
        
        default_system_prompt = (
            "You are a senior technical documentation specialist for containerized applications with expertise in security and enterprise deployments. "
            "Generate comprehensive, production-ready documentation that matches enterprise standards. "
            "Research the specific technology thoroughly and provide accurate, detailed information. "
            "Focus on security best practices, real-world deployment scenarios, and operational excellence. "
            "Return ONLY valid JSON without any markdown formatting or code blocks."
        )
        
        system_prompt = args.system_prompt or default_system_prompt
        
        file_pairs = generator.generate_multiple_docs(args.images, system_prompt)
        
        logger.info("=" * 80)
        logger.info(f"🎉 Successfully generated {len(file_pairs)} comprehensive documentation set(s):")
        for json_file, md_file in file_pairs:
            logger.info(f"  📊 JSON: {json_file}")
            logger.info(f"  📄 MD:   {md_file}")
        logger.info(f"📁 JSON files: {generator.json_dir}")
        logger.info(f"📁 Markdown files: {generator.md_dir}")
        logger.info("=" * 80)
           
    except KeyboardInterrupt:
        logger.warning("Operation cancelled by user")
        sys.exit(1)
    except Exception as e:
        logger.error(f"Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
