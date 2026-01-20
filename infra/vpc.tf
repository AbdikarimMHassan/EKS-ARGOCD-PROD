module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "5.9.0"
  name                 = local.name
  azs                  = ["${local.region}a", "${local.region}b", "${local.region}c"]
  cidr                 = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true

  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  tags            = local.tags

}