variable "region" {
  type        = string
  description = "The region to deploy to"
}

variable "name" {
  type        = string
  description = "Name to be used on all the resources as identifier"
}

variable "environment" {
  type        = string
  description = "Environment to be used on all resources as identifier"
}

variable "domain" {
  type        = string
  description = "The domain name to use for the DNS zone"
}

variable "subnets" {
  type        = list(string)
  description = "List of subnets to create the ALB"
}

variable "route53_zone_id" {
  type        = string
  description = "The ID of the Route53 zone to create records"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC to deploy service to"
}

variable "ecs_cluster_id" {
  type        = string
  description = "The ID of the ECS cluster to deploy service to"
}

variable "ecs_cluster_name" {
  type        = string
  description = "The Name of the ECS cluster to deploy service to"
}

variable "desired_count" {
  type        = number
  description = "The number of service replicas to deploy"
}

variable "cpu" {
  type        = number
  description = "The number of cpu units to reserve for the container"
  default     = 256 # minimum
}

variable "memory" {
  type        = number
  description = "The amount of memory (in MiB) to reserve for the container"
  default     = 512 # minimum
}

variable "log_retention" {
  type        = number
  description = "The number of days to retain logs for the service"
  default     = 14
}

variable "image" {
  type        = string
  description = "The Docker image to deploy"
}

variable "health_check_path" {
  type        = string
  description = "The path to use for the health check"
  default     = "/"
}

variable "port" {
  type        = number
  description = "The port to expose on the container"
}

variable "alb_dns_name" {
  type        = string
  description = "The DNS name of the ALB to use for the service"
}

variable "alb_zone_id" {
  type        = string
  description = "The zone ID of the ALB to use for the service"
}

variable "alb_listener_arn" {
  type        = string
  description = "The ARN of the ALB listener to use for the service"
}

variable "alb_suffix" {
  type        = string
  description = "Suffix of ALB ARN"
}


variable "env_vars" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "A map of environment variables to pass to the container"
  default     = []
}

# alarms
variable "sns_topic" {
  type        = string
  description = "ARN of sns topic for alarms"
}

variable "cpu_threshold" {
  description = "CPU ulitization threshold for alarms"
  type        = string
  default     = "80"
}

variable "memory_threshold" {
  description = "Memory utilization threshold for alarms"
  type        = string
  default     = "460"
}

variable "errors_threshold" {
  description = "5XX Errors treshold for alarms"
  type        = string
  default     = "1"

}

variable "alarm_evaluation_periods" {
  description = "Evaluation periods of metrics for alarms to trigger"
  type        = string
  default     = "1"
}

variable "alarm_period" {
  description = "Period of time (in secods) for alarm to trigger"
  type        = string
  default     = "60"
}


variable "iam_policy_statements" {
  type = map(object({
    effect     = string
    actions    = list(string)
    resources  = list(string)
    conditions = list(map(string))
  }))
}

locals {
  tags = {
    Terraform   = "true"
    Name        = var.name
    Environment = var.environment
  }
}
