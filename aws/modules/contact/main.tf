data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  name = "${var.application}-${var.environment}-contact"
  tags = MergeMaps(var.terraform_tags, {
    "Name" = "${var.application}-${var.environment}-contact"
  })
}

resource "null_resource" "lambda_zip" {
  provisioner "local-exec" {
    command = "zip -j ${path.module}/lambda_function.zip ${path.module}/lambda_function/lambda_function.py"
  }
}

resource "null_resource" "authorizer" {
  provisioner "local-exec" {
    command = "zip -j ${path.module}/authorizer.zip ${path.module}/lambda_authorizer/authorizer.py"
  }
}

resource "random_password" "custom_header_value" {
  length           = 32
  special          = false
  override_special = "/@\""
}
