module "metric_alarm_cpu" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 3.0"

  alarm_name          = "${var.name}-CpuUtilized"
  alarm_description   = "CpuUtilized in ${var.name}"
  metric_name         = "CpuUtilized"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.alarm_evaluation_periods
  threshold           = var.cpu_threshold
  period              = var.alarm_period
  statistic           = "Average"
  namespace           = "ECS/ContainerInsights"
  unit                = "None"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]

  dimensions = {
    ServiceName = var.name
    ClusterName = var.ecs_cluster_name
  }
}

module "metric_alarm_memory" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 3.0"

  alarm_name          = "${var.name}-MemoryUtilized"
  alarm_description   = "MemoryUtilized in ${var.name}"
  metric_name         = "MemoryUtilized"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.alarm_evaluation_periods
  threshold           = var.memory_threshold
  period              = var.alarm_period
  statistic           = "Average"
  unit                = "Megabytes"
  namespace           = "ECS/ContainerInsights"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]

  dimensions = {
    ServiceName = var.name
    ClusterName = var.ecs_cluster_name
  }
}

module "alb_tg_500_errors" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 3.0"

  alarm_name          = "${var.name}-500_errors"
  alarm_description   = "500_errors in ${var.name}"
  metric_name         = "HTTPCode_Target_5XX_Count"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.alarm_evaluation_periods
  threshold           = var.errors_threshold
  period              = var.alarm_period
  statistic           = "Sum"
  namespace           = "AWS/ApplicationELB"
  alarm_actions       = [var.sns_topic]

  dimensions = {
    TargetGroup  = aws_lb_target_group.api.arn_suffix
    LoadBalancer = var.alb_suffix
  }
}


