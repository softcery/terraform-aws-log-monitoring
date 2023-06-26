variable "name" {
  type        = string
  description = "Name to be used on all the resources as identifier"
}

variable "region" {
  type        = string
  description = "The region to deploy the resources"
}

variable "environment" {
  type        = string
  description = "The environment to be used on all the resources as identifier"
}

variable "domain" {
  type        = string
  description = "The domain name to use for the DNS zone"
}

variable "acm_cert_arn" {
  type        = string
  description = "The ARN of the ACM TLS certificate to use for the website https"
}

variable "route53_zone_id" {
  type        = string
  description = "The ID of the Route53 DNS zone to use for the website"
}

locals {
  tags = {
    Terraform   = "true"
    Name        = var.name
    Environment = var.environment
  }
}
