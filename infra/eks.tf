
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = local.name
  cluster_version = "1.31"

  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = [var.my_ip]

  enable_irsa = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  control_plane_subnet_ids = module.vpc.public_subnets

  eks_managed_node_groups = {
    default = {
      min_size       = 1
      max_size       = 3
      desired_size   = 2
      instance_types = ["t3.medium"]
      disk_size      = 50
    }
  }

  access_entries = {
    # Admin User access to cluster
    admin = {
      principal_arn = "arn:aws:iam::779846800049:user/akarim"
      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
    # Github Actions Role
    ci_pipeline = {
      principal_arn = var.terraform_deploy_arn
      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  tags = local.tags
}
