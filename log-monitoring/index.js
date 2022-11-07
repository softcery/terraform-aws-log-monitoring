const zlib = require('zlib');
const https = require('https');

const SLACK_ENDPOINT = process.env.SLACK_ENDPOINT;
const SLACK_CHANNEL = process.env.SLACK_CHANNEL

function doRequest(message) {
  const payloadStr = JSON.stringify(message);
  const options = {
    hostname: 'hooks.slack.com',
    port: 443,
    path: SLACK_ENDPOINT,
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Content-Length': Buffer.byteLength(payloadStr),
    },
  };

  const postReq = https.request(options, (res) => {
    const chunks = [];
    res.setEncoding('utf8');
    res.on('data', (chunk) => chunks.push(chunk));
    res.on('end', () => {
      if (res.statusCode < 400) {
        console.log('sent!!!');
      } else if (res.statusCode < 500) {
        console.error(
          `Error posting message to Slack API: ${
            res.statusCode
          } - ${
            res.statusMessage}`,
        );
      } else {
        console.error(
          `Server error when processing message: ${
            res.statusCode
          } - ${
            res.statusMessage}`,
        );
      }
    });
    return res;
  });
  postReq.write(payloadStr);
  postReq.end();
}

function createMessage(logevent, name) {
  const log = JSON.parse(logevent.message)
  const message = {
    "channel": SLACK_CHANNEL,
    "attachments": [
      {
	      "mrkdwn_in": ["text"],
          "color": "#FF0000",
          "text": name,
          "fields": [
            {
              "title": "Details",
              "value": `${log.message} - ${log.err}`,
              "short": false
            },
            {
              "title": "Request ID",
              "value": `${log.RequestID}`,
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

exports.handler = async (event, context) => {
  if (event.awslogs && event.awslogs.data) {
    const payload = Buffer.from(event.awslogs.data, 'base64');
    const logevents = JSON.parse(zlib.unzipSync(payload).toString()).logEvents;

    const name = getName(logevents[0]);
    const logevent = logevents[logevents.length - 1];

    const message = createMessage(logevent, name);
    doRequest(message)
  }
};
