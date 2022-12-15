from parse import ParseData

class Error:
    def __init__(self, logEvents: list, environment: str, slackChannel: str, slackEndpoint: str):
        data = ParseData(logEvents)
        self.error = data['error']
        self.message = data['message']
        self.requestID = data['RequestID']
        self.name = data['name']
        self.environment = environment
        self.slackChannel = slackChannel
        self.slackEndpoint = slackEndpoint
        
    def GetSlackEndpoint(self):
        return self.slackEndpoint

def GetErrorMessage(self: Error):
    payload = {
        "channel": self.slackChannel,
        "attachments": [
            {
                "mrkdwn_in": ["text"],
                "color": "#FF0000",
                "text": self.name,
                "fields": [
                    {
                        "title": "Details",
                        "value": f"{self.message} - {self.error}",
                        "short": False
                    },
                ]
            }
        ]
    }
    if self.requestID != '':
        obj = {"title": "Request ID", "value": self.requestID, "short": False}
        payload["attachments"][0]['fields'].append(obj)
        
    obj = {"title": "Environment", "value": self.environment, "short": False}
    payload["attachments"][0]['fields'].append(obj)

    return payload

Error.GetMessage = GetErrorMessage