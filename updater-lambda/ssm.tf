resource "aws_ssm_parameter" "eks_endpoint" {
  name   = "/pk8s/${var.eks_short_name}/endpoint"
  type   = "SecureString"
  value  = var.eks_endpoint
  key_id = var.kms_arn
}

resource "aws_ssm_parameter" "eks_ca_cert" {
  name   = "/pk8s/${var.eks_short_name}/ca_cert"
  type   = "SecureString"
  value  = var.eks_ca_cert
  key_id = var.kms_arn
}
