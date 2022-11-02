const https = require('https');

const HOSTNAME = process.env.HOSTNAME;
const PATH = process.env.PATH
const METHOD = process.env.METHOD

function doRequest() {
  const options = {
    hostname: HOSTNAME,
    port: 443,
    path: PATH,
    method: METHOD,
    headers: {
      'Content-Length': 0,
    },
  };

  const postReq = https.request(options, (res) => {
    const chunks = [];
    res.setEncoding('utf8');
    res.on('data', (chunk) => chunks.push(chunk));
    res.on('end', () => {
      if (res.statusCode < 400) {
        console.log(res.statusCode);
      } else if (res.statusCode < 500) {
        console.error(
          `Error putting secret: ${
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
  postReq.end();
}

function main(input, context) {
  context.callbackWaitsForEmptyEventLoop = true;

  doRequest();
  return 0;
}

exports.handler = main;
