# ═══════════════════════════════════════════════════════════
#  Module: rds
#  Resources: DB Subnet Group, MySQL RDS Instance
#  Password is sourced from AWS Secrets Manager — never hardcoded.
# ═══════════════════════════════════════════════════════════

# ─────────────────────────────────────────────
# Read credentials from Secrets Manager at apply time
# ─────────────────────────────────────────────
data "aws_secretsmanager_secret" "secret-db" {
  arn = var.secret_arn
}

data "aws_secretsmanager_secret_version" "db" {
  secret_id = data.aws_secretsmanager_secret.secret-db.id
}

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.db.secret_string)
}

# ─────────────────────────────────────────────
# DB Subnet Group
# Spans both private subnets across two AZs for failover support
# ─────────────────────────────────────────────
resource "aws_db_subnet_group" "secure-dbsub" {
  name        = "${var.project_name}-db-subnet-group-${var.environment}"
  description = "Subnet group for ${var.project_name} RDS ${var.environment}"
  subnet_ids  = [var.private_subnet_1_id, var.private_subnet_2_id]

  tags = {
    Name = "${var.project_name}-db-subnet-group-${var.environment}"
  }
}

# ─────────────────────────────────────────────
# RDS MySQL Instance
# Credentials are pulled from Secrets Manager at apply time.
# The app retrieves them at runtime via the AWS SDK.
# ─────────────────────────────────────────────
resource "aws_db_instance" "secure-dbint" {
  identifier        = "${var.project_name}-db-${var.environment}"
  engine            = "mysql"
  engine_version    = var.db_engine_version
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage

  db_name  = local.db_creds["dbname"]
  username = local.db_creds["username"]
  password = local.db_creds["password"]

  db_subnet_group_name   = aws_db_subnet_group.secure-dbsub.name
  vpc_security_group_ids = [var.rds_sg_id]

  publicly_accessible       = false
  multi_az                  = var.db_multi_az
  skip_final_snapshot       = var.db_skip_final_snapshot
  final_snapshot_identifier = var.db_skip_final_snapshot ? null : "${var.project_name}-db-final-snapshot-${var.environment}"

  # Encryption at rest
  storage_encrypted = true

  # Free tier only supports 0. Set to 7+ for paid/production accounts.
  backup_retention_period = var.db_backup_retention_period
  backup_window           = "03:00-04:00"
  maintenance_window      = "Mon:04:00-Mon:05:00"

  # Prevent accidental deletion — set true for production
  deletion_protection = false

  tags = {
    Name = "${var.project_name}-db-${var.environment}"
  }
}
