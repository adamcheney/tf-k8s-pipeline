output "updater_lambda_arn" {
  description = "ARN of the created kora-k8s-updater Lambda"
  value       = aws_lambda_function.k8s_updater_lambda.arn
}

output "updater_locktable_arn" {
  description = "ARN of the dynamodb lock table"
  value       = aws_dynamodb_table.updater_lock_table.arn
}

output "eks_endpoint_param_arn" {
  description = "ARN of the SSM Parameter containing the EKS cluster endpoint"
  value       = aws_ssm_parameter.eks_endpoint.arn
}

output "eks_ca_cert_param_arn" {
  description = "ARN of the SSM Parameter containing the EKS cluster CA cert"
  value       = aws_ssm_parameter.eks_ca_cert.arn
}
