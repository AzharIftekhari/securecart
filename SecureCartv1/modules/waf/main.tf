# ─────────────────────────────────────────────
# WAFv2 Web ACL
# Default action: ALLOW — blocked only by specific rules below.
# All three managed rule groups are toggled via input variables.
# ─────────────────────────────────────────────
resource "aws_wafv2_web_acl" "secure-waf" {
  name        = "${var.project_name}-web-acl-${var.environment}"
  description = "WAF Web ACL for ${var.project_name} -${var.environment}"
  scope       = "REGIONAL" # REGIONAL = ALB / API Gateway; CLOUDFRONT = us-east-1 only

  default_action {
    allow {}
  }

  # ── Rule 1: AWS Common Rule Set ──────────────────────────
  # Covers OWASP Top 10, including XSS, path traversal, etc.
  dynamic "rule" {
    for_each = var.waf_enable_common_rules ? [1] : []
    content {
      name     = "AWS-AWSManagedRulesCommonRuleSet"
      priority = 1

      override_action {
        none {} # Use AWS default action (block/count) for each rule
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesCommonRuleSet"
          vendor_name = "AWS"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "${var.project_name}-CommonRuleSet-${var.environment}"
        sampled_requests_enabled   = true
      }
    }
  }

  # ── Rule 2: Known Bad Inputs Rule Set ───────────────────
  # Blocks requests containing patterns associated with exploitation
  # such as Log4JRCE, SSRF probes, and JavaDeserialization.
  dynamic "rule" {
    for_each = var.waf_enable_bad_inputs_rules ? [1] : []
    content {
      name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
      priority = 2

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesKnownBadInputsRuleSet"
          vendor_name = "AWS"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "${var.project_name}-KnownBadInputs-${var.environment}"
        sampled_requests_enabled   = true
      }
    }
  }

  # ── Rule 3: SQL Injection (SQLi) Rule Set ───────────────
  # Blocks requests that contain SQL injection patterns.
  dynamic "rule" {
    for_each = var.waf_enable_sqli_rules ? [1] : []
    content {
      name     = "AWS-AWSManagedRulesSQLiRuleSet"
      priority = 3

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesSQLiRuleSet"
          vendor_name = "AWS"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "${var.project_name}-SQLiRuleSet-${var.environment}"
        sampled_requests_enabled   = true
      }
    }
  }

  # ── Web ACL-level CloudWatch visibility ─────────────────
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project_name}-WebACL-${var.environment}"
    sampled_requests_enabled   = true
  }

  tags = {
    Name = "${var.project_name}-web-acl-${var.environment}"
  }
}

# ─────────────────────────────────────────────
# Associate WAF Web ACL with the ALB
# ─────────────────────────────────────────────
resource "aws_wafv2_web_acl_association" "alb" {
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.secure-waf.arn
}
