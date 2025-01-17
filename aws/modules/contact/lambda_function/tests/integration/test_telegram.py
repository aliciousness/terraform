import pytest
import requests
from unittest.mock import patch
import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(__file__))))
from lambda_function import lambda_handler

class TestTelegramIntegration:
    
    @patch('lambda_function.get_parameter')
    def test_telegram_timeout(self, mock_get_parameter, valid_event, mock_env):
        mock_get_parameter.side_effect = ['test_token', 'test_chat_id']
        
        with patch('requests.post') as mock_post:
            mock_post.side_effect = requests.exceptions.Timeout()
            response = lambda_handler(valid_event, None)
            
            assert response['statusCode'] == 500
            assert json.loads(response['body']) == {'error': 'Failed to send message to Telegram'}

    @patch('lambda_function.get_parameter')
    def test_telegram_invalid_token(self, mock_get_parameter, valid_event, mock_env):
        mock_get_parameter.side_effect = ['invalid_token', 'test_chat_id']
        
        response = lambda_handler(valid_event, None)
        assert response['statusCode'] == 500
