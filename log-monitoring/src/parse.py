import json

def ParseData(logEvents):
    firstLogEvent, lastLogEvent = json.loads(logEvents[0]['message']), json.loads(logEvents[-1]['message'])
    data = {}
    errorFirst, errorLast = ParseErrorFields(firstLogEvent), ParseErrorFields(lastLogEvent)
    if (errorFirst == errorLast):
        data['error'] = errorLast
    else:
        data['error'] = errorFirst + "; " + errorLast
    data['message'] = ParseMessage(lastLogEvent)
    data['RequestID'] = ParseRequestID(firstLogEvent)
    data['name'] = ParseName(firstLogEvent)

    return data

def ParseName(logEvent):
    return logEvent['name'] if ('name' in logEvent.keys()) else ''
    

def ParseRequestID(logEvent):
    return logEvent['RequestID'] if ('RequestID' in logEvent.keys()) else ''

def ParseErrorFields(logEvent):
    error = ""
    fields = ['err', 'resBody', 'resultError']
    for field in fields:
        error += (str(logEvent[field]) + '; ')  if (field in logEvent.keys()) else ''
    return error

def ParseMessage(logEvent):
    return logEvent['message'] if ('message' in logEvent.keys()) else ''