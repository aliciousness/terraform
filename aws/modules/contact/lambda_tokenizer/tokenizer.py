import json
import jwt
import time
import os
import boto3

ssm = boto3.client('ssm')

def get_parameter(name):
    response = ssm.get_parameter(Name=name, WithDecryption=True)
    return response['Parameter']['Value']

def lambda_handler(event, context):
    try:
        # Get the secret key from Parameter Store
        secret_key = get_parameter(f"/{os.environ['APPLICATION_NAME']}/api-key")
        
        # Create a token that expires in 1 hour
        payload = {
            'sub': 'api-user',
            'role': 'allowed_role',
            'exp': int(time.time()) + 3600  # 1 hour from now
        }
        
        # Generate the token
        token = jwt.encode(payload, secret_key, algorithm='HS256')
        
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Content-Type,X-Api-Key',
                'Access-Control-Allow-Methods': 'POST',
            },
            'body': json.dumps({
                'token': token,
                'expires_in': 3600
            })
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'headers': {
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({'error': str(e)})
        }
