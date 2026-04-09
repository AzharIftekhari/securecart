variable "project_name" {
  description = "Project name prefix."
  type        = string
}

variable "environment" {
  description = "Environment label."
  type        = string
}

variable "alb_sg_id" {
  description = "Security group ID to attach to the ALB."
  type        = string
}

variable "public_subnet_1_id" {
  description = "ID of public subnet in AZ-1."
  type        = string
}

variable "public_subnet_2_id" {
  description = "ID of public subnet in AZ-2."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the target group."
  type        = string
}

variable "app_instance_id" {
  description = "EC2 instance ID of the application server to register in the target group."
  type        = string
}
