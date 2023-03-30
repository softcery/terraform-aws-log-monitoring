module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 4.12.1"

  function_name = "cron-lambda-${var.postfix}"
  source_path = [
    "${path.module}/src"
  ]

  description = "Cron Lambda"
  handler     = "lambda_function.lambda_handler"
  runtime     = "python3.9"
  memory_size = "128"
  timeout     = "10"

  cloudwatch_logs_retention_in_days = var.cloudwatch_logs_retention_in_days

  environment_variables = merge(tomap({
    URL = var.env_url,
    SECRET_NAME = var.env_secret_name}),
    var.env
  )
}
