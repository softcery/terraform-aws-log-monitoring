const https = require('https');
const fetch = require('node-fetch')

const HOSTNAME = process.env.HOSTNAME;
const METHOD = process.env.METHOD

function main(input, context) {
  context.callbackWaitsForEmptyEventLoop = true;

  const requestOptions = {
    method: METHOD,
    headers: {
      'Content-Length': '0',
    }
  };
  
  fetch(HOSTNAME, requestOptions).then((response) => {
    console.log(response.status);
  });
  return 0;
}

exports.handler = main;
