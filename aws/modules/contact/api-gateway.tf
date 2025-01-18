resource "aws_api_gateway_rest_api" "rest_api" {
  name = "${local.name}-api"
}

resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "contact"
}

resource "aws_api_gateway_method" "api_method" {
  rest_api_id      = aws_api_gateway_rest_api.rest_api.id
  resource_id      = aws_api_gateway_resource.api_resource.id
  http_method      = "POST"
  authorization    = "NONE"
  api_key_required = true

  request_validator_id = aws_api_gateway_request_validator.validator.id
  request_models = {
    "application/json" = aws_api_gateway_model.contact_model.name
  }
}

resource "aws_api_gateway_integration" "api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.api_resource.id
  http_method             = aws_api_gateway_method.api_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.lambda.invoke_arn
}

# CORS Configuration
resource "aws_api_gateway_method" "options_method" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.api_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_method_response" "options_method_response" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_method_response" "api_method_response" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.api_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_deployment" "production" {
  depends_on = [
    aws_api_gateway_integration.api_integration,
    aws_api_gateway_integration.options_integration,
    aws_api_gateway_method_response.api_method_response
  ]
  rest_api_id = aws_api_gateway_rest_api.rest_api.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "production" {
  deployment_id = aws_api_gateway_deployment.production.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = "production"

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway.arn
    format = jsonencode({
      requestId      = "$context.requestId"
      ip             = "$context.identity.sourceIp"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      resourcePath   = "$context.resourcePath"
      status         = "$context.status"
      protocol       = "$context.protocol"
      responseLength = "$context.responseLength"
      userAgent      = "$context.identity.userAgent"
    })
  }

  cache_cluster_enabled = var.cache_cluster_enabled
  cache_cluster_size    = var.cache_cluster_size # Smallest available size (0.5GB)

  variables = {
    "cache_enabled" = var.cache_cluster_enabled != false ? "true" : "false"
  }
}

resource "aws_api_gateway_method_settings" "settings" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = aws_api_gateway_stage.production.stage_name
  method_path = "*/*"

  settings {
    caching_enabled        = var.cache_cluster_enabled
    cache_ttl_in_seconds   = var.cache_cluster_enabled == true ? var.cache_ttl_in_seconds : 0
    metrics_enabled        = var.metrics_enabled
    logging_level          = var.logging_level
    throttling_rate_limit  = var.throttling_rate_limit
    throttling_burst_limit = var.throttling_burst_limit
  }
}

resource "aws_api_gateway_request_validator" "validator" {
  name                        = "${var.application}-contact-validator"
  rest_api_id                 = aws_api_gateway_rest_api.rest_api.id
  validate_request_body       = true
  validate_request_parameters = true
}

resource "aws_api_gateway_model" "contact_model" {
  rest_api_id  = aws_api_gateway_rest_api.rest_api.id
  name         = "${var.application}ContactModel"
  description  = "Contact form validation model"
  content_type = "application/json"

  schema = jsonencode({
    type     = "object"
    required = ["email", "message"]
    properties = {
      email = {
        type   = "string",
        format = "email"
      }
      message = {
        type      = "string",
        minLength = 1
      }
    }
  })
}

resource "aws_api_gateway_api_key" "api_key" {
  name = "${local.name}-api-key"
}

resource "aws_api_gateway_usage_plan" "usage_plan" {
  name = "${local.name}-usage-plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.rest_api.id
    stage  = aws_api_gateway_stage.production.stage_name
  }

  quota_settings {
    limit  = var.usage_plan_quota_limit
    period = var.usage_plan_quota_period
  }

  throttle_settings {
    burst_limit = var.usage_plan_throttle_burst_limit
    rate_limit  = var.usage_plan_throttle_rate_limit
  }
}

resource "aws_api_gateway_usage_plan_key" "usage_plan_key" {
  key_id        = aws_api_gateway_api_key.api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.usage_plan.id
}

resource "aws_api_gateway_account" "api_gateway_account" {
  cloudwatch_role_arn = aws_iam_role.api_gateway_cloudwatch.arn
}

resource "aws_wafv2_web_acl_association" "api_gateway" {
  count        = var.enable_waf ? 1 : 0
  resource_arn = aws_api_gateway_stage.production.arn
  web_acl_arn  = aws_wafv2_web_acl.api_gateway[0].arn
}
