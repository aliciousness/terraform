module "resume_contact" {
  source = "../../modules/contact"

  application        = local.application
  environment        = local.environment
  terraform_tags     = data.aws_default_tags.current.tags
  telegram_chat_id   = var.telegram_chat_id
  telegram_bot_token = var.telegram_bot_token
  vpc                = module.vpc-personal
}
