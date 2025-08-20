#!/usr/bin/env python3
"""
Example usage of the Container Documentation Generator
This script demonstrates how to use the ContainerDocsGenerator class programmatically.
"""

import os
import sys
import logging
from pathlib import Path
from generate import ContainerDocsGenerator

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


def main():
    """Example usage of the ContainerDocsGenerator."""
    
    # Check if API key is set
    if not os.getenv('GROK_API_KEY'):
        logger.error("GROK_API_KEY environment variable is required")
        print("❌ Error: GROK_API_KEY environment variable is required")
        print("Please set your Anthropic Claude API key:")
        print("export GROK_API_KEY=your_api_key_here")
        print("Or create a .env file with: GROK_API_KEY=your_api_key_here")
        return 1
    
    try:
        # Initialize the generator
        logger.info("Initializing Container Documentation Generator...")
        print("🚀 Initializing Container Documentation Generator...")
        generator = ContainerDocsGenerator()
        
        # Add custom descriptions for specific images
        generator.add_custom_description('nginx', 
            'High-performance web server and reverse proxy. Built on CleanStart\'s security-hardened base with optimized configuration for production deployments.')
        
        generator.add_custom_description('redis', 
            'In-memory data structure store used as database, cache, and message broker. Enhanced with CleanStart security hardening and optimized for containerized environments.')
        
        # Set custom foundation text
        generator.set_foundation_text("Enterprise-grade, security-hardened container foundation designed for production workloads")
        
        # List of containers to generate documentation for
        containers = ['nginx', 'redis', 'postgres']
        
        logger.info(f"Generating documentation for {len(containers)} containers")
        print(f"📝 Generating documentation for {len(containers)} containers...")
        print(f"Containers: {', '.join(containers)}")
        print()
        
        # Generate documentation for multiple containers
        results = generator.generate_multiple_docs(containers)
        
        print("=" * 60)
        print("🎉 Documentation generation completed!")
        print("=" * 60)
        
        for i, (json_file, md_file) in enumerate(results, 1):
            print(f"{i}. {json_file} -> {md_file}")
        
        print(f"\n📁 Output directories:")
        print(f"   JSON files: {generator.json_dir}")
        print(f"   Markdown files: {generator.md_dir}")
        
        return 0
        
    except ValueError as e:
        logger.error(f"Configuration error: {e}")
        print(f"❌ Configuration error: {e}")
        return 1
    except Exception as e:
        logger.error(f"Error during documentation generation: {e}")
        print(f"❌ Error during documentation generation: {e}")
        return 1


if __name__ == "__main__":
    sys.exit(main())
