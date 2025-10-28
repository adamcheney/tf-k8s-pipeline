# TODO: document eks-access submodule
locals {
  cluster_name = join("_", [
    var.eks_region,
    var.eks_short_name,
    "taupua",
    "com",
  ])
}

resource "aws_eks_access_entry" "updater_eks_access" {
  cluster_name      = local.cluster_name
  principal_arn     = var.updater_role_arn
  kubernetes_groups = []
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "updater_eks_admin" {
  cluster_name  = local.cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = var.updater_role_arn

  access_scope {
    type       = "cluster"
    namespaces = []
  }
}

data "aws_eks_cluster" "k8s" {
  name = local.cluster_name
}
