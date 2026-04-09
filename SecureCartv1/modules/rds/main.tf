# ─────────────────────────────────────────────
# DB Subnet Group
# Spans both private subnets across two AZs for failover support
# ─────────────────────────────────────────────
resource "aws_db_subnet_group" "secure-rds" {
  name        = "${var.project_name}-db-subnet-group-${var.environment}"
  description = "Subnet group for ${var.project_name} RDS (${var.environment})"
  subnet_ids  = [var.private_subnet_1_id, var.private_subnet_2_id]

  tags = {
    Name = "${var.project_name}-db-subnet-group-${var.environment}"
  }
}

# ─────────────────────────────────────────────
# RDS MySQL Instance
# Deployed in private subnets, not publicly accessible.
# ⚠️  In production: set db_password via AWS Secrets Manager
#     and reference it with a data source — never hardcode.
# ─────────────────────────────────────────────
resource "aws_db_instance" "rds-instance" {
  identifier        = "${var.project_name}-db-${var.environment}"
  engine            = "mysql"
  engine_version    = var.db_engine_version
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.secure-rds.name
  vpc_security_group_ids = [var.rds_sg_id]

  publicly_accessible    = false
  multi_az               = var.db_multi_az
  skip_final_snapshot    = var.db_skip_final_snapshot
  final_snapshot_identifier = var.db_skip_final_snapshot ? null : "${var.project_name}-db-final-snapshot-${var.environment}"

  # Enable encryption at rest
  storage_encrypted = true

  # Enable automated backups (7-day retention) for Production
  backup_retention_period = 0
  backup_window           = "03:00-04:00"
  maintenance_window      = "Mon:04:00-Mon:05:00"

  # Enable enhanced monitoring and performance insights for production tuning
  # monitoring_interval    = 60
  # monitoring_role_arn    = aws_iam_role.rds_monitoring.arn
  # performance_insights_enabled = true

  # Prevent accidental deletion in production
  deletion_protection = false  # Set true for prod

  tags = {
    Name = "${var.project_name}-db-${var.environment}"
  }
}
