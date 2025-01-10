import json
import jwt
import os
import boto3

ssm = boto3.client('ssm')

def get_parameter(name):
    response = ssm.get_parameter(Name=name, WithDecryption=True)
    return response['Parameter']['Value']

def lambda_handler(event, context):
    token = event['authorizationToken']
    headers = event['headers']
    
    try:
        # Retrieve secrets from Parameter Store
        custom_header_value = get_parameter(f"/{os.environ['APPLICATION_NAME']}/custom-header")
        secret_key = get_parameter(f"/{os.environ['APPLICATION_NAME']}/api-key")
        
        # Check for custom header
        if headers.get('X-Custom-Header') != custom_header_value:
            return generate_policy('user', 'Deny', event['methodArn'])
        
        # Decode and verify the JWT token
        decoded_token = jwt.decode(token, secret_key, algorithms=['HS256'])
        
        # Implement your authorization logic here
        if decoded_token['role'] == 'allowed_role':
            return generate_policy(decoded_token['sub'], 'Allow', event['methodArn'])
        else:
            return generate_policy(decoded_token['sub'], 'Deny', event['methodArn'])
    except jwt.ExpiredSignatureError:
        return generate_policy('user', 'Deny', event['methodArn'])
    except jwt.InvalidTokenError:
        return generate_policy('user', 'Deny', event['methodArn'])

def generate_policy(principal_id, effect, resource):
    auth_response = {}
    auth_response['principalId'] = principal_id

    if effect and resource:
        policy_document = {}
        policy_document['Version'] = '2012-10-17'
        policy_document['Statement'] = []
        statement_one = {}
        statement_one['Action'] = 'execute-api:Invoke'
        statement_one['Effect'] = effect
        statement_one['Resource'] = resource
        policy_document['Statement'].append(statement_one)
        auth_response['policyDocument'] = policy_document

    return auth_response
