variable "default_tags" {
  description = "Default tags"
  type        = map(string)
}

variable "pk8s_conf_arn" {
  description = "ARN of S3 bucket to store Kora namespace config details"
  type        = string
}

variable "cluster_short_uid" {
  description = "Short cluster class identifier"
  type        = string
}

variable "updater_arn" {
  description = "Updater Lambda ARN"
  type        = string
}

variable "kms_arn" {
  description = "ARN of KMS key used to encrypt S3"
  type        = string
}
