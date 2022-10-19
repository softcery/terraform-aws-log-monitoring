
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
  type = string
}