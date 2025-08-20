#!/usr/bin/env python3
"""
Unit tests for the Container Documentation Generator
"""

import unittest
import tempfile
import os
import json
from pathlib import Path
from unittest.mock import patch, MagicMock
from generate import ContainerDocsGenerator


class TestContainerDocsGenerator(unittest.TestCase):
    """Test cases for ContainerDocsGenerator class."""

    def setUp(self):
        """Set up test environment."""
        # Create temporary directory for tests
        self.temp_dir = tempfile.mkdtemp()
        self.test_output_dir = Path(self.temp_dir) / 'test_output'
        
        # Mock API key for testing
        self.patcher = patch.dict(os.environ, {'GROK_API_KEY': 'test_api_key'})
        self.patcher.start()

    def tearDown(self):
        """Clean up test environment."""
        self.patcher.stop()
        # Clean up temporary directory
        import shutil
        shutil.rmtree(self.temp_dir, ignore_errors=True)

    def test_init_with_defaults(self):
        """Test initialization with default parameters."""
        generator = ContainerDocsGenerator()
        self.assertEqual(generator.registry_url, "cleanstart")
        self.assertEqual(generator.api_key, "test_api_key")
        self.assertTrue(generator.output_dir.exists())

    def test_init_with_custom_output_dir(self):
        """Test initialization with custom output directory."""
        generator = ContainerDocsGenerator(output_dir=str(self.test_output_dir))
        self.assertEqual(generator.output_dir, self.test_output_dir)
        self.assertTrue(generator.output_dir.exists())

    def test_init_without_api_key(self):
        """Test initialization without API key should raise ValueError."""
        with patch.dict(os.environ, {}, clear=True):
            with self.assertRaises(ValueError):
                ContainerDocsGenerator()

    def test_add_custom_description(self):
        """Test adding custom descriptions."""
        generator = ContainerDocsGenerator()
        generator.add_custom_description('nginx', 'Test description')
        self.assertEqual(generator.get_image_description('nginx'), 'Test description')
        self.assertEqual(generator.get_image_description('NGINX'), 'Test description')  # Case insensitive

    def test_set_foundation_text(self):
        """Test setting foundation text."""
        generator = ContainerDocsGenerator()
        test_text = "Custom foundation text"
        generator.set_foundation_text(test_text)
        self.assertEqual(generator.cleanstart_foundation_text, test_text)

    def test_get_image_description_unknown(self):
        """Test getting description for unknown image."""
        generator = ContainerDocsGenerator()
        self.assertEqual(generator.get_image_description('unknown'), "")

    def test_generate_json_prompt(self):
        """Test JSON prompt generation."""
        generator = ContainerDocsGenerator()
        prompt = generator.generate_json_prompt('nginx')
        
        # Check that prompt contains expected elements
        self.assertIn('nginx', prompt)
        self.assertIn('"image_name": "nginx"', prompt)
        self.assertIn('CleanStart nginx Container', prompt)

    def test_generate_json_prompt_with_custom_description(self):
        """Test JSON prompt generation with custom description."""
        generator = ContainerDocsGenerator()
        generator.add_custom_description('nginx', 'Custom nginx description')
        prompt = generator.generate_json_prompt('nginx')
        
        self.assertIn('Custom nginx description', prompt)

    def test_save_json_response_valid(self):
        """Test saving valid JSON response."""
        generator = ContainerDocsGenerator(output_dir=str(self.test_output_dir))
        
        test_json = '{"test": "data", "image_name": "nginx"}'
        filename, data = generator.save_json_response(test_json, 'nginx')
        
        self.assertIsInstance(filename, str)
        self.assertIsInstance(data, dict)
        self.assertEqual(data['test'], 'data')
        self.assertEqual(data['image_name'], 'nginx')
        
        # Check file was created
        file_path = generator.json_dir / filename
        self.assertTrue(file_path.exists())

    def test_save_json_response_invalid(self):
        """Test saving invalid JSON response."""
        generator = ContainerDocsGenerator(output_dir=str(self.test_output_dir))
        
        invalid_json = '{"invalid": json}'
        with self.assertRaises(ValueError):
            generator.save_json_response(invalid_json, 'nginx')

    def test_save_markdown_response(self):
        """Test saving markdown response."""
        generator = ContainerDocsGenerator(output_dir=str(self.test_output_dir))
        
        test_content = "# Test Markdown\n\nThis is test content."
        filename = generator.save_markdown_response(test_content, 'nginx')
        
        self.assertIsInstance(filename, str)
        
        # Check file was created
        file_path = generator.md_dir / filename
        self.assertTrue(file_path.exists())
        
        # Check content was saved correctly
        with open(file_path, 'r', encoding='utf-8') as f:
            saved_content = f.read()
        self.assertEqual(saved_content.strip(), test_content.strip())

    def test_generate_markdown_from_json(self):
        """Test markdown generation from JSON data."""
        generator = ContainerDocsGenerator()
        
        test_json = {
            'image_name': 'nginx',
            'title': 'Test Container',
            'container_image': 'test/nginx',
            'license': 'MIT',
            'architecture': ['AMD64'],
            'registry': 'test.registry.com',
            'overview': {
                'description': 'Test description',
                'cleanstart_foundation': 'Test foundation',
                'key_features': ['Feature 1', 'Feature 2']
            },
            'common_use_cases': ['Use case 1'],
            'quick_start': {
                'basic_production': {
                    'title': 'Production',
                    'description': 'Production setup',
                    'commands': ['docker run test/nginx']
                },
                'development': {
                    'title': 'Development',
                    'description': 'Development setup',
                    'commands': ['docker run -it test/nginx']
                }
            },
            'docker_compose': {
                'version': '3.8',
                'services': {
                    'nginx': {
                        'image': 'test/nginx:latest',
                        'ports': ['80:80']
                    }
                }
            },
            'configuration': {
                'environment_variables': [
                    {'variable': 'TEST_VAR', 'default': 'test', 'description': 'Test variable'}
                ],
                'command_arguments': {
                    'description': 'Test args',
                    'example': 'docker run test/nginx',
                    'common_flags': ['--test']
                }
            },
            'security': {
                'security_context': {
                    'runAsNonRoot': True,
                    'runAsUser': 1000,
                    'runAsGroup': 1000,
                    'readOnlyRootFilesystem': True,
                    'allowPrivilegeEscalation': False,
                    'capabilities': {
                        'drop': ['ALL'],
                        'add': []
                    }
                },
                'best_practices': ['Practice 1']
            },
            'health_monitoring': {
                'api_endpoints': [
                    {'endpoint': '/health', 'description': 'Health check', 'example': 'curl /health'}
                ],
                'container_management': [
                    {'action': 'Check status', 'command': 'docker ps'}
                ]
            },
            'architecture_support': {
                'description': 'Multi-platform',
                'commands': ['docker pull test/nginx']
            },
            'resources': {
                'essential_links': [
                    {'title': 'Docs', 'url': 'https://docs.test'}
                ],
                'advanced_usage': ['Advanced 1']
            },
            'support': {
                'issues': 'GitHub',
                'community': 'Discord',
                'enterprise': 'Email'
            },
            'footer': {
                'organization': 'Test Org',
                'updated': 'December 2024',
                'version': '1.0'
            }
        }
        
        markdown = generator.generate_markdown_from_json(test_json)
        
        # Check that markdown contains expected elements
        self.assertIn('Test Container', markdown)
        self.assertIn('nginx', markdown)
        self.assertIn('Test description', markdown)
        self.assertIn('docker run test/nginx', markdown)

    @patch('generate.requests.post')
    def test_call_claude_api_success(self, mock_post):
        """Test successful API call."""
        generator = ContainerDocsGenerator()
        
        # Mock successful response
        mock_response = MagicMock()
        mock_response.json.return_value = {
            'content': [{'text': '{"test": "response"}'}]
        }
        mock_response.raise_for_status.return_value = None
        mock_post.return_value = mock_response
        
        result = generator.call_claude_api('test prompt')
        self.assertEqual(result, '{"test": "response"}')

    @patch('generate.requests.post')
    def test_call_claude_api_failure(self, mock_post):
        """Test API call failure."""
        generator = ContainerDocsGenerator()
        
        # Mock failed response
        mock_post.side_effect = Exception('API Error')
        
        with self.assertRaises(RuntimeError):
            generator.call_claude_api('test prompt')

    @patch('generate.requests.post')
    def test_call_claude_api_invalid_response(self, mock_post):
        """Test API call with invalid response format."""
        generator = ContainerDocsGenerator()
        
        # Mock response with invalid format
        mock_response = MagicMock()
        mock_response.json.return_value = {'invalid': 'format'}
        mock_response.raise_for_status.return_value = None
        mock_post.return_value = mock_response
        
        with self.assertRaises(RuntimeError):
            generator.call_claude_api('test prompt')

    def test_generate_multiple_docs_empty_list(self):
        """Test generating docs for empty list."""
        generator = ContainerDocsGenerator(output_dir=str(self.test_output_dir))
        results = generator.generate_multiple_docs([])
        self.assertEqual(results, [])

    @patch.object(ContainerDocsGenerator, 'generate_docs')
    def test_generate_multiple_docs_success(self, mock_generate_docs):
        """Test generating docs for multiple images."""
        generator = ContainerDocsGenerator(output_dir=str(self.test_output_dir))
        
        # Mock successful doc generation
        mock_generate_docs.return_value = ('test.json', 'test.md')
        
        results = generator.generate_multiple_docs(['nginx', 'redis'])
        self.assertEqual(len(results), 2)
        self.assertEqual(results[0], ('test.json', 'test.md'))
        self.assertEqual(results[1], ('test.json', 'test.md'))

    @patch.object(ContainerDocsGenerator, 'generate_docs')
    def test_generate_multiple_docs_partial_failure(self, mock_generate_docs):
        """Test generating docs with partial failures."""
        generator = ContainerDocsGenerator(output_dir=str(self.test_output_dir))
        
        # Mock one success, one failure
        def mock_generate(image, system_prompt=None):
            if image == 'nginx':
                return ('nginx.json', 'nginx.md')
            else:
                raise Exception('Generation failed')
        
        mock_generate_docs.side_effect = mock_generate
        
        results = generator.generate_multiple_docs(['nginx', 'redis'])
        # Should continue processing and return successful results
        self.assertEqual(len(results), 1)
        self.assertEqual(results[0], ('nginx.json', 'nginx.md'))


if __name__ == '__main__':
    unittest.main()
