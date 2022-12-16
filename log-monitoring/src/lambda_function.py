import gzip, json, base64, os
from error import Error
from warn import Warn
from panic import Panic
from slack import *

ERROR_CHANNEL = os.environ['ERROR_CHANNEL']
ERROR_ENDPOINT = os.environ['ERROR_ENDPOINT']
WARN_CHANNEL = os.environ['WARN_CHANNEL']
WARN_ENDPOINT = os.environ['WARN_ENDPOINT']
ENVIRONMENT = os.environ['ENVIRONMENT']


def lambda_handler(event, context):
    cw_data = event['awslogs']['data']
    compressed_payload = base64.b64decode(cw_data)
    uncompressed_payload = gzip.decompress(compressed_payload)
    payload = json.loads(uncompressed_payload)
    log_events = payload['logEvents']
    messageObject = 0
    print(log_events) # for debug purposes
    if ((log_events[0]['message'])[0:5] == "panic"):
        messageObject = Panic(log_events[0], ENVIRONMENT, ERROR_CHANNEL, ERROR_ENDPOINT)
    else:
        logEvent = json.loads(log_events[0]['message'])
        if (logEvent['severity'] == 'ERROR'):
            messageObject = Error(log_events, ENVIRONMENT, ERROR_CHANNEL, ERROR_ENDPOINT)
        elif (logEvent['severity'] == 'WARN'):
            messageObject = Warn(log_events, ENVIRONMENT, WARN_CHANNEL, WARN_ENDPOINT)
    sendNotificationToSlack(messageObject.GetMessage(), messageObject.GetSlackEndpoint())
