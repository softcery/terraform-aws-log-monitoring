module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 4.0"

  function_name = "cron-lambda-${var.postfix}"
  source_path   = [var.source_path]
  description   = "Cron Lambda"
  handler       = var.handler
  runtime       = var.runtime
  memory_size   = "128"
  timeout       = var.timeout

  cloudwatch_logs_retention_in_days = "1"

  environment_variables = merge(tomap({
    HOSTNAME = var.env_hostname,
    PATH     = var.env_path,
    METHOD = var.env_method }),
    var.env
  )
}
