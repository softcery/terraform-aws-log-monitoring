
// lb https listener rule
resource "aws_lb_listener_rule" "api" {
  listener_arn = var.alb_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }

  condition {
    host_header {
      values = [var.domain]
    }
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  tags = local.tags
}

// api target group
resource "aws_lb_target_group" "api" {
  name        = var.name
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  deregistration_delay = 10 // 10 seconds

  health_check {
    enabled             = true
    path                = var.health_check_path
    interval            = 6
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = local.tags
}
