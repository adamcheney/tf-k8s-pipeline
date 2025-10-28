terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  alias   = "dev"
  region  = "ap-southeast-2"
  profile = "Developer-k8s-test"
  ignore_tags {
    key_prefixes = ["managed:"]
  }
}

provider "aws" {
  alias   = "iam"
  region  = "ap-southeast-2"
  profile = "ClusterAdmin-k8s-test"
  ignore_tags {
    key_prefixes = ["managed:"]
  }
}

provider "aws" {
  alias   = "eks"
  region  = "ap-southeast-2"
  profile = "ClusterAdmin-platform-test"
  ignore_tags {
    key_prefixes = ["managed:"]
  }
}

# k8s-test
# provider "aws" {
#   alias  = "dev"
#   region = "ap-southeast-2"
#   profile  = "ClusterAdmin-k8s-prod"      # <-- HERE!
#   assume_role {
#     role_arn = "arn:aws:iam::026739827646:role/ClusterAdmin"
#   }
# }

# platform-test
# provider "aws" {
#   alias  = "eks"
#   region = "ap-southeast-2"
#   profile  = "ClusterAdmin-k8s-prod"      # <-- HERE!
#   assume_role {
#     role_arn = "arn:aws:iam::046921848075:role/ClusterAdmin"
#   }
# }


# TODO: implement remote state datasource here to consume outputs from central module.

data "aws_s3_bucket" "k8s_conf_bucket" {
  provider = aws.dev
  bucket   = var.pk8s_conf
}

module "updater_lambda_iam" {
  source                 = "./updater-lambda-iam"
  providers              = { aws = aws.iam }
  default_tags           = var.default_tags
  cluster_short_uid      = var.cluster_short_uid
  pk8s_conf_arn          = data.aws_s3_bucket.k8s_conf_bucket.arn
  kms_arn                = var.kms_arn
  lock_table_arn         = module.updater_lambda.updater_locktable_arn
  eks_endpoint_param_arn = module.updater_lambda.eks_endpoint_param_arn
  eks_ca_cert_param_arn  = module.updater_lambda.eks_ca_cert_param_arn
}

module "updater_lambda" {
  source                 = "./updater-lambda"
  providers              = { aws = aws.dev }
  lambda_name            = "autobots-kora-k8s-updater"
  lambda_ecr_repo        = "ns-updater"
  default_tags           = var.default_tags
  cluster_class          = var.cluster_class
  cluster_short_uid      = var.cluster_short_uid
  eks_short_name         = var.eks_short_name
  eks_region             = var.eks_region
  eks_account_id         = var.eks_account_id
  pk8s_conf_name         = data.aws_s3_bucket.k8s_conf_bucket.bucket
  pk8s_conf_arn          = data.aws_s3_bucket.k8s_conf_bucket.arn
  updater_role_arn       = module.updater_lambda_iam.updater_lambda_exec_role_arn
  config_aws_auth_prefix = var.config_aws_auth_prefix
  config_k8s_yaml_prefix = var.config_k8s_yaml_prefix
  kms_arn                = var.kms_arn
  eks_endpoint           = module.eks_auth.cluster_endpoint
  eks_ca_cert            = module.eks_auth.cluster_ca_cert
}

module "syncer_lambda_iam" {
  source            = "./syncer-lambda-iam"
  providers         = { aws = aws.iam }
  default_tags      = var.default_tags
  cluster_short_uid = var.cluster_short_uid
  pk8s_conf_arn     = data.aws_s3_bucket.k8s_conf_bucket.arn
  updater_arn       = module.updater_lambda.updater_lambda_arn
  kms_arn           = var.kms_arn
}

module "syncer_lambda" {
  source                 = "./syncer-lambda"
  providers              = { aws = aws.dev }
  lambda_name            = "autobots-kora-k8s-syncer"
  lambda_ecr_repo        = "syncer"
  default_tags           = var.default_tags
  cluster_class          = var.cluster_class
  cluster_short_uid      = var.cluster_short_uid
  eks_region             = var.eks_region
  updater_arn            = module.updater_lambda.updater_lambda_arn
  pk8s_conf_name         = data.aws_s3_bucket.k8s_conf_bucket.bucket
  pk8s_conf_arn          = data.aws_s3_bucket.k8s_conf_bucket.arn
  syncer_role_arn        = module.syncer_lambda_iam.syncer_lambda_exec_role_arn
  config_aws_auth_prefix = var.config_aws_auth_prefix
  config_k8s_yaml_prefix = var.config_k8s_yaml_prefix
  kms_arn                = var.kms_arn
}

module "eks_auth" {
  source           = "./eks-access"
  providers        = { aws = aws.eks }
  default_tags     = var.default_tags
  updater_role_arn = module.updater_lambda_iam.updater_lambda_exec_role_arn
  eks_short_name   = var.eks_short_name
  eks_account_id   = var.eks_account_id
  eks_region       = var.eks_region
}

