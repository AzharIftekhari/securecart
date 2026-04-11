# ─────────────────────────────────────────────
# Networking Outputs
# ─────────────────────────────────────────────
output "vpc_id" {
  description = "ID of the created VPC."
  value       = module.networking.vpc_id
}

output "public_subnet_1_id" {
  description = "ID of public subnet in AZ-1."
  value       = module.networking.public_subnet_1_id
}

output "public_subnet_2_id" {
  description = "ID of public subnet in AZ-2."
  value       = module.networking.public_subnet_2_id
}

output "private_subnet_1_id" {
  description = "ID of private subnet in AZ-1."
  value       = module.networking.private_subnet_1_id
}

output "private_subnet_2_id" {
  description = "ID of private subnet in AZ-2."
  value       = module.networking.private_subnet_2_id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway."
  value       = module.networking.nat_gateway_id
}

# ─────────────────────────────────────────────
# Compute Outputs
# ─────────────────────────────────────────────
output "bastion_public_ip" {
  description = "Public IP address of the bastion host."
  value       = module.compute.bastion_public_ip
}

output "app_private_ip" {
  description = "Private IP address of the application server."
  value       = module.compute.app_private_ip
}

output "bastion_key_pem_path" {
  description = "Local path to the generated bastion SSH private key (.pem)."
  value       = module.compute.bastion_key_pem_path
}

output "app_key_pem_path" {
  description = "Local path to the generated app server SSH private key (.pem)."
  value       = module.compute.app_key_pem_path
}

# ─────────────────────────────────────────────
# ALB Outputs
# ─────────────────────────────────────────────
output "alb_dns_name" {
  description = "Public DNS name of the Application Load Balancer."
  value       = module.alb.alb_dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer."
  value       = module.alb.alb_arn
}

output "target_group_arn" {
  description = "ARN of the ALB target group."
  value       = module.alb.target_group_arn
}

# ─────────────────────────────────────────────
# Secrets Manager Outputs
# ─────────────────────────────────────────────
output "db_secret_arn" {
  description = "ARN of the Secrets Manager secret holding RDS credentials."
  value       = module.secrets.secret_arn
}

output "db_secret_name" {
  description = "Name/path of the secret — use this in your app config."
  value       = module.secrets.secret_name
}

# ─────────────────────────────────────────────
# RDS Outputs
# ─────────────────────────────────────────────
output "rds_endpoint" {
  description = "Connection endpoint for the RDS MySQL instance."
  value       = module.rds.rds_endpoint
}

output "rds_port" {
  description = "Port used by the RDS instance."
  value       = module.rds.rds_port
}

# ─────────────────────────────────────────────
# S3 Outputs
# ─────────────────────────────────────────────
output "s3_bucket_name" {
  description = "Name of the created S3 bucket."
  value       = module.s3.bucket_name
}

output "s3_bucket_arn" {
  description = "ARN of the created S3 bucket."
  value       = module.s3.bucket_arn
}

# ─────────────────────────────────────────────
# WAF Outputs
# ─────────────────────────────────────────────
output "waf_web_acl_arn" {
  description = "ARN of the WAFv2 Web ACL."
  value       = module.waf.web_acl_arn
}
