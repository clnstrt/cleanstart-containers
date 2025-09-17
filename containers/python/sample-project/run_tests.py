#!/usr/bin/env python3
"""
Test runner for the Flask User Management Application
Simple script to run all tests with proper configuration.
"""

import sys
import subprocess
import os


def run_tests():
    """Run the test suite."""
    print("🧪 Running Flask User Management Application Tests")
    print("=" * 50)
    
    # Check if pytest is available
    try:
        import pytest
    except ImportError:
        print("❌ pytest is not installed. Installing...")
        subprocess.check_call([sys.executable, "-m", "pip", "install", "pytest"])
        import pytest
    
    # Run tests
    test_args = [
        "test_app.py",
        "-v",
        "--tb=short",
        "--color=yes"
    ]
    
    try:
        result = pytest.main(test_args)
        if result == 0:
            print("\n✅ All tests passed!")
        else:
            print(f"\n❌ {result} test(s) failed!")
        return result
    except Exception as e:
        print(f"❌ Error running tests: {e}")
        return 1


def run_specific_test(test_name):
    """Run a specific test."""
    print(f"🧪 Running specific test: {test_name}")
    print("=" * 50)
    
    test_args = [
        f"test_app.py::{test_name}",
        "-v",
        "--tb=short",
        "--color=yes"
    ]
    
    try:
        result = pytest.main(test_args)
        return result
    except Exception as e:
        print(f"❌ Error running test: {e}")
        return 1


if __name__ == "__main__":
    if len(sys.argv) > 1:
        # Run specific test
        test_name = sys.argv[1]
        exit_code = run_specific_test(test_name)
    else:
        # Run all tests
        exit_code = run_tests()
    
    sys.exit(exit_code)
