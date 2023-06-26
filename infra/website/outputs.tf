output "cloudfront_distribution_id" {
  value       = module.cdn.cf_id
  description = "ID of AWS CloudFront distribution"
}