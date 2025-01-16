terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "terraform-state-homer"
    key            = "state/website/resources.tfstate"
    region         = "us-east-1"
    encrypt        = true
    kms_key_id     = "alias/state-bucket-key"
    dynamodb_table = "terraform-state-homer"
    profile        = "richard"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "richard"
  default_tags {
    tags = {
      "Creator"     = "Terraform"
      "Environment" = "${local.environment}"
      "Site"        = "${local.site}"
      "Module"      = "terraform.git/aws/environments/homer/provider.tf"
    }
  }
}
