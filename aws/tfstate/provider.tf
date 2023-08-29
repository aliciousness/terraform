terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 4.0"
   }
 }
 backend "s3" {
   bucket         = "terraform-state-homer"
   key            = "state/homer/tfstate.tfstate"
   region         = "us-east-1"
   encrypt        = true
   kms_key_id     = "alias/state-bucket-key"
   dynamodb_table = "terraform-state-homer"
 }
}

provider "aws" {
 region = "us-east-1"
}
