output "lambda_log_group" {
  value = module.lambda.lambda_cloudwatch_log_group_name
}