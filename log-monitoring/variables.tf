# module variables
variable "log_groups" {
  type        = list(string)
  description = "Names of log groups for which subscription filters will be created"
}

variable "postfix" {
  type        = string
  description = "Optional postfix to add to names of created resources"
  default     = ""
}

# arn:aws:logs:us-east-2:123456789:
variable "logs_arn" {
  type        = string
  description = "Base arn of specifed logs"
}

variable "environment" {
  type        = string
  description = "represents environment in which application is deployed"
}

variable "env" {
  type        = map(string)
  description = "Lambda environment variables"
  default     = {}
}

variable "filter_pattern" {
  type = string
}

variable "error_channel" {}
variable "warn_channel" {}
variable "error_endpoint" {}
variable "warn_endpoint" {}
