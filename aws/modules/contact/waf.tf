resource "aws_wafv2_web_acl" "api_gateway" {
  count       = var.enable_waf ? 1 : 0
  name        = "${local.name}-web-acl"
  description = "WAF rules for API Gateway"
  scope       = var.waf_scope

  default_action {
    allow {}
  }

  rule {
    name     = "RateLimit"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 1000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimitMetric"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "APIGatewayWebACLMetric"
    sampled_requests_enabled   = true
  }
}
