module "family-s3" {
  source = "./s3"

  application    = var.application
  environment    = var.environment
  terraform_tags = var.terraform_tags
}

module "resume_contact" {
  source = "./contact"

  application    = var.application
  environment    = var.environment
  terraform_tags = var.terraform_tags
}
