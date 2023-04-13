
resource "aws_cloudwatch_event_rule" "event_rule" {
  name                = "${var.name}-rule"
  description         = "Call lambda every interval"
  schedule_expression = var.interval
}

resource "aws_cloudwatch_event_target" "call_lambda" {
  rule      = aws_cloudwatch_event_rule.event_rule.name
  target_id = "${var.name}-target"
  arn       = module.lambda.lambda_function_arn
}

resource "aws_lambda_permission" "allow_cw_call_lambda" {
  statement_id  = "allow-cw-${var.name}"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.event_rule.arn
}
