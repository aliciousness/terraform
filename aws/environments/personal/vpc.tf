module "vpc-personal" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name                                   = "${local.application}-${local.environment}"
  cidr                                   = "10.0.0.0/16"
  enable_dns_support                     = true
  enable_dns_hostnames                   = true
  azs                                    = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets                        = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets                         = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  database_subnets                       = ["10.0.201.0/24", "10.0.202.0/24", "10.0.203.0/24"]
  create_database_internet_gateway_route = true
  create_database_subnet_group           = true
  enable_nat_gateway                     = true
  single_nat_gateway                     = false
  one_nat_gateway_per_az                 = false
  enable_vpn_gateway                     = false
  tags                                   = data.aws_default_tags.current.tags
}
