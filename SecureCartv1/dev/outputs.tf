output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "bastion_public_ip" {
  description = "Public IP of the bastion host"
  value       = module.compute.bastion_public_ip
}

output "app_private_ip" {
  description = "Private IP of the app instance"
  value       = module.compute.app_private_ip
}

output "db_endpoint" {
  description = "RDS connection endpoint"
  value       = module.database.db_endpoint
}

output "s3_bucket_id" {
  description = "Name of the S3 bucket"
  value       = module.security.s3_bucket_id
}

output "waf_arn" {
  description = "ARN of the WAF Web ACL"
  value       = module.security.waf_arn
}
