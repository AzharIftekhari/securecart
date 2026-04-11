variable "project_name" {
  description = "Project name prefix for resource naming."
  type        = string
}

variable "environment" {
  description = "Environment label (dev | staging | prod)."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "public_subnet_1_cidr" {
  description = "CIDR for public subnet in AZ-1."
  type        = string
}

variable "public_subnet_2_cidr" {
  description = "CIDR for public subnet in AZ-2."
  type        = string
}

variable "private_subnet_1_cidr" {
  description = "CIDR for private subnet in AZ-1."
  type        = string
}

variable "private_subnet_2_cidr" {
  description = "CIDR for private subnet in AZ-2."
  type        = string
}

variable "az1" {
  description = "Primary availability zone."
  type        = string
}

variable "az2" {
  description = "Secondary availability zone."
  type        = string
}
