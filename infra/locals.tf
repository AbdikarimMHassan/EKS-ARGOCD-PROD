locals {
  name   = "eks-prod"
  region = "eu-north-1"

  tags = {
    Environment = "prod"
    Project     = "eks-prod"
    Owner       = "abdikarim"
  }

}


