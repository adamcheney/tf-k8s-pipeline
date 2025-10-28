variable "default_tags" {
  description = "Default tags"
  type        = map(string)
}

variable "updater_role_arn" {
  description = "Updater Lambda ARN"
  type        = string
}

variable "eks_short_name" {
  description = "Short name of EKS cluster"
  type        = string
}

variable "eks_account_id" {
  description = "AWS account id of EKS cluster"
  type        = string
}

variable "eks_region" {
  description = "AWS region of EKS cluster"
  type        = string
}
