output "updater_lambda_exec_role_arn" {
  description = "ARN of the created kora-k8s-updater Lambda execution role"
  value       = aws_iam_role.updater_lambda_exec_role.arn
}
