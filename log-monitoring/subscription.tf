# cwl permission to allow invoking lambda

resource "aws_lambda_permission" "allow_cloudwatch" {
  count         = length(var.log_groups)
  statement_id  = "InvokePermissionForCWL${count.index}"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.lambda_function_name
  principal     = "logs.amazonaws.com"
  source_arn    = "${var.logs_arn}:log-group:${var.log_groups[count.index]}:*"
}

resource "aws_cloudwatch_log_subscription_filter" "subscription-filter" {
  name = "filter-${var.postfix}"

  log_group_name  = each.value
  filter_pattern  = "{ $.severity = \"ERROR\" }"
  destination_arn = module.lambda.lambda_function_arn

  for_each = toset(var.log_groups)
}