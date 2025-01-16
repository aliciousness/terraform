data "aws_default_tags" "current" {}

locals {
  application = "website"
  environment = "personal"
  site        = "richardcraddock.me"
}
