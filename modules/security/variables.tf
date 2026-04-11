variable "project_name" {
  description = "Project name prefix."
  type        = string
}

variable "environment" {
  description = "Environment label."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC in which to create security groups."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC (used for intra-VPC rules)."
  type        = string
}
