variable "project_name" {
  description = "Project name prefix."
  type        = string
}

variable "environment" {
  description = "Environment label."
  type        = string
}

variable "db_username" {
  description = "Master username to store in the secret."
  type        = string
  default     = "admin"
}

variable "db_name" {
  description = "Database name to store in the secret."
  type        = string
}

variable "recovery_window_in_days" {
  description = "Days Secrets Manager waits before permanently deleting a secret. Set 0 to delete immediately (useful in dev/destroy workflows)."
  type        = number
  default     = 0
}
