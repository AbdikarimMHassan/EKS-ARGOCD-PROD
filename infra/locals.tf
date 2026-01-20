locals {
  name   = "eks-prod"
  domain = "eks.abdikarim-tech.com"
  region = "eu-north-1"

  tags = {
    Environment = "prod"
    Project     = "eks-prod"
    Owner       = "abdikarim"
  }

}


