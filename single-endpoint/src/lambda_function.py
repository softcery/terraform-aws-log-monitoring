import requests
import os
import boto3
import botocore.errorfactory
from botocore.exceptions import ParamValidationError, ClientError
import base64
import hmac
import hashlib
import json

URL = os.environ['URL']
SECRET = os.environ['SECRET']
INTERVAL = os.environ['INTERVAL']

def lambda_handler(event, context):
    headers = {'Content-Length': '0',}
    params = {'secret': SECRET, 'interval': INTERVAL}
    r = (requests.put(URL, headers=headers, timeout=15, params=params)).status_code
    print(r)
    if (r != 200):
        print(f'[ERROR]: PUT request returned {r}')        
    return 0

lambda_handler(0, 0)