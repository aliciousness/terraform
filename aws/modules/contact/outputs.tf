output "lambda_function_arn" {
  value = aws_lambda_function.lambda.arn
}

output "api_gateway_url" {
  value = aws_api_gateway_deployment.api_deployment.invoke_url
}

output "authorizer_arn" {
  value = aws_lambda_function.authorizer.arn
}

output "custom_header_value" {
  value = var.custom_header_value != "" ? var.custom_header_value : random_password.custom_header_value.result
}
