import json
import boto3
import requests
import os
import sys
from datetime import datetime
from datetime import timedelta

client = boto3.client('ce')

period = int(os.environ['PERIOD'])
slack_endpoint = os.environ['SLACK_ENDPOINT']
slack_channel = os.environ['SLACK_CHANNEL']

def getDiffrenceInPercent(current, previous, period):
    dif = round((previous - current) / current * 100, 2)
    period = "week" if (period == 7) else "month"
    result = f"Up {dif}% over last {period}" if (dif > 0.0) else f"Down {-dif}% over last {period}"
    return result

def getCostAndUsage(previous, period):
    now = datetime.now()

    if (period == 30): 
        sub = 1 if (previous) else 0
        date = datetime(now.year, now.month - sub, now.day) - timedelta(days = 1)
        start_date = date.strftime('%Y-%m-01')
        end_date = date.strftime('%Y-%m-%d')
    else:
        start_date = (now - timedelta(days=period)).strftime(f'%Y-%m-%d')
        end_date = now.strftime('%Y-%m-%d')
        if (previous):
            end_date = start_date
            start_date = (now - timedelta(days = period * 2)).strftime(f'%Y-%m-%d')

    print(start_date, end_date)
    cost = client.get_cost_and_usage(
        TimePeriod = {'Start': start_date, 'End': end_date}, 
        Granularity = 'MONTHLY',
        Metrics = ['UnblendedCost'])

    return round(float(cost['ResultsByTime'][0]['Total']['UnblendedCost']['Amount']), 2)

def createPayload(period, slackChannel, currentCost, previousCost):
    period = "week" if (period == 7) else "month"

    value = f"""Total cost over this {period} - {currentCost}
    {getDiffrenceInPercent(currentCost, previousCost, period)}"""

    payload = {
        "channel": slackChannel,
        "attachments": [
            {
                "mrkdwn_in": ["text"],
                "color": "#00FF00",
                "fields": [
                    {
                        "title": "Costs",
                        "value": value,
                        "short": False
                    },
                ]
            }
        ]
    }
    return payload

def sendNotificationToSlack(payload, url):
    byte_length = str(sys.getsizeof(payload))
    headers = {'Content-Type': "application/json", 'Content-Length': byte_length}
    response = requests.post(url, data=json.dumps(payload), headers=headers)
    if response.status_code != 200:
        print(f"[ERROR]: Failed to send notification to Slack - status code {response.status_code}")

def lambda_handler(event, context):
    currentCost = getCostAndUsage(False, period)
    previousCost = getCostAndUsage(True, period)
    payload = createPayload(period, slack_channel, currentCost, previousCost)
    sendNotificationToSlack(payload, slack_endpoint)

lambda_handler(0, 0)