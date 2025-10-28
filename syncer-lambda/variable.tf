variable "default_tags" {
  description = "Default tags"
  type        = map(string)
}

variable "cluster_class" {
  description = "Short identifier for the cluster class"
  type        = string
}

variable "cluster_short_uid" {
  description = "Short cluster class identifier"
  type        = string
}

variable "eks_region" {
  description = "AWS region ID for the EKS cluster"
  type        = string
}


variable "lambda_name" {
  description = "Lambda name"
  type        = string
}

variable "lambda_ecr_repo" {
  description = "Lambda name"
  type        = string
}

variable "updater_arn" {
  description = "ARN of the updater lambda"
  type        = string
}

variable "pk8s_conf_name" {
  description = "Name of S3 bucket to store Kora namespace config details"
  type        = string
}

variable "pk8s_conf_arn" {
  description = "ARN of S3 bucket to store Kora namespace config details"
  type        = string
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

variable "environment_variables" {
  description = "Environment variables"
  type        = map(string)
  default     = {}
}

variable "kms_arn" {
  description = "ARN of KMS key used to encrypt S3"
  type        = string
}

variable "syncer_role_arn" {
  description = "ARN of exec role for syncer Lambda"
  type        = string
}
