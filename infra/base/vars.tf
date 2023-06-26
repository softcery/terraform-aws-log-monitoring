variable "name" {
  type        = string
  description = "Name to be used on all the resources as identifier"
}

variable "domain" {
  type        = string
  description = "The domain name to use for the DNS zone"
}

# vpc variables
variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "azs" {
  type        = list(string)
  description = "List of availability zones where the subnets will be created"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnets CIDR to create"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnets CIDR to create"
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  default     = false
}

variable "enable_vpn_gateway" {
  type        = bool
  description = "Should be true if you want to create a VPN Gateway for VPC"
  default     = false
}

variable "vpc_enable_dns_hostnames" {
  type        = bool
  description = "Determines whether the VPC supports assigning public DNS hostnames to instances with public IP addresses"
  default     = true
}

variable "vpc_enable_dns_support" {
  type        = bool
  description = "Determines whether the VPC supports DNS resolution through the Amazon provided DNS server"
  default     = true
}

# rds variables
variable "rds_engine" {
  type        = string
  description = "The database engine to use"
  default     = "postgres"
}

variable "rds_engine_version" {
  type        = string
  description = "The engine version to use"
  default     = "15.3"
}

variable "rds_family" {
  type        = string
  description = "The family of the DB instance type"
  default     = "postgres15"
}

variable "rds_instance_class" {
  type        = string
  description = "The instance type of the RDS instance"
  default     = "db.t4g.micro"
}

variable "rds_allocated_storage" {
  type        = number
  description = "The allocated storage in gigabytes"
  default     = 8
}

variable "rds_max_allocated_storage" {
  type        = number
  description = "The upper limit to which Amazon RDS can automatically scale the storage of the DB instance"
  default     = 16
}

variable "rds_storage_type" {
  type        = string
  description = "One of standard (magnetic), gp2, gp3, io1, io2"
  default     = "gp2"
}

variable "rds_iops" {
  type        = number
  description = "The amount of provisioned IOPS. Available only for io1 and io2 storage types."
  default     = null
}

variable "rds_username" {
  type        = string
  description = "Username for the master DB user"
}

variable "rds_password" {
  type        = string
  description = "Password for the master DB user"
}

variable "rds_db_name" {
  type        = string
  description = "The name of the database to create on the instance"
}

variable "rds_backup_retention_period" {
  type        = number
  description = "The days to retain backups for"
  default     = 7
}

variable "rds_backup_window" {
  type        = string
  description = "The daily time range during which automated backups are created if automated backups are enabled"
  default     = "08:00-08:30" # backups at 4am-4:30am in NY or 1am-1:30am in SF
}

variable "rds_maintenance_window" {
  type        = string
  description = "The weekly time range (in UTC) during which system maintenance can occur"
  default     = "Mon:08:31-Mon:09:10" # maintenance at 4am-5am in NY or 1:31am-2:10am in SF
}

variable "rds_publicly_accessible" {
  type        = bool
  description = "Determines if database can be publicly available"
  default     = false
}

variable "rds_deletion_protection_enabled" {
  type        = bool
  description = "Determines whether deletion protection is enabled for the RDS instance"
  default     = true
}

# alarms
variable "alarm_evaluation_periods" {
  description = "Evaluation period of metrics for alarm to trigger"
  type        = string
  default     = "1"
}
variable "alarm_period" {
  description = "Duration of threshold being breached for alarm to trigger ( in seconds )"
  type        = string
  default = "600"
}
variable "ecs_task_count" {
  description = "Minimal number of tasks running on ECS for alarm to be considere OK. Anything less would imply that some service isn't deployed"
  type        = string
  default     = "3"
}
variable "rds_swap_threshold" {
  description = "Threshold value of rds swap usage (in bytes)"
  type        = string
  default     = "256000000"

}
variable "rds_memory_threshold" {
  description = "Threshold value of rds freeable memory (in bytes)"
  type        = string
  default     = "64000000"

}
variable "rds_cpu_threshold" {
  description = "Threshold value of rds CPU utilization (in percentes)"
  type        = string
  default     = "80"

}
variable "rds_burst_threshold" {
  description = "Threshold value of rds burst balance "
  type        = string
  default     = "20"

}
variable "rds_disk-depth_threshold" {
  description = "Threshold value of rds disk queue depth"
  type        = string
  default     = "64"
}

# budgets
variable "budget_limit" {
  description = "monthly limit for a budget"
  type = string
}

variable "budget_email_subscribers" {
  description = "Subscribers of budget alert notification"
  type = list(string)
}


locals {
  tags = {
    Terraform   = "true"
    Name        = var.name
    Environment = var.name
  }
}
