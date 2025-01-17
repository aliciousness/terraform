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

output "custom_header_value" {
  value = var.custom_header_value != "" ? var.custom_header_value : random_password.custom_header_value.result
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
