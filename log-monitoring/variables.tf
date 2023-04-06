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

variable "error_channel" {
  type = string
  default = " "
}
variable "warn_channel" {
  type = string
  default = " "
}
variable "error_endpoint" {
  type = string
  default = " "
}
variable "warn_endpoint" {
  type = string
  default = " "
}
