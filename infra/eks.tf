module "eks" {
  source                         = "terraform-aws-modules/eks/aws"
  version                        = "20.2.0"
  cluster_name                   = local.name
  cluster_version                = "1.27"
  cluster_endpoint_public_access = true #accessable from my ip only
  cluster_endpoint_public_access_cidrs  = [var.my_ip]
  enable_irsa                    = true
  subnets                        = module.vpc.private_subnets
  control_plane_subnet_ids       = module.vpc.public_subnets
  vpc_id                         = module.vpc.vpc_id

  eks_managed_node_group_defaults = {
    disk_size      = 50
    instance_types = ["t3a.large", "t3.large"]
  }

  eks_managed_node_groups = {
    defaults = {}
  }

  tags = local.tags

}


access_entries = {
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
}
