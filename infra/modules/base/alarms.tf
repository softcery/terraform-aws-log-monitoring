module "metric_alarm_task_count" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 3.0"

  alarm_name          = "${var.name}-Task_count"
  alarm_description   = "Task_count in ${var.name}"
  metric_name         = "TaskCount"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.alarm_evaluation_periods
  threshold           = var.ecs_task_count
  period              = var.alarm_period
  statistic           = "Minimum"
  unit                = "Count"
  namespace           = "ECS/ContainerInsights"
  alarm_actions       = [aws_sns_topic.alarm_notification.arn]
  ok_actions          = [aws_sns_topic.alarm_notification.arn]

  dimensions = {
    ClusterName = module.ecs_cluster.cluster_name
  }
}

# RDS
resource "aws_cloudwatch_metric_alarm" "rds_swap_usage" {
  alarm_name          = "${var.rds_db_name}-swap_usage"
  alarm_description   = "Average database swap usage over last 10 minutes too high, performance may suffer"
  metric_name         = "SwapUsage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alarm_evaluation_periods
  threshold           = var.rds_swap_threshold
  period              = var.alarm_period
  statistic           = "Average"

  namespace     = "AWS/RDS"
  alarm_actions = [aws_sns_topic.alarm_notification.arn]
  ok_actions    = [aws_sns_topic.alarm_notification.arn]

  dimensions = {
    DBInstanceIdentifier = module.db.db_instance_id
  }
}
resource "aws_cloudwatch_metric_alarm" "rds_freeable_memory" {
  alarm_name          = "${var.rds_db_name}-freeable_memory"
  alarm_description   = "Average database freeable memory over last 10 minutes too low, performance may suffer"
  metric_name         = "FreeableMemory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.alarm_evaluation_periods
  threshold           = var.rds_memory_threshold
  period              = var.alarm_period
  statistic           = "Average"

  namespace     = "AWS/RDS"
  alarm_actions = [aws_sns_topic.alarm_notification.arn]
  ok_actions    = [aws_sns_topic.alarm_notification.arn]

  dimensions = {
    DBInstanceIdentifier = module.db.db_instance_id
  }
}
resource "aws_cloudwatch_metric_alarm" "rds_cpu_utilization" {
  alarm_name          = "${var.rds_db_name}-cpu_utilization"
  alarm_description   = "Average database CPU utilization over last 10 minutes too high"
  metric_name         = "CPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alarm_evaluation_periods
  threshold           = var.rds_cpu_threshold
  period              = var.alarm_period
  statistic           = "Average"

  namespace     = "AWS/RDS"
  alarm_actions = [aws_sns_topic.alarm_notification.arn]
  ok_actions    = [aws_sns_topic.alarm_notification.arn]

  dimensions = {
    DBInstanceIdentifier = module.db.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_burst_balance" {
  alarm_name          = "${var.rds_db_name}-burst_balance"
  alarm_description   = "Average database storage burst balance over last 10 minutes too low, expect a significant performance drop soon"
  metric_name         = "BurstBalance"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.alarm_evaluation_periods
  threshold           = var.rds_burst_threshold
  period              = var.alarm_period
  statistic           = "Average"

  namespace     = "AWS/RDS"
  alarm_actions = [aws_sns_topic.alarm_notification.arn]
  ok_actions    = [aws_sns_topic.alarm_notification.arn]

  dimensions = {
    DBInstanceIdentifier = module.db.db_instance_id
  }
}
resource "aws_cloudwatch_metric_alarm" "rds_disk_queue_depth" {
  alarm_name          = "${var.rds_db_name}-disk_queue_depth"
  alarm_description   = "Average database disk queue depth over last 10 minutes too high, performance may suffer"
  metric_name         = "DiskQueueDepth"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alarm_evaluation_periods
  threshold           = var.rds_disk-depth_threshold
  period              = var.alarm_period
  statistic           = "Average"

  namespace     = "AWS/RDS"
  alarm_actions = [aws_sns_topic.alarm_notification.arn]
  ok_actions    = [aws_sns_topic.alarm_notification.arn]

  dimensions = {
    DBInstanceIdentifier = module.db.db_instance_id
  }
}


