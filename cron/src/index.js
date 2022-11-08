const fetch = require('node-fetch')
const util = require('util')

const HOSTNAME = process.env.HOSTNAME;
const METHOD = process.env.METHOD

function main(input, context) {
  console.error = function () {
    var args = Array.prototype.slice.call(arguments)
    process.stderr.write(args.map(function (arg) {
      return util.isPrimitive(arg) ? String(arg) : util.inspect(arg)
    }).join(' '))
  }
  const requestOptions = {
    method: METHOD,
    headers: {
      'Content-Length': '0',
    }
  };
  
  fetch(HOSTNAME, requestOptions).then((response) => {
    console.log(response.status);
    if (response.status != 200) {
      let message = {"severity": "ERROR", "name": "CronJob", "message": "Failed to send request","err": `Status Code: ${response.status}`,"RequestID": "0"};
      console.error(JSON.stringify(message));
    }
  });
}

exports.handler = main;
