module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 4.0"

  function_name = "lambda-${var.postfix}"
  source_path = [
    "${path.module}/src"
  ]
  description = "Lambda to process API error logs and send notifications to Slack"
  handler     = "index.handler"
  runtime     = "nodejs16.x"
  memory_size = "128"
  timeout     = "5"

  cloudwatch_logs_retention_in_days = "1"

  environment_variables = merge(tomap({
    SLACK_ENDPOINT = var.slack_endpoint,
    SLACK_CHANNEL  = var.slack_channel,
    USE_LAST_INDEX = var.use_last_index,
    LEVEL          = var.log_level
    ENVIRONMENT = var.environment, }),
    var.env
  )
}
