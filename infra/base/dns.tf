resource "aws_route53_zone" "base" {
  name = var.domain
  tags = local.tags
}

