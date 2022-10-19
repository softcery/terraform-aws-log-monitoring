
variable "domain" {
  description = "represents domain name, example: domain.com"
  type        = string
  sensitive   = false
}

variable "name" {
  description = "represents api name, example: my-app"
  type        = string
  sensitive   = false
}

variable "vpc-id" {
  description = "represents vpc id"
  type        = string
  sensitive   = false
}

variable "ecs-cluster-id" {
  description = "represents cluster id"
  type        = string
  sensitive   = false
}

variable "ecs-cluster-arn" {
  description = "represents cluster arn"
  type        = string
  sensitive   = false
}

variable "route53-zone-id" {
  description = "represents route53 zone id"
  type        = string
  sensitive   = false
}

variable "api-desired-count" {
  description = "represents desired count of running tasks, example: 2"
  type        = number
  sensitive   = false
}

variable "vpc-public-subnet-ids" {
  description = "represents list of public subnet ids"
  type        = list(string)
  sensitive   = false
}

variable "tags" {
  description = "represents module tags, example: {Environment = 'staging'}"
  type        = map(string)
  sensitive   = false
}

variable "image_name" {
  description = "represents docker image repository"
  type        = string
}

variable "container_port" {
  description = "represents port that container exposes"
  type        = number
}

variable "region" {
  description = "region to stream ecs logs to"
  type        = string
}

variable "api-env" {
  description = "represents environment, example: staging"
  type        = list(object({ name : string, value = string }))
  sensitive   = false
  default     = []
}

variable "tdf_memory_reservation" {
  description = "represents amount of memory reservation fot task definition"
  type        = number
}

variable "tdf_memory" {
  description = "represents amount of memory for task definition"
  type        = number
}

variable "lb_health_check_enabled" {
  description = "should lb perform health checks"
  type        = bool
}

variable "lb_health_check_path" {
  description = "represents health checks path"
  type        = string
  default     = "/"
}

variable "lb_health_check_interval" {
  description = "represents health checks interval"
  type        = number
  default     = 6
}

variable "lb_health_check_timeout" {
  description = "represents health check timeout"
  type        = number
  default     = 5
}

variable "lb_health_check_healthy_threshold" {
  description = "represents health checks healthy threshold"
  type        = number
  default     = 2
}

variable "lb_health_check_unhealthy_threshold" {
  description = "represents health checks unhealthy threshold"
  type        = number
  default     = 3
}
