# create acm and explicitly set it to us-east-1 provider
module "acm_cert_cdn" {
  source  = "cloudposse/acm-request-certificate/aws"
  version = "0.16.3"

  providers = {
    aws = aws.us-east-1
  }

  name                              = var.name
  domain_name                       = var.domain
  subject_alternative_names         = ["*.${var.domain}"]
  process_domain_validation_options = true
  ttl                               = "300"
  wait_for_certificate_issued       = true

  depends_on = [aws_route53_zone.base]

  tags = local.tags
}

# create acm and explicitly set it to us-east-1 provider
module "acm_cert" {
  source  = "cloudposse/acm-request-certificate/aws"
  version = "0.16.3"

  providers = {
    aws = aws
  }

  domain_name                       = var.domain
  subject_alternative_names         = ["*.${var.domain}"]
  process_domain_validation_options = true
  ttl                               = "300"
  wait_for_certificate_issued       = true

  depends_on = [aws_route53_zone.base]

  tags = local.tags
}
