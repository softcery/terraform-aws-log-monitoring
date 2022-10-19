
// api load balancer
resource "aws_lb" "api" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.api-lb.id]
  subnets            = var.vpc-public-subnet-ids
  tags               = var.tags
}

// dns record for the lb
resource "aws_route53_record" "api" {
  zone_id = var.route53-zone-id
  name    = var.domain
  type    = "A"

  alias {
    name                   = aws_lb.api.dns_name
    zone_id                = aws_lb.api.zone_id
    evaluate_target_health = false
  }
}

// api load balancer sg
resource "aws_security_group" "api-lb" {
  name   = "alb-${var.name}"
  vpc_id = var.vpc-id
  tags   = var.tags

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


// lb https listener
resource "aws_lb_listener" "api-http" {
  load_balancer_arn = aws_lb.api.arn
  port              = "80"
  protocol          = "HTTP"
  tags              = var.tags

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

// lb http listener
resource "aws_lb_listener" "api-https" {
  load_balancer_arn = aws_lb.api.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.api.arn
  tags              = var.tags

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

// lb listener rule
resource "aws_lb_listener_rule" "api" {
  listener_arn = aws_lb_listener.api-https.arn
  tags         = var.tags

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

// microservice target group
resource "aws_lb_target_group" "api" {
  name        = var.name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc-id
  target_type = "instance"

  deregistration_delay = 10 // 10 seconds
  tags                 = var.tags

  health_check {
    enabled             = true
    path                = "/"
    interval            = 6
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

