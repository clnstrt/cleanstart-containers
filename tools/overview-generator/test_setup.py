#!/usr/bin/env python3
"""
Test script to verify the Container Documentation Generator setup
This script checks if all dependencies are installed and the tool is ready to use.
"""

import sys
import importlib
import logging
from pathlib import Path

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


def test_imports() -> bool:
    """Test if all required modules can be imported."""
    print("🔍 Testing imports...")
    
    required_modules = [
        'requests',
        'dotenv',
        'json',
        'argparse',
        'datetime',
        'pathlib'
    ]
    
    failed_imports = []
    
    for module in required_modules:
        try:
            importlib.import_module(module)
            print(f"  ✅ {module}")
        except ImportError as e:
            print(f"  ❌ {module}: {e}")
            failed_imports.append(module)
    
    if failed_imports:
        print(f"\n❌ Failed to import: {', '.join(failed_imports)}")
        print("Please install missing dependencies:")
        print("pip install -r requirements.txt")
        return False
    
    print("✅ All imports successful!")
    return True


def test_local_imports() -> bool:
    """Test if local modules can be imported."""
    print("\n🔍 Testing local imports...")
    
    try:
        from generate import ContainerDocsGenerator
        print("  ✅ ContainerDocsGenerator class imported successfully")
        return True
    except ImportError as e:
        print(f"  ❌ Failed to import ContainerDocsGenerator: {e}")
        return False


def test_environment() -> bool:
    """Test environment setup."""
    print("\n🔍 Testing environment...")
    
    # Check Python version
    python_version = sys.version_info
    print(f"  Python version: {python_version.major}.{python_version.minor}.{python_version.micro}")
    
    if python_version < (3, 7):
        print("  ⚠️  Warning: Python 3.7+ recommended")
    else:
        print("  ✅ Python version is compatible")
    
    # Check if .env file exists
    env_file = Path('.env')
    if env_file.exists():
        print("  ✅ .env file found")
    else:
        print("  ⚠️  .env file not found (you'll need to set GROK_API_KEY)")
    
    # Check if GROK_API_KEY is set
    import os
    if os.getenv('GROK_API_KEY'):
        print("  ✅ GROK_API_KEY environment variable is set")
    else:
        print("  ⚠️  GROK_API_KEY environment variable not set")
    
    return True


def test_directory_structure() -> bool:
    """Test if required directories exist or can be created."""
    print("\n🔍 Testing directory structure...")
    
    test_dirs = ['responses', 'responses/json', 'responses/markdown']
    
    for dir_path in test_dirs:
        path = Path(dir_path)
        if path.exists():
            print(f"  ✅ {dir_path} exists")
        else:
            try:
                path.mkdir(parents=True, exist_ok=True)
                print(f"  ✅ {dir_path} created")
            except Exception as e:
                print(f"  ❌ Failed to create {dir_path}: {e}")
                return False
    
    return True


def test_api_connectivity() -> bool:
    """Test basic API connectivity (without making actual calls)."""
    print("\n🔍 Testing API connectivity...")
    
    try:
        import requests
        # Test basic connectivity to Anthropic API endpoint
        response = requests.head('https://api.anthropic.com', timeout=5)
        print("  ✅ API endpoint is reachable")
        return True
    except Exception as e:
        print(f"  ⚠️  API connectivity test failed: {e}")
        print("  This might be due to network issues or firewall restrictions")
        return True  # Don't fail the test for network issues


def test_file_permissions() -> bool:
    """Test if we can write to the output directories."""
    print("\n🔍 Testing file permissions...")
    
    try:
        test_file = Path('responses/test_write.tmp')
        test_file.write_text('test')
        test_file.unlink()  # Clean up
        print("  ✅ Write permissions OK")
        return True
    except Exception as e:
        print(f"  ❌ Write permission test failed: {e}")
        return False


def main():
    """Run all tests."""
    print("🧪 Container Documentation Generator - Setup Test")
    print("=" * 50)
    
    tests = [
        test_imports,
        test_local_imports,
        test_environment,
        test_directory_structure,
        test_api_connectivity,
        test_file_permissions
    ]
    
    all_passed = True
    
    for test in tests:
        if not test():
            all_passed = False
    
    print("\n" + "=" * 50)
    if all_passed:
        print("🎉 All tests passed! The tool is ready to use.")
        print("\nNext steps:")
        print("1. Set your GROK_API_KEY environment variable")
        print("2. Run: python generate.py nginx")
        print("3. Or run: python example.py")
        return 0
    else:
        print("❌ Some tests failed. Please fix the issues above.")
        return 1


if __name__ == "__main__":
    sys.exit(main())
