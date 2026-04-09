variable "project_name" {
  description = "Project name prefix."
  type        = string
}

variable "environment" {
  description = "Environment label."
  type        = string
}

variable "s3_bucket_name" {
  description = "Globally unique S3 bucket name."
  type        = string
}
