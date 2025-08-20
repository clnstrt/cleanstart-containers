#!/usr/bin/env python3
"""
Configuration management for the Container Documentation Generator
"""

import json
import os
from pathlib import Path
from typing import Dict, Any, Optional


class Config:
    """Configuration management class for the Container Documentation Generator."""
    
    def __init__(self, config_file: Optional[str] = None):
        """
        Initialize configuration.
        
        Args:
            config_file: Path to configuration file (optional)
        """
        self.config_file = config_file
        self.config = self._load_config()
    
    def _load_config(self) -> Dict[str, Any]:
        """Load configuration from file or use defaults."""
        default_config = {
            'api_config': {
                'model': 'claude-3-5-sonnet-20241022',
                'max_tokens': 4096,
                'temperature': 0.1,
                'timeout': 30
            },
            'output_config': {
                'default_output_dir': 'responses',
                'json_dir': 'responses/json',
                'markdown_dir': 'responses/markdown',
                'timestamp_format': 'unix_milliseconds'
            },
            'registry_config': {
                'default_registry': 'cleanstart',
                'registry_url': 'us-central1-docker.pkg.dev/ct2-dev-build/ct2-image-repo-dev-build'
            },
            'custom_descriptions': {
                'nginx': 'High-performance web server and reverse proxy with CleanStart security hardening',
                'redis': 'In-memory data structure store with enterprise security features',
                'postgres': 'Advanced open source database with enhanced security and performance'
            },
            'foundation_text': 'Security-hardened, minimal base OS designed for enterprise containerized environments',
            'system_prompt': (
                'You are a senior technical documentation specialist for containerized applications '
                'with expertise in security and enterprise deployments. Generate comprehensive, '
                'production-ready documentation that matches enterprise standards.'
            )
        }
        
        if self.config_file and Path(self.config_file).exists():
            try:
                with open(self.config_file, 'r', encoding='utf-8') as f:
                    file_config = json.load(f)
                # Merge file config with defaults
                return self._merge_configs(default_config, file_config)
            except (json.JSONDecodeError, IOError) as e:
                print(f"Warning: Could not load config file {self.config_file}: {e}")
                print("Using default configuration.")
        
        return default_config
    
    def _merge_configs(self, default: Dict[str, Any], custom: Dict[str, Any]) -> Dict[str, Any]:
        """Merge custom configuration with defaults."""
        result = default.copy()
        
        for key, value in custom.items():
            if key in result and isinstance(result[key], dict) and isinstance(value, dict):
                result[key] = self._merge_configs(result[key], value)
            else:
                result[key] = value
        
        return result
    
    def get(self, key: str, default: Any = None) -> Any:
        """
        Get configuration value by key.
        
        Args:
            key: Configuration key (supports dot notation like 'api_config.model')
            default: Default value if key not found
            
        Returns:
            Configuration value
        """
        keys = key.split('.')
        value = self.config
        
        try:
            for k in keys:
                value = value[k]
            return value
        except (KeyError, TypeError):
            return default
    
    def get_api_config(self) -> Dict[str, Any]:
        """Get API configuration."""
        return self.config.get('api_config', {})
    
    def get_output_config(self) -> Dict[str, Any]:
        """Get output configuration."""
        return self.config.get('output_config', {})
    
    def get_registry_config(self) -> Dict[str, Any]:
        """Get registry configuration."""
        return self.config.get('registry_config', {})
    
    def get_custom_descriptions(self) -> Dict[str, str]:
        """Get custom descriptions."""
        return self.config.get('custom_descriptions', {})
    
    def get_foundation_text(self) -> str:
        """Get foundation text."""
        return self.config.get('foundation_text', '')
    
    def get_system_prompt(self) -> str:
        """Get system prompt."""
        return self.config.get('system_prompt', '')
    
    def save_config(self, output_file: str) -> None:
        """
        Save current configuration to file.
        
        Args:
            output_file: Path to output file
        """
        try:
            with open(output_file, 'w', encoding='utf-8') as f:
                json.dump(self.config, f, indent=2, ensure_ascii=False)
            print(f"Configuration saved to {output_file}")
        except IOError as e:
            print(f"Error saving configuration: {e}")
    
    def update(self, key: str, value: Any) -> None:
        """
        Update configuration value.
        
        Args:
            key: Configuration key (supports dot notation)
            value: New value
        """
        keys = key.split('.')
        config = self.config
        
        # Navigate to the parent of the target key
        for k in keys[:-1]:
            if k not in config:
                config[k] = {}
            config = config[k]
        
        # Set the value
        config[keys[-1]] = value


def load_config(config_file: Optional[str] = None) -> Config:
    """
    Load configuration from file or use defaults.
    
    Args:
        config_file: Path to configuration file (optional)
        
    Returns:
        Config instance
    """
    return Config(config_file)


def create_default_config(output_file: str = 'config.json') -> None:
    """
    Create a default configuration file.
    
    Args:
        output_file: Path to output file
    """
    config = Config()
    config.save_config(output_file)
    print(f"Default configuration created: {output_file}")


if __name__ == "__main__":
    # Example usage
    config = load_config()
    print("API Model:", config.get('api_config.model'))
    print("Default Registry:", config.get('registry_config.default_registry'))
    
    # Create default config file
    create_default_config('config.example.json')
