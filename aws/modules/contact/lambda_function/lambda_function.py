import json
import logging
import os
import boto3
import requests
from requests.exceptions import RequestException

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Initialize AWS client
ssm = boto3.client("ssm")

def get_parameter(name):
    try:
        logger.info(f"Attempting to get parameter: {name}")
        response = ssm.get_parameter(Name=name, WithDecryption=True)
        logger.info(f"Successfully retrieved parameter: {name}")
        return response["Parameter"]["Value"]
    except Exception as e:
        logger.error(f"Error getting parameter {name}: {str(e)}")
        raise


def lambda_handler(event, context):
    logger.info(f"Event received: {event}")
    # Set CORS headers
    headers = {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "Content-Type",
        "Access-Control-Allow-Methods": "OPTIONS,POST",
        "Content-Type": "application/json",
    }

    # Parse the incoming event first
    if not event.get("body"):
        return {
            "statusCode": 400,
            "headers": headers,
            "body": json.dumps({"error": "No body in request"}),
        }

    try:
        body = (
            json.loads(event["body"])
            if isinstance(event["body"], str)
            else event["body"]
        )
    except json.JSONDecodeError as e:
        logger.error(f"Error parsing request body: {str(e)}")
        return {
            "statusCode": 400,
            "headers": headers,
            "body": json.dumps({"error": "Invalid JSON in request body"}),
        }

    # Validate required fields
    required_fields = ["email", "name", "message"]
    for field in required_fields:
        if not body.get(field):
            return {
                "statusCode": 400,
                "headers": headers,
                "body": json.dumps({"error": f"Missing required field: {field}"}),
            }

    try:
        logger.info("Processing new request")
        logger.info(f"Event: {json.dumps(event)}")

        # Retrieve secrets from Parameter Store
        logger.info("Retrieving Telegram bot token")
        telegram_bot_token = get_parameter(
            f"{os.environ['SSM_PREFIX']}/telegram-bot-token"
        )
        logger.info("Retrieving Telegram chat ID")
        telegram_chat_id = get_parameter(
            f"{os.environ['SSM_PREFIX']}/telegram-chat-id"
        )
        
        logger.info("Parameters retrieved successfully")
        
        # Prepare the message
        user_name = body["name"]
        user_email = body["email"]
        user_message = body["message"]
        message = f"{user_name} submitted a message.\nEmail: {user_email}\nMessage: {user_message}\nBe careful of links in the message."
        logger.info(f"Prepared message: {message}")

        try:
            # Send the message to Telegram
            telegram_url = f"https://api.telegram.org/bot{telegram_bot_token}/sendMessage"
            logger.info(f"Sending request to Telegram API: {telegram_url}")
            
            payload = {"chat_id": telegram_chat_id, "text": message}
            logger.info(f"Request payload: {json.dumps(payload)}")
            
            telegram_response = requests.post(
                telegram_url,
                json=payload,
                timeout=10,
            )
            
            logger.info(f"Telegram API response status code: {telegram_response.status_code}")
            logger.info(f"Telegram API response content: {telegram_response.text}")
            
            telegram_response.raise_for_status()
            logger.info("Message sent successfully to Telegram")

        except RequestException as e:
            logger.error(f"Error sending message to Telegram: {str(e)}")
            logger.error(f"Response content: {getattr(e.response, 'text', 'No response content')}")
            return {
                "statusCode": 500,
                "headers": headers,
                "body": json.dumps({"error": f"Failed to send message to Telegram: {str(e)}"}),
            }

        return {
            "statusCode": 200,
            "headers": headers,
            "body": json.dumps({"message": "Message sent successfully!"}),
        }

    except Exception as e:
        logger.error(f"Unexpected error: {str(e)}")
        return {
            "statusCode": 500,
            "headers": headers,
            "body": json.dumps({"error": "Internal server error"}),
        }
