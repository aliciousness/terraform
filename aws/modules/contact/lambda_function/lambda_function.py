import json
import boto3
import os
import logging
import requests
from requests.exceptions import RequestException

# Initialize the SSM client
ssm = boto3.client('ssm')

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def get_parameter(name):
    try:
        response = ssm.get_parameter(Name=name, WithDecryption=True)
        return response['Parameter']['Value']
    except Exception as e:
        logger.error(f"Error getting parameter {name}: {str(e)}")
        raise

def lambda_handler(event, context):
    # Set CORS headers
    headers = {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'OPTIONS,POST',
        'Content-Type': 'application/json'
    }
    
    try:
        logger.info("Processing new request")
        logger.info(f"Event: {json.dumps(event)}")
        
        # Retrieve secrets from Parameter Store
        telegram_bot_token = get_parameter(f"/{os.environ['APPLICATION_NAME']}/telegram-bot-token")
        telegram_chat_id = get_parameter(f"/{os.environ['APPLICATION_NAME']}/telegram-chat-id")
        
        # Parse the incoming event
        if not event.get('body'):
            return {
                'statusCode': 400,
                'headers': headers,
                'body': json.dumps({'error': 'No body in request'})
            }

        try:
            body = json.loads(event['body']) if isinstance(event['body'], str) else event['body']
        except json.JSONDecodeError as e:
            logger.error(f"Error parsing request body: {str(e)}")
            return {
                'statusCode': 400,
                'headers': headers,
                'body': json.dumps({'error': 'Invalid JSON in request body'})
            }

        # Validate required fields
        required_fields = ['email', 'name', 'message']
        for field in required_fields:
            if not body.get(field):
                return {
                    'statusCode': 400,
                    'headers': headers,
                    'body': json.dumps({'error': f'Missing required field: {field}'})
                }
        
        # Prepare the message
        user_name = body['name']
        user_email = body['email']
        user_message = body['message']
        message = f"{user_name} Submitted a message.\nEmail: {user_email}\nMessage: {user_message}"
        logger.info("Sending message to Telegram")
        
        try:
            # Send the message to Telegram
            telegram_url = f"https://api.telegram.org/bot{telegram_bot_token}/sendMessage"
            telegram_response = requests.post(
                telegram_url,
                json={
                    'chat_id': telegram_chat_id,
                    'text': message
                },
                timeout=10  # Add timeout to the request
            )
            telegram_response.raise_for_status()
            logger.info("Message sent successfully to Telegram")
            
        except RequestException as e:
            logger.error(f"Error sending message to Telegram: {str(e)}")
            return {
                'statusCode': 500,
                'headers': headers,
                'body': json.dumps({'error': 'Failed to send message to Telegram'})
            }
        
        return {
            'statusCode': 200,
            'headers': headers,
            'body': json.dumps({'message': 'Message sent successfully!'})
        }
        
    except Exception as e:
        logger.error(f"Unexpected error: {str(e)}")
        return {
            'statusCode': 500,
            'headers': headers,
            'body': json.dumps({'error': 'Internal server error'})
        }
