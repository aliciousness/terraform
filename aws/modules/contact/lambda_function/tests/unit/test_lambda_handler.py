import pytest
from unittest.mock import patch, MagicMock
import json
import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(__file__))))
from lambda_function import lambda_handler

class TestLambdaHandler:
    
    def test_missing_body(self, cors_headers):
        response = lambda_handler({'body': None}, None)
        assert response['statusCode'] == 400
        assert response['headers'] == cors_headers
        assert json.loads(response['body']) == {'error': 'No body in request'}

    def test_invalid_json(self, cors_headers):
        response = lambda_handler({'body': 'invalid json'}, None)
        assert response['statusCode'] == 400
        assert json.loads(response['body']) == {'error': 'Invalid JSON in request body'}

    @pytest.mark.parametrize("missing_field", ['email', 'name', 'message'])
    def test_missing_required_fields(self, missing_field, cors_headers):
        data = {
            'email': 'test@example.com',
            'name': 'Test User',
            'message': 'Test message'
        }
        del data[missing_field]
        event = {'body': json.dumps(data)}
        
        response = lambda_handler(event, None)
        assert response['statusCode'] == 400
        assert f'Missing required field: {missing_field}' in json.loads(response['body'])['error']

    @patch('requests.post')
    @patch('lambda_function.get_parameter')
    def test_successful_message(self, mock_get_parameter, mock_post, valid_event, cors_headers, mock_env):
        mock_get_parameter.side_effect = ['test_token', 'test_chat_id']
        mock_post.return_value.raise_for_status.return_value = None
        
        response = lambda_handler(valid_event, None)
        
        assert response['statusCode'] == 200
        assert response['headers'] == cors_headers
        assert json.loads(response['body']) == {'message': 'Message sent successfully!'}
