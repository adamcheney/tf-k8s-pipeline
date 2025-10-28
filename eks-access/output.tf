output cluster_endpoint {
  description = "EKS cluster endpoint"
  value       = data.aws_eks_cluster.k8s.endpoint
}

output cluster_ca_cert {
  description = "KS cluster CA cert"
  value       = data.aws_eks_cluster.k8s.certificate_authority[0].data
}
