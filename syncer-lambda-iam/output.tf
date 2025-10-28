output "syncer_lambda_exec_role_arn" {
  description = "ARN of the created kora-k8s-syncer Lambda execution role"
  value       = aws_iam_role.syncer_lambda_exec_role.arn
}
