output "cwl_log_group_name" {
  value = aws_cloudwatch_log_group.api.name
}

output "cwl_log_group_arn" {
  value = aws_cloudwatch_log_group.api.arn
}

output "ecs_service_name" {
  value = aws_ecs_service.api.name
}

output "alb_tg_suffix"{
  value = aws_lb_target_group.api.arn_suffix
}