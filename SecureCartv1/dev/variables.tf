variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project" {
  description = "Project name — used as a prefix for all resource names and tags"
  type        = string
  default     = "securecart"
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name"
  type        = string
}

variable "bastion_public_key" {
  description = "SSH public key for the bastion host key pair"
  type        = string
  sensitive   = true
}

variable "app_public_key" {
  description = "SSH public key for the app instance key pair"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "RDS master password — store in AWS Secrets Manager or pass via TF_VAR"
  type        = string
  sensitive   = true
}
