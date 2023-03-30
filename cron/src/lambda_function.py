import requests
import os
import boto3
import botocore.errorfactory
from botocore.exceptions import ParamValidationError, ClientError
import base64
import hmac
import hashlib
import json

SECRET_NAME = os.environ['SECRET_NAME']
URL = os.environ['URL']

def get_secret():

    # Create a Secrets Manager client
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name='us-east-2'
    )

    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=SECRET_NAME
        )
    except ClientError as e:
        raise e
    
    secret = json.loads(get_secret_value_response['SecretString'])
    params = {
        'USERNAME': secret['USERNAME'],
        'PASSWORD': secret['PASSWORD'],
        'APP_CLIENT_ID': secret['APP_CLIENT_ID'],
        'APP_CLIENT_SECRET': secret['APP_CLIENT_SECRET']
    }
    return params

def calculateSecretHash(params: dict):
    message = bytes(params['USERNAME'] + params['APP_CLIENT_ID'], 'utf-8')
    key = bytes(params['APP_CLIENT_SECRET'], 'utf-8')
    return base64.b64encode(hmac.new(key, message, digestmod=hashlib.sha256).digest()).decode()


params = get_secret()
secret_hash = calculateSecretHash(params)

client = boto3.client('cognito-idp', "us-east-2")

# Set up the authentication parameters
auth_data = {
    'USERNAME': params['USERNAME'],
    'PASSWORD': params['PASSWORD'],
    'SECRET_HASH': secret_hash
}

try:
    # Initiate the authentication request
    response = client.initiate_auth(AuthFlow="USER_PASSWORD_AUTH", ClientId= params['APP_CLIENT_ID'], AuthParameters = auth_data)
    access_token = response['AuthenticationResult']['AccessToken']

except botocore.exceptions.ParamValidationError as e:
    print("Parameter validation error", e)

except Exception as e:
    print(e)

def lambda_handler(event, context):
    headers = {
        'Content-Length': '0',
        "Authorization": f'Bearer {access_token}' }
    r = (requests.put(URL, headers=headers, timeout=5)).status_code
    print(r)
    if (r != 200):
        print(f'[ERROR]: PUT request returned {r}')        
    return 0

lambda_handler(0, 0)