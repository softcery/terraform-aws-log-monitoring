# acm
output "acm_cert_arn" {
  value = module.acm_cert.arn
}

output "acm_cert_cdn_arn" {
  value = module.acm_cert_cdn.arn
}

# sns
output "sns_budget_arn" {
  value = aws_sns_topic.budget_notification.arn
}
output "sns_alarm_arn"{
  value = aws_sns_topic.alarm_notification.arn
}

# ecr
output "ecr_repository_url" {
  value = aws_ecr_repository.base.repository_url
}

output "ecr_repository_name" {
  value = aws_ecr_repository.base.name
}

# vpc
output "route53_zone_id" {
  value = aws_route53_zone.base.zone_id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "ecs_cluster_id" {
  value = module.ecs_cluster.cluster_id
}

output "ecs_cluster_name" {
  value = module.ecs_cluster.cluster_name
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

# alb
output "alb_arn" {
  value = aws_lb.base.arn
}

output "alb_arn_suffix" {
  value = aws_lb.base.arn_suffix
}

output "alb_dns_name" {
  value = aws_lb.base.dns_name
}

output "alb_zone_id" {
  value = aws_lb.base.zone_id
}

output "alb_listener_arn" {
  value = aws_lb_listener.base_https.arn
}

# db
output "db_address" {
  value = aws_route53_record.db.name
}
