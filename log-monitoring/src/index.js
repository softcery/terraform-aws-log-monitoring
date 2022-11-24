const zlib = require('zlib');
const fetch = require('node-fetch');

const SLACK_ENDPOINT = process.env.SLACK_ENDPOINT;
const SLACK_CHANNEL = process.env.SLACK_CHANNEL;
const USE_LAST_INDEX = (process.env.USE_LAST_INDEX == 'true');
const ENVIRONMENT = process.env.ENVIRONMENT;
const LEVEL = process.env.LEVEL;

let color;
switch (LEVEL) {
  case 'ERROR':
    color = "#FF0000";
    break;
  case 'WARN':
    color = "#FFFF00";
    break;
  default:
    color = "#0000FF";
}

function doRequest(message) {
  const payloadStr = JSON.stringify(message);
  const requestOptions = {
    method: 'POST',
    body: payloadStr,
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Content-Length': Buffer.byteLength(payloadStr),
    }
  };

  const hostname = `https://hooks.slack.com${SLACK_ENDPOINT}`;

  fetch(hostname, requestOptions).then((response) => {
    console.log(response.status);
    if (response.status != 200) {
      let message = `Failed to send notification to Slack; ERROR: ${response.status}`;
      console.error(JSON.stringify(message));
    }
  });
}

function createMessage(logevent, name, requestId) {
  const log = JSON.parse(logevent.message);
  const message = {
    "channel": SLACK_CHANNEL,
    "attachments": [
      {
	      "mrkdwn_in": ["text"],
          "color": color,
          "text": name,
          "fields": [
            {
              "title": "Details",
              "value": `${log.message} - ${log.err}`,
              "short": false
            },
            {
              "title": "Request ID",
              "value": `${requestId}`,
              "short": false
            },
            {
              "title": "Enviornment",
              "value": `${ENVIRONMENT}`,
              "short": false
            }
          ]
      }
    ]
  }

  console.log(log)
  console.log(JSON.stringify(message));

  return message;
}

function getName(logevent) {
  const log = JSON.parse(logevent.message);
  return log.name;
}

function getRequestId(logevent) {
  const log = JSON.parse(logevent.message);
  return log.RequestID;
}

exports.handler = (event, context) => {
  if (event.awslogs && event.awslogs.data) {
    const payload = Buffer.from(event.awslogs.data, 'base64');
    const logevents = JSON.parse(zlib.unzipSync(payload).toString()).logEvents;
    
    const name = getName(logevents[0]);
    const requestId = getRequestId(logevents[0]);
    const logIndex = USE_LAST_INDEX ? (logevents.length - 1) : 0;
    const logevent = logevents[logIndex];

    const message = createMessage(logevent, name, requestId);
    doRequest(message)
  }
};
