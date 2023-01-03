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
project = os.environ['PROJECT']

def getDiffrenceInPercent(current, previous, periodArg):
    dif = round((current - previous) / previous * 100, 2)
    periodArg = "week" if (periodArg == 7) else "month"
    result = f"Up *{dif}%* over last {periodArg}" if (dif > 0.0) else f"Down *{-dif}%* over last {periodArg}"
    return result

def getCostAndUsage(previous, period):
    now = datetime.now()

    if (period == 30):
        if (previous):
            # Check if previous year
            if (now.month - 1 == 0):
                start_date = (datetime(now.year - 1, 11, 1)).strftime('%Y-%m-%d')
                end_date = (datetime(now.year - 1, 12, 1)).strftime('%Y-%m-%d')
            elif (now.month - 1 == 1):
                start_date = (datetime(now.year - 1, 12, 1)).strftime('%Y-%m-%d')
                end_date = (datetime(now.year, now.month - 1, 1)).strftime('%Y-%m-%d')
            else:
                start_date = (datetime(now.year, now.month - 2, 1)).strftime('%Y-%m-%d')
                end_date = (datetime(now.year, now.month - 1, 1)).strftime('%Y-%m-%d')
        else:
            if (now.month - 1 == 0): start_date = (datetime(now.year - 1, 12, 1)).strftime('%Y-%m-%d')
            else: start_date = (datetime(now.year, now.month - 1, 1)).strftime('%Y-%m-%d')
            end_date = (now).strftime('%Y-%m-%d')
    else: 
        if (previous):
            start_date = (now - timedelta(days=14)).strftime('%Y-%m-%d')
            end_date = (now - timedelta(days=7)).strftime('%Y-%m-%d')
        else:
            start_date = (now - timedelta(days=7)).strftime('%Y-%m-%d')
            end_date = (now).strftime('%Y-%m-%d')  
    cost = client.get_cost_and_usage(
        TimePeriod = {'Start': start_date, 'End': end_date}, 
        Granularity = 'MONTHLY',
        Metrics = ['UnblendedCost'])

    return round(float(cost['ResultsByTime'][0]['Total']['UnblendedCost']['Amount']), 2)

def createPayload(periodArg, slackChannel, currentCost, previousCost):
    periodArg = "week" if (periodArg == 7) else "month"

    value = f"Total cost over this {periodArg} - *${currentCost}*\nTotal cost over last {periodArg} - *${previousCost}*\n{getDiffrenceInPercent(currentCost, previousCost, period)}"

    payload = {
        "channel": slackChannel,
        "attachments": [
            {
                "mrkdwn_in": ["text"],
                "color": "#00FF00",
                "fields": [
                    {
                        "title": "AWS Costs",
                        "value": value,
                        "short": False
                    },
                    {
                        "title": "Project",
                        "value": project,
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
    print(currentCost, previousCost, payload)
    sendNotificationToSlack(payload, slack_endpoint)
