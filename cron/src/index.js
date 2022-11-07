const fetch = require('node-fetch')

const HOSTNAME = process.env.HOSTNAME;
const METHOD = process.env.METHOD

function main(input, context) {
  const requestOptions = {
    method: METHOD,
    headers: {
      'Content-Length': '0',
    }
  };
  
  fetch(HOSTNAME, requestOptions).then((response) => {
    console.log(response.status);
    if (response.status != 200) {
      const message = {
        "message": "Failed to send request",
        "err": `Status Code: ${response.status}`,
        "Request ID": 0
      }
    }
  });
  return 0;
}

exports.handler = main;
