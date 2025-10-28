################################################################################
# Defaults set here
################################################################################

variable "default_tags" {
  description = "Default tags"
  type        = map(string)
  default = {
    "created-by"             = "terraform"
    "dataclassification"     = "Sensitive-np"
    "dataclassificationdate" = "2024-03-14"
    "owner"                  = "support@taupua.com"
    "managed-by"             = "terraform"
    "uuid"                   = "Nd5323RojIwfMFWEsjsIAL"
  }
}

################################################################################
# Values passed in
################################################################################

variable "cluster_class" {
  description = "Short cluster class identifier"
  type        = string
  default     = "test-dev"
}

variable "cluster_short_uid" {
  description = "Short cluster class identifier"
  type        = string
  default     = "test-dev"
}

variable "eks_short_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "k8s-platform-test-dev-rua"
}

variable "eks_region" {
  description = "AWS region ID for the EKS cluster"
  type        = string
  default     = "ap-southeast-2"
}

variable "eks_account_id" {
  description = "AWS account ID for the EKS cluster"
  type        = string
  default     = "026739827646" # k8s-test
}

variable "config_aws_auth_prefix" {
  description = "Prefix for admin users and CICD roles pre-processing"
  type        = string
  default     = "aws-auth"
}

variable "config_k8s_yaml_prefix" {
  description = "Prefix for yaml files to be applied to clusters"
  type        = string
  default     = "k8s-yaml"
}

variable "kms_arn" {
  description = "ARN of KMS key used to encrypt S3"
  type        = string
  default     = "arn:aws:kms:ap-southeast-2:333186395126:key/mrk-21c8eeb042724242a7db0f61b5644840"
}

variable "pk8s_conf" {
  description = "S3 bucket name to store Kora namespace config details"
  type        = string
  default     = "kora-k8s-ns-conf"
}

variable "pk8s_conf_role" {
  description = "Name of IAM role to access S3 bucket"
  type        = string
  default     = "kora-k8s-conf-S3Access"
}
