output "lambda" {
  value = {
    lambda = {
      function_name = aws_lambda_function.lambda.function_name
      arn           = aws_lambda_function.lambda.arn
    }
  }
}

output "api_gateway" {
  value = {
    api_id     = aws_api_gateway_rest_api.rest_api.id
    invoke_url = aws_api_gateway_deployment.production.invoke_url
  }
}

output "waf" {
  value = {
    enabled     = var.enable_waf
    web_acl_id  = var.enable_waf ? aws_wafv2_web_acl.api_gateway[0].id : null
    web_acl_arn = var.enable_waf ? aws_wafv2_web_acl.api_gateway[0].arn : null
  }
}

output "cloudwatch" {
  value = {
    lambda_log_group      = aws_cloudwatch_log_group.lambda.name
    api_gateway_log_group = aws_cloudwatch_log_group.api_gateway.name
  }
}

output "ssm" {
  value = {
    telegram_bot_token_parameter = aws_ssm_parameter.telegram_bot_token_parameter.name
    telegram_chat_id_parameter   = aws_ssm_parameter.telegram_chat_id_parameter.name
    prefix                       = local.prefix
  }
}

output "iam" {
  value = {
    lambda_role = aws_iam_role.lambda_role.name
  }
}
