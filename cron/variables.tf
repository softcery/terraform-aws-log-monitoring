variable "env" {
  type        = map(string)
  description = "Lambda environment variables"
  default     = {}
}

variable "env_url" {
  type        = string
}

variable "env_secret_name" {
  type        = string
}

variable "interval" {
  type        = string
  description = "represents interval with which lambda will be called"
}

variable "postfix" {
  type        = string
  description = "represents postfix to add to names of created resources"
  default     = ""
}

variable "cloudwatch_logs_retention_in_days" {
  type = number
  default = 1
}
