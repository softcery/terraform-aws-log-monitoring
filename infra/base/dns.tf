resource "aws_route53_zone" "base" {
  name = var.domain
  tags = local.tags
}

resource "aws_route53_record" "subdomain" {
  zone_id = "Z08391391QN24LNLSINRV"
  name    = var.domain
  type    = "NS"
  ttl     = 172800
  records = [
    "${aws_route53_zone.base.name_servers[0]}.",
    "${aws_route53_zone.base.name_servers[1]}.",
    "${aws_route53_zone.base.name_servers[2]}.",
    "${aws_route53_zone.base.name_servers[3]}.",
  ]
  allow_overwrite = true
}
