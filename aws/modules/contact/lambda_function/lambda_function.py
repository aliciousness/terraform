import json
import boto3
import os
import logging
import requests

# Initialize the SES client
ssm = boto3.client('ssm')

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def get_parameter(name):
    response = ssm.get_parameter(Name=name, WithDecryption=True)
    return response['Parameter']['Value']

def lambda_handler(event, context):
    try:
        # Retrieve secrets from Parameter Store
        telegram_bot_token = get_parameter(f"/{os.environ['APPLICATION_NAME']}/telegram-bot-token")
        telegram_chat_id = get_parameter(f"/{os.environ['APPLICATION_NAME']}/telegram-chat-id")
        
        # Parse the incoming event
        body = json.loads(event['body'])
        user_email = body['email']
        user_name = body['name']
        user_message = body['message']
        print("Body: ", body)
        
        # Log the incoming request
        logger.info(f"Received contact form submission: {body}")
        
        # Prepare the message
        message = f"{user_name} Submitted a message.\nEmail: {user_email}\nMessage: {user_message}"
        
        # Send the message to the Telegram channel
        telegram_url = f"https://api.telegram.org/bot{telegram_bot_token}/sendMessage"
        
        response = requests.post(telegram_url, data={
            'chat_id': telegram_chat_id,
            'text': message
        })
        
        # Log the Telegram response
        logger.info(f"Telegram response: {response.json()}")
        
        return {
            'statusCode': 200,
            'body': json.dumps('Message sent successfully!')
        }
    except Exception as e:
        # Log the error
        logger.error(f"Error processing contact form submission: {e}")
        
        return {
            'statusCode': 500,
            'body': json.dumps('An error occurred while processing the form submission.')
        }
