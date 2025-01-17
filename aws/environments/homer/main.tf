module "family-s3" {
  source = "../../modules/s3"

  application    = "homer"
  environment    = "family"
  terraform_tags = ["Terraform", "Website", "terraform/aws/modules/main.tf"]
}
