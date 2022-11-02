variable "env" {
  type        = map(string)
  description = "Lambda environment variables"
  default     = {}
}

variable "env_hostname" {
  type        = string
  description = "represents hostname of the resource"
}

variable "env_path" {
  type        = string
  description = "represents path"
}

variable "env_method" {
  type        = string
  description = "represents HTTP request method"
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

variable "runtime" {
  type        = string
  description = "represents lambda function runtime environment"
}

variable "handler" {
  type        = string
  description = "represents lambda function handler"
}

variable "timeout" {
  type        = number
  description = "represents the maximum time allowed for lambda to run"
}