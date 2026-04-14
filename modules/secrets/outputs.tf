output "secret_arn" {
  description = "ARN of the Secrets Manager secret (pass to RDS module)."
  value       = aws_secretsmanager_secret.db.arn
}

output "secret_name" {
  description = "Name/path of the secret in Secrets Manager."
  value       = aws_secretsmanager_secret.db.name
}

output "db_password" {
  description = "Generated DB password (sensitive). Used internally by RDS module."
  value       = random_password.db.result
  sensitive   = true
}

output "db_username" {
  description = "DB username stored in the secret."
  value       = var.db_username
}
