resource "aws_ecs_service" "api" {
  name        = var.name
  cluster     = var.ecs_cluster_id
  launch_type = "FARGATE"

  task_definition = data.aws_ecs_task_definition.latest_td.arn

  desired_count                      = var.desired_count
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50

  network_configuration {
    subnets          = var.subnets
    security_groups  = [aws_security_group.api.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.api.arn
    container_name   = var.name
    container_port   = var.port
  }

  lifecycle {
    # create_before_destroy = true
    # ignore_changes = [task_definition]
  }

  tags = local.tags
}
