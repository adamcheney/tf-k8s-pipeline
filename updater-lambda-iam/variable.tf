variable "default_tags" {
  description = "Default tags"
  type        = map(string)
}

variable "cluster_short_uid" {
  description = "Short cluster class identifier"
  type        = string
}

variable "pk8s_conf_arn" {
  description = "ARN of S3 bucket to store Kora namespace config details"
  type        = string
}

variable "kms_arn" {
  description = "ARN of KMS key used to encrypt S3"
  type        = string
}

variable "lock_table_arn" {
  description = "ARN of dynamodb table used for locking namespace"
  type        = string
}


variable "eks_endpoint_param_arn" {
  description = "ARN of the SSM Paramter containing the EKS cluster endpoint"
  type        = string
}


variable "eks_ca_cert_param_arn" {
  description = "ARN of the SSM Paramter containing the EKS cluster CA cert"
  type        = string
}
