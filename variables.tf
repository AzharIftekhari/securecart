# ─────────────────────────────────────────────
# Global / Project
# ─────────────────────────────────────────────
variable "project_name" {
  description = "Name prefix used for all resource naming and tagging."
  type        = string
  default     = "securecart"
}

variable "environment" {
  description = "Deployment environment (dev | staging | prod)."
  type        = string
  default     = "dev"
}

variable "region" {
  description = "AWS region to deploy resources into."
  type        = string
  default     = "us-east-1"
}

# ─────────────────────────────────────────────
# Networking
# ─────────────────────────────────────────────
variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "CIDR for public subnet in AZ-1."
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR for public subnet in AZ-2."
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_1_cidr" {
  description = "CIDR for private subnet in AZ-1."
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR for private subnet in AZ-2."
  type        = string
  default     = "10.0.4.0/24"
}

variable "az1" {
  description = "Primary availability zone."
  type        = string
  default     = "us-east-1a"
}

variable "az2" {
  description = "Secondary availability zone."
  type        = string
  default     = "us-east-1b"
}

# ─────────────────────────────────────────────
# Compute
# ─────────────────────────────────────────────
variable "bastion_ami" {
  description = "AMI ID for the bastion host."
  type        = string
  default     = "ami-02dfbd4ff395f2a1b"
}

variable "app_ami" {
  description = "AMI ID for the application EC2 instance."
  type        = string
  default     = "ami-02dfbd4ff395f2a1b"
}

variable "bastion_instance_type" {
  description = "EC2 instance type for the bastion host."
  type        = string
  default     = "t3.micro"
}

variable "app_instance_type" {
  description = "EC2 instance type for the application server."
  type        = string
  default     = "t3.micro"
}

# ─────────────────────────────────────────────
# RDS
# ─────────────────────────────────────────────
variable "db_name" {
  description = "Name of the MySQL database."
  type        = string
  default     = "securecart"
}

variable "db_username" {
  description = "Master username for the RDS instance."
  type        = string
  default     = "admin"
}

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage in GB for RDS."
  type        = number
  default     = 20
}

variable "db_engine_version" {
  description = "MySQL engine version."
  type        = string
  default     = "8.0"
}

variable "db_multi_az" {
  description = "Enable Multi-AZ for RDS (recommended for production)."
  type        = bool
  default     = false
}

variable "db_skip_final_snapshot" {
  description = "Skip final snapshot on DB deletion. Set false for production."
  type        = bool
  default     = true
}

variable "secret_recovery_window" {
  description = "Days before Secrets Manager permanently deletes a secret. Use 0 for dev/destroy workflows, 7-30 for production."
  type        = number
  default     = 0
}

# ─────────────────────────────────────────────
# S3
# ─────────────────────────────────────────────
variable "s3_bucket_name" {
  description = "Globally unique S3 bucket name."
  type        = string
  default     = "securecart-unique-bucket-name-24032026"
}

# ─────────────────────────────────────────────
# WAF
# ─────────────────────────────────────────────
variable "waf_enable_common_rules" {
  description = "Enable AWS Managed Common Rule Set in WAF."
  type        = bool
  default     = true
}

variable "waf_enable_bad_inputs_rules" {
  description = "Enable AWS Managed Known Bad Inputs Rule Set in WAF."
  type        = bool
  default     = true
}

variable "waf_enable_sqli_rules" {
  description = "Enable AWS Managed SQLi Rule Set in WAF."
  type        = bool
  default     = true
}

variable "db_backup_retention_period" {
  description = "RDS backup retention in days. 0 = disabled (free tier). Set 7+ for production."
  type        = number
  default     = 0
}
