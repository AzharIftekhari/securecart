variable "project_name" {
  description = "Project name prefix."
  type        = string
}

variable "environment" {
  description = "Environment label."
  type        = string
}

variable "bastion_ami" {
  description = "AMI ID for the bastion host."
  type        = string
}

variable "app_ami" {
  description = "AMI ID for the application EC2 instance."
  type        = string
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

variable "public_subnet_1_id" {
  description = "ID of the public subnet (AZ-1) where the bastion host will be placed."
  type        = string
}

variable "private_subnet_1_id" {
  description = "ID of the private subnet (AZ-1) where the app server will be placed."
  type        = string
}

variable "bastion_sg_id" {
  description = "Security group ID to attach to the bastion host."
  type        = string
}

variable "app_sg_id" {
  description = "Security group ID to attach to the application EC2."
  type        = string
}
