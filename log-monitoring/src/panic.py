class Panic:
    def __init__(self, logEvent: str, environment: str, slackChannel: str, slackEndpoint: str):
        self.error = logEvent
        self.environment = environment
        self.slackChannel = slackChannel
        self.slackEndpoint = slackEndpoint
    
    def GetSlackEndpoint(self):
        return self.slackEndpoint

def GetPanicMessage(self: Panic):
    payload = {
        "channel": self.slackChannel,
        "attachments": [
            {
                "mrkdwn_in": ["text"],
                "color": "#FF00",
                "text": "Panic",
                "fields": [
                    {
                        "title": "Details",
                        "value": self.error,
                        "short": False
                    },
                ]
            }
        ]
    }   
    obj = {"title": "Environment", "value": self.environment, "short": False}
    payload["attachments"][0]['fields'].append(obj)

    return payload

Panic.GetMessage = GetPanicMessage