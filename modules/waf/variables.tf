variable "project_name" {
  description = "Project name prefix."
  type        = string
}

variable "environment" {
  description = "Environment label."
  type        = string
}

variable "alb_arn" {
  description = "ARN of the ALB to associate the WAF Web ACL with."
  type        = string
}

variable "waf_enable_common_rules" {
  description = "Enable AWS Managed Common Rule Set."
  type        = bool
  default     = true
}

variable "waf_enable_bad_inputs_rules" {
  description = "Enable AWS Managed Known Bad Inputs Rule Set."
  type        = bool
  default     = true
}

variable "waf_enable_sqli_rules" {
  description = "Enable AWS Managed SQLi Rule Set."
  type        = bool
  default     = true
}
