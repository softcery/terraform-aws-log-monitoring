# module variables

variable "postfix" {
  type        = string
  description = "Optional postfix to add to names of created resources"
  default     = ""
}

# arn:aws:logs:us-east-2:123456789:

variable "slack_endpoint" {
  type        = string
  description = "Webhook URL to the Slack channel"
}

variable "slack_channel" {
  type        = string
  description = "To which Slack channel notifications will be sent"
}

variable "period" {
  type        = string
  description = "Represents lambda executing interval and usage cost period"
}

variable "env" {
  type        = map(string)
  description = "Lambda environment variables"
  default     = {}
}

variable "interval" {
  type        = string
  description = "represents interval with which lambda will be called"
}