# module variables
variable "log_groups" {
  type = list(string)
  description = "Names of log groups for which subscription filters will be created"
}

variable "postfix" {
  type    = string
  description = "Optional postfix to add to names of created resources"
  default = ""
}

# arn:aws:logs:us-east-2:123456789:
variable "logs_arn" {
  type        = string
  description = "Base arn of specifed logs"
}

variable "slack_endpoint" {
  type        = string
  description = "Webhook URL to the Slack channel"
}

variable "slack_channel" {
  type        = string
  description = "To which Slack channel notifications will be sent"
}

variable "env" {
  type        = map(string)
  description = "Lambda environment variables"
  default     = {}
}