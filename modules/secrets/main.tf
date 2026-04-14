# ═══════════════════════════════════════════════════════════
#  Module: secrets
#  Resources: AWS Secrets Manager secret for RDS credentials.
#
#  Flow:
#    1. Generate a random secure password (no hardcoding needed)
#    2. Store username + password as JSON in Secrets Manager
#    3. RDS module reads the secret via data source at apply time
#    4. App EC2 retrieves the secret at runtime via SDK/CLI
# ═══════════════════════════════════════════════════════════

# ─────────────────────────────────────────────
# Generate a cryptographically secure random password
# Avoids special chars that break MySQL connection strings
# ─────────────────────────────────────────────
resource "random_password" "db" {
  length           = 24
  special          = true
  override_special = "!#$%^&*()-_=+[]{}|"  # safe subset for MySQL
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
}

# ─────────────────────────────────────────────
# Secrets Manager Secret (the container/metadata)
# ─────────────────────────────────────────────
resource "aws_secretsmanager_secret" "db" {
  name        = "${var.project_name}/${var.environment}/rds/credentials"
  description = "RDS MySQL credentials for ${var.project_name} ${var.environment}"

  # Recover within 7 days if accidentally deleted
  recovery_window_in_days = var.recovery_window_in_days

  tags = {
    Name = "${var.project_name}-db-secret-${var.environment}"
  }
}

# ─────────────────────────────────────────────
# Secret Version (the actual JSON payload)
# Stored as: { "username": "...", "password": "..." }
# This is the standard format RDS Lambda rotation expects
# ─────────────────────────────────────────────
resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id

  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db.result
    engine   = "mysql"
    dbname   = var.db_name
  })
}
