resource "aws_ssm_parameter" "telegram_bot_token_parameter" {
  name  = "${local.prefix}/telegram-bot-token"
  type  = "SecureString"
  value = var.telegram_bot_token
}

resource "aws_ssm_parameter" "telegram_chat_id_parameter" {
  name  = "${local.prefix}/telegram-chat-id"
  type  = "SecureString"
  value = var.telegram_chat_id
}
