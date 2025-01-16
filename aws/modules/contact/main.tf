data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  name = "${var.application}-${var.environment}-contact"
  tags = merge(var.terraform_tags, {
    "Name" = "${var.application}-${var.environment}-contact"
  })
  prefix = "/${var.application}/${var.environment}"
  lambda_response_headers = {
    "Access-Control-Allow-Origin"      = "*"
    "Access-Control-Allow-Headers"     = "Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,x-custom-header"
    "Access-Control-Allow-Methods"     = "OPTIONS,POST"
    "Access-Control-Allow-Credentials" = "true"
  }
}

resource "random_password" "custom_header_value" {
  length           = 32
  special          = false
  override_special = "/@\"?&"
}