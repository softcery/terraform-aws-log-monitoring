import requests, json, sys

def sendNotificationToSlack(payload, url):
    jsonPayload = json.dumps(payload)
    print(jsonPayload)
    byte_length = str(sys.getsizeof(payload))
    headers = {'Content-Type': "application/json", 'Content-Length': byte_length}
    response = requests.post(url, data=jsonPayload, headers=headers)
    if response.status_code != 200:
        print(f"[ERROR]: Failed to send notification to Slack - status code {response.status_code}")