output "alb_sg_id" {
  description = "Security group ID for the ALB."
  value       = aws_security_group.alb.id
}

output "bastion_sg_id" {
  description = "Security group ID for the bastion host."
  value       = aws_security_group.bastion.id
}

output "app_sg_id" {
  description = "Security group ID for the private application EC2."
  value       = aws_security_group.app.id
}

output "rds_sg_id" {
  description = "Security group ID for the RDS instance."
  value       = aws_security_group.rds.id
}

output "operator_ip_cidr" {
  description = "CIDR of the operator IP detected at plan time (used for bastion SSH rule)."
  value       = local.my_ip_cidr
}
