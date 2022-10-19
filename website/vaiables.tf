
variable "route53-zone-id" {
  description = "represents route53 zone id"
  type        = string
  sensitive   = false
}

variable "domain" {
  description = "represents domain name, example: domain.com"
  type        = string
  sensitive   = false
}

variable "postfix" {
  description = "represents postfix, example: my-app"
  type        = string
  sensitive   = false
}

variable "tags" {
  description = "represents module tags, example: {Environment = 'staging'}"
  type        = map(string)
  sensitive   = false
}

