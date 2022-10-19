const zlib = require('zlib');
const https = require('https');

const SLACK_ENDPOINT = process.env.SLACK_ENDPOINT;
const SLACK_BOT = 'Cloudwatch';

function createMessage(obj) {
  let error;
  const log = JSON.parse(obj.message);
  console.log(JSON.stringify(log));
  error = log.err;
  if (typeof log.err === 'undefined') {
    error = '';
  } else if (typeof log.err === 'object') {
    error = JSON.stringify(log.err[0]);
  }

  const message = {
    "channel": `${process.env.SLACK_CHANNEL}`,
    "attachments": [
      {
	      "mrkdwn_in": ["text"],
          "color": "#FF0000",
          "text": `${log.name}`,
          "fields": [
            {
              "title": "Details",
              "value": `${log.message} - ${error}`,
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

  console.log(JSON.stringify(message));
  return message;
}

function doRequest(logs) {
  const payloadStr = JSON.stringify(createMessage(logs));
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

function main(input, context) {
  context.callbackWaitsForEmptyEventLoop = true;

  const payload = Buffer.from(input.awslogs.data, 'base64');
  const logs = JSON.parse(zlib.gunzipSync(payload).toString('utf8'));

  doRequest(logs.logEvents[0]);
  const response = {
    statusCode: 200,
    body: JSON.stringify('Event sent to Slack!'),
  };
  return response;
}

exports.handler = main;
