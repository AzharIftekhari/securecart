#Create Web ACL
resource "aws_wafv2_web_acl" "securecart-waf" {
  name        = "securecart-web-acl"
  description = "WAF for SecureCart"
  scope       = "REGIONAL"   # Use REGIONAL for ALB / API Gateway

  default_action {
    allow {}   # Default: allow traffic unless blocked by rules
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "securecartWebACL"
    sampled_requests_enabled   = true
  }


#Managed Rule Groups

#Common Rule Set
  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}   # Uses AWS default actions (block/count)
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CommonRuleSet"
      sampled_requests_enabled   = true
    }
  }
  #Known Bad Inputs Rule Set
    rule {
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
      metric_name                = "KnownBadInputs"
      sampled_requests_enabled   = true
    }
    } 

  #SQL Injection Protection
    rule {
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
      metric_name                = "SQLiRuleSet"
      sampled_requests_enabled   = true
    }
  }  
  }

#Associate WAF with ALB
resource "aws_wafv2_web_acl_association" "securecart-waf-assoc" {
  resource_arn = aws_lb.securecart-alb.arn
  web_acl_arn  = aws_wafv2_web_acl.securecart-waf.arn
}
  