module "acr" {
  source = "./modules/acr"

  application                               = var.application
  environment                               = var.environment
  terraform_tags                            = var.terraform_tags
  acr-token-enabled                         = var.acr-token-enabled

}

