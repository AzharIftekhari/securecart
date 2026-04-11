variable "project_name" {
  description = "Project name prefix."
  type        = string
}

variable "environment" {
  description = "Environment label."
  type        = string
}

variable "private_subnet_1_id" {
  description = "ID of private subnet in AZ-1."
  type        = string
}

variable "private_subnet_2_id" {
  description = "ID of private subnet in AZ-2."
  type        = string
}

variable "rds_sg_id" {
  description = "Security group ID to attach to the RDS instance."
  type        = string
}

variable "secret_arn" {
  description = "ARN of the Secrets Manager secret containing db username and password."
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage in GB."
  type        = number
  default     = 20
}

variable "db_engine_version" {
  description = "MySQL engine version."
  type        = string
  default     = "8.0"
}

variable "db_multi_az" {
  description = "Enable Multi-AZ deployment."
  type        = bool
  default     = false
}

variable "db_skip_final_snapshot" {
  description = "Skip final snapshot on destroy."
  type        = bool
  default     = true
}

variable "db_backup_retention_period" {
  description = "Backup retention period in days. 0 disables backups (required for AWS free tier). Set to 7+ for production."
  type        = number
  default     = 0
}
