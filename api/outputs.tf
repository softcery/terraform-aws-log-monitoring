output "cwl_log_group_name" {
  value = aws_cloudwatch_log_group.api.name
}

output "lb_security_group_id" {
  value = aws_security_group.api-lb.id
}