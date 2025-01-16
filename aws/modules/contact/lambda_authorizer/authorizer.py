import json
import jwt
import os
import boto3

ssm = boto3.client('ssm')

def get_parameter(name):
    response = ssm.get_parameter(Name=name, WithDecryption=True)
    return response['Parameter']['Value']

def lambda_handler(event, context):
    # Get the token from the Authorization header
    token = event.get('authorizationToken', '')
    
    # Extract headers from the event
    method_arn = event['methodArn']
    
    try:
        # Retrieve secrets from Parameter Store
        custom_header_value = get_parameter(f"/{os.environ['APPLICATION_NAME']}/custom-header")
        api_key = get_parameter(f"/{os.environ['APPLICATION_NAME']}/api-key")
        
        # Basic validation of required headers
        if not token:
            print("No authorization token provided")
            return generate_policy('user', 'Deny', method_arn)
        
        # You might want to implement your own token validation logic here
        # For now, we'll do a simple check
        if token and token.startswith('Bearer '):
            # Allow the request
            return generate_policy('user', 'Allow', method_arn)
        
        print("Invalid token format")
        return generate_policy('user', 'Deny', method_arn)
        
    except Exception as e:
        print(f"Error in authentication: {str(e)}")
        return generate_policy('user', 'Deny', method_arn)

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
