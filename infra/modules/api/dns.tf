// dns record for the lb
resource "aws_route53_record" "api" {
  type    = "A"
  zone_id = var.route53_zone_id
  name    = var.domain

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = false
  }
}
