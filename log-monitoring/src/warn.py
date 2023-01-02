from parse import ParseData

class Warn:
    def __init__(self, logEvents: list, environment: str, slackChannel: str, slackEndpoint: str):
        data = ParseData(logEvents)
        self.message = data['message']
        self.requestID = data['RequestID']
        self.name = data['name']
        self.environment = environment
        self.slackChannel = slackChannel
        self.slackEndpoint = slackEndpoint

    def GetSlackEndpoint(self):
        return self.slackEndpoint

def GetWarnMessage(self: Warn):
    payload = {
        "channel": self.slackChannel,
        "attachments": [
            {
                "mrkdwn_in": ["text"],
                "color": "#FFFF00",
                "text": self.name,
                "fields": [
                    {
                        "title": "Details",
                        "value": self.message,
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

Warn.GetMessage = GetWarnMessage
