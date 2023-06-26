resource "aws_cloudwatch_log_group" "api" {
  name = var.name

  retention_in_days = var.log_retention

  tags = local.tags
}
