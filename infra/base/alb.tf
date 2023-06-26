resource "aws_lb" "base" {
  name = var.name

  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.base.id]
  subnets                    = module.vpc.public_subnets
  idle_timeout               = 60 * 5 # 5 minutes
  drop_invalid_header_fields = true

  tags = local.tags
}

// lb https listener
resource "aws_lb_listener" "base-http" {
  load_balancer_arn = aws_lb.base.arn

  port     = "80"
  protocol = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }


}


// lb https listener
resource "aws_lb_listener" "base_https" {
  load_balancer_arn = aws_lb.base.arn

  port            = "443"
  protocol        = "HTTPS"
  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = module.acm_cert.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }

  tags = local.tags
}
