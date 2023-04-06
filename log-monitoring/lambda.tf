module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 4.13.0"

  function_name = "lambda-${var.postfix}"
  source_path = [
    "${path.module}/src"
  ]
  description = "Lambda to process API error logs and send notifications to Slack"
  handler     = "lambda_function.lambda_handler"
  runtime     = "python3.9"
  memory_size = "128"
  timeout     = "10"

  cloudwatch_logs_retention_in_days = "3"

  environment_variables = merge(tomap({
    ERROR_CHANNEL  = var.error_channel,
    WARN_CHANNEL   = var.warn_channel,
    ERROR_ENDPOINT = var.error_endpoint,
    WARN_ENDPOINT  = var.warn_endpoint
    ENVIRONMENT = var.environment, }),
    var.env
  )
}
