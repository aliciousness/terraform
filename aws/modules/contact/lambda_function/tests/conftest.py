import pytest
import json
import os

@pytest.fixture
def valid_event():
    return {
        'body': json.dumps({
            'email': 'test@example.com',
            'name': 'Test User',
            'message': 'Test message'
        })
    }

@pytest.fixture
def cors_headers():
    return {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'OPTIONS,POST',
        'Content-Type': 'application/json'
    }

@pytest.fixture
def mock_env():
    os.environ['APPLICATION_NAME'] = 'test'
    yield
    del os.environ['APPLICATION_NAME']
