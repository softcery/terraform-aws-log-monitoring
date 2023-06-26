# if cdn enabled
module "cdn" {
  source = "github.com/softcery/terraform-aws-cloudfront-s3-cdn"

  name = var.name

  website_enabled     = true
  aliases             = [var.domain]
  acm_certificate_arn = var.acm_cert_arn
  parent_zone_id      = var.route53_zone_id

  index_document = "index.html"
  error_document = "index.html"

  logging_enabled         = false
  dns_alias_enabled       = false
  allow_ssl_requests_only = false

  tags = local.tags
}

resource "aws_route53_record" "cdn" {
  zone_id = var.route53_zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = module.cdn.cf_domain_name
    zone_id                = module.cdn.cf_hosted_zone_id
    evaluate_target_health = false
  }
}
