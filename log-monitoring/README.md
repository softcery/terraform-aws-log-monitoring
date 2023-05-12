Creates lambda function that processes logs in JSON format and sends a notification to Slack.
Lambda is called automatically using CloudWatch Subscription filter where a pattern is specified. If a pattern appears in a log entry the function is called.
