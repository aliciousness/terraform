resource "aws_ssm_parameter" "api_key_parameter" {
  name  = "/${local.name}/api-key"
  type  = "SecureString"
  value = aws_api_gateway_api_key.api_key.value
}

resource "aws_ssm_parameter" "custom_header_parameter" {
  name  = "/${local.name}/custom-header"
  type  = "SecureString"
  value = var.custom_header_value != "" ? var.custom_header_value : random_password.custom_header_value.result
}

resource "aws_ssm_parameter" "telegram_bot_token_parameter" {
  name  = "/${local.name}/telegram-bot-token"
  type  = "SecureString"
  value = var.telegram_bot_token
}

resource "aws_ssm_parameter" "telegram_chat_id_parameter" {
  name  = "/${local.name}/telegram-chat-id"
  type  = "SecureString"
  value = var.telegram_chat_id
}
