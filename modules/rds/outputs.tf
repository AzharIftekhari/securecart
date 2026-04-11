output "rds_endpoint" {
  description = "Connection endpoint for the RDS instance."
  value       = aws_db_instance.secure-dbint.endpoint
}

output "rds_port" {
  description = "Port of the RDS instance."
  value       = aws_db_instance.secure-dbint.port
}

output "rds_identifier" {
  description = "Identifier of the RDS instance."
  value       = aws_db_instance.secure-dbint.identifier
}

output "rds_arn" {
  description = "ARN of the RDS instance."
  value       = aws_db_instance.secure-dbint.arn
}

output "db_subnet_group_name" {
  description = "Name of the DB subnet group."
  value       = aws_db_subnet_group.secure-dbsub.name
}
